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