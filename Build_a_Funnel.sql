-- Build a Funnel From a Single Table

-- We want to build a funnel to analyze if certain questions prompted users to stop working on the survey.

-- 1: What is the number of responses to each Question?

SELECT question_text,
  COUNT(DISTINCT user_id)
FROM survey_responses
GROUP BY 1;

-- You could look at differences in completion rates between questions to determine which kept people from moving forward with the survey.

-- Compare funnels for AB Testing:
