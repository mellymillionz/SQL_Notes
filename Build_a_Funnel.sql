-- Build a Funnel From a Single Table

-- We want to build a funnel to analyze if certain questions prompted users to stop working on the survey.

-- 1: What is the number of responses to each Question?

SELECT question_text,
  COUNT(DISTINCT user_id)
FROM survey_responses
GROUP BY 1;

-- You could look at differences in completion rates between questions to determine which kept people from moving forward with the survey.

-- Compare funnels for AB Testing:
-- How is the funnel different between the two groups?

SELECT modal_text, 
   COUNT(DISTINCT user_id)
FROM onboarding_modals
GROUP BY 1
ORDER BY 1;

-- We can use a CASE statement within our COUNT() aggregate so that we only count user_ids whose ab_group is equal to ‘control’:

SELECT modal_text,
COUNT(DISTINCT CASE
     WHEN ab_group = 'control' THEN
     user_id
     END) AS 'control_clicks'
FROM onboarding_modals
GROUP BY 1
ORDER BY 1;

-- Add an additional column to your previous query that counts the number of clicks from the variant group 

SELECT modal_text,
COUNT(DISTINCT CASE
     WHEN ab_group = 'control' THEN
     user_id
     END) AS 'control_clicks',
COUNT(DISTINCT CASE
     WHEN ab_group = 'variant' THEN 
     user_id END) AS 'variant_clicks'
FROM onboarding_modals
GROUP BY 1
ORDER BY 1;

-- ABOVE now you can compare completion rates between the control and variant groups! Here, variant has a greater completion rate.

-- Now let’s see how we can create a funnel from multiple tables using LEFT JOIN!
-- Purchase funnel:
-- The user browses products and adds them to their cart
-- The user proceeds to the checkout page
-- The user enters credit card information and makes a purchase
-- As Christmas approaches, you suspect that customers become more likely to purchase items in their cart (i.e., they move from window shopping to buying presents).

 SELECT * 
 FROM browse as b
 LEFT JOIN checkout as c
 ON c.user_id = b.user_id
 LEFT JOIN purchase as p
 ON p.user_id = c.user_id
 LIMIT 50;

 -- ABOVE, we dont actually want allll the columns so can cut it down using:

  SELECT 
 DISTINCT b.browse_date,
 b.user_id,
 c.user_id IS NOT NULL as is_checkout,
 p.user_id IS NOT NULL as is_purchase
 FROM browse as b
 LEFT JOIN checkout as c
 ON c.user_id = b.user_id
 LEFT JOIN purchase as p
 ON p.user_id = c.user_id
 LIMIT 50;

 -- Let’s query from this funnels table and calculate overall conversion rates:

 WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) as num_browse
FROM funnels;

-- Second, add another column that sums the is_checkout in funnels and one that sums purcahses

WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) as num_browse,
SUM(is_checkout) as num_checkout,
SUM(is_purchase) as num_purchase
FROM funnels;

-- Finally, Let’s add these two columns:
-- Percentage of users from browse to checkout
-- Percentage of users from checkout to purchase

WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT COUNT(*) as num_browse,
SUM(is_checkout) as num_checkout,
SUM(is_purchase) as num_purchase,
1.0 * SUM(is_checkout) / COUNT(user_id) as browse_to_checkout,
1.0 * SUM(is_purchase) / SUM(is_checkout) as checkout_to_purchase
FROM funnels;

-- The management team suspects that conversion from checkout to purchase changes as the browse_date gets closer to Christmas Day.
-- added browse_date as the fist column in non subquery and then grouped by that column

WITH funnels AS (
  SELECT DISTINCT b.browse_date,
     b.user_id,
     c.user_id IS NOT NULL AS 'is_checkout',
     p.user_id IS NOT NULL AS 'is_purchase'
  FROM browse AS 'b'
  LEFT JOIN checkout AS 'c'
    ON c.user_id = b.user_id
  LEFT JOIN purchase AS 'p'
    ON p.user_id = c.user_id)
SELECT browse_date,
COUNT(*) AS 'num_browse',
   SUM(is_checkout) AS 'num_checkout',
   SUM(is_purchase) AS 'num_purchase',
   1.0 * SUM(is_checkout) / COUNT(user_id) AS 'browse_to_checkout',
   1.0 * SUM(is_purchase) / SUM(is_checkout) AS 'checkout_to_purchase'
FROM funnels
GROUP BY browse_date
ORDER BY browse_date;

-- ABOVE Conversion from checkout to purchase increases from 80% on 12/20 to 94% on 12/23!

-- In this lesson, we learned how to build a funnel from a single table, compare funnels for A/B tests, and create a funnel from multiple tables using LEFT JOIN.
