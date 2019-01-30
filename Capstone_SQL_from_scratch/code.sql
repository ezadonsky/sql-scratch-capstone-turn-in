Query 1: survey table columns
SELECT *
FROM survey
LIMIT 10;


Query 2: number of responses
SELECT question,
COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;


QUERY 4: Home Try-On Funnel
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

QUERY 5: create table for analysis
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
ON p.user_id = q.user_id
LIMIT 10;


Query: overall conversion
WITH overall_conversion AS (
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
SUM(is_home_try_on) AS 'num_home_try_on',
SUM(is_purchase) AS 'num_purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_try_on',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_on_to_purchase'
FROM overall_conversion;


Query: purchase rate difference
WITH purchase_rates AS (
SELECT DISTINCT q.user_id,
h.user_id IS NOT NULL AS 'is_home_try_on',
h.number_of_pairs,
p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
ON p.user_id = q.user_id)
SELECT number_of_pairs,
COUNT(*) AS 'num_quiz',
SUM(is_home_try_on) AS 'num_home_try_on',
SUM(is_purchase) AS 'num_purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_try_on',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_on_to_purchase'
FROM purchase_rates
GROUP BY number_of_pairs
ORDER BY number_of_pairs;

Query:top 10 results of style quiz
SELECT question,
response,
COUNT(DISTINCT user_id)
FROM survey
GROUP BY 2
ORDER BY 3 DESC
LIMIT 10;

Query:common purchase types
SELECT model_name,
style,
COUNT(user_id) AS 'num_purchased'
FROM purchase
GROUP BY 1
ORDER BY num_purchased DESC;

QUERY: men or women?
SELECT COUNT(*) AS 'num_buyers',
style AS 'Style'
FROM purchase
GROUP BY 2;
