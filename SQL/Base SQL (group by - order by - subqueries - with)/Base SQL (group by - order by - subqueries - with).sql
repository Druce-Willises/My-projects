--	1

SELECT COUNT(id)
FROM company
WHERE status = 'closed';

--	2

SELECT funding_total 
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
ORDER BY funding_total DESC;

--	3

SELECT SUM(price_amount)
FROM acquisition
WHERE EXTRACT(YEAR FROM CAST(acquired_at AS date)) BETWEEN 2011 AND 2013
      AND term_code = 'cash';

--	4

SELECT first_name, last_name, twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';

--	5

SELECT *
FROM people
WHERE twitter_username LIKE '%money%'
      AND last_name LIKE 'K%' ;

--	6

SELECT country_code, SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;

--	7

SELECT CAST(funded_at AS date),
       MIN(raised_amount) AS min_raised_amount,
       MAX(raised_amount) AS max_raised_amount
FROM funding_round
GROUP BY CAST(funded_at AS date)
HAVING MIN(raised_amount) <> 0 AND MIN(raised_amount) <> MAX(raised_amount);

--	8

SELECT *,
       CASE 
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20 AND invested_companies < 100 THEN 'middle_activity'
           WHEN invested_companies < 20 THEN 'low_activity'
       END AS avtivity
FROM fund;

--	9

SELECT CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds)) as avg_investment_rounds
FROM fund
GROUP BY activity
ORDER BY avg_investment_rounds;

--	10

SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) <> 0
ORDER BY AVG(invested_companies) DESC, country_code
LIMIT 10;

--	11

SELECT first_name,
       last_name,
       e.instituition	
FROM people as p
LEFT OUTER JOIN education as e ON e.person_id = p.id;

--	12

SELECT c.name,
       COUNT(DISTINCT e.instituition)
FROM company as c
INNER JOIN people AS p ON c.id = p.company_id
INNER JOIN education AS e ON p.id = e.person_id
GROUP BY c.name
ORDER BY COUNT(DISTINCT e.instituition) DESC
LIMIT 5

--	13

SELECT DISTINCT name
FROM company
WHERE id IN (SELECT company_id
             FROM funding_round
             WHERE is_first_round = 1 AND is_last_round = 1)
      AND status = 'closed'

--	14

WITH closed_one_round AS (SELECT id
                          FROM company
                          WHERE id IN (SELECT company_id
                                       FROM funding_round
                                       WHERE is_first_round = 1 AND is_last_round = 1)
                                AND status = 'closed')
                                
SELECT DISTINCT p.id
FROM closed_one_round
INNER JOIN people AS p ON closed_one_round.id = p.company_id;


--	15

WITH closed_one_round AS (SELECT id
                          FROM company
                          WHERE id IN (SELECT company_id
                                       FROM funding_round
                                       WHERE is_first_round = 1 AND is_last_round = 1)
                                AND status = 'closed')
                                
SELECT DISTINCT p.id,
       e.instituition
FROM closed_one_round
INNER JOIN people AS p ON closed_one_round.id = p.company_id
INNER JOIN education AS e ON p.id = e.person_id;

--	16

WITH closed_one_round AS (SELECT id
                          FROM company
                          WHERE id IN (SELECT company_id
                                       FROM funding_round
                                       WHERE is_first_round = 1 AND is_last_round = 1)
                                AND status = 'closed');
                                
SELECT p.id,
       COUNT(e.instituition)
FROM closed_one_round
INNER JOIN people AS p ON closed_one_round.id = p.company_id
INNER JOIN education AS e ON p.id = e.person_id
GROUP BY p.id;


--	17

WITH
closed_one_round AS (SELECT id
                          FROM company
                          WHERE id IN (SELECT company_id
                                       FROM funding_round
                                       WHERE is_first_round = 1 AND is_last_round = 1)
                                AND status = 'closed'),
                                
count_inst AS (SELECT p.id,
                      COUNT(e.instituition)
               FROM closed_one_round
               INNER JOIN people AS p ON closed_one_round.id = p.company_id
               INNER JOIN education AS e ON p.id = e.person_id
               GROUP BY p.id)

SELECT AVG(count)
FROM count_inst

--	18

WITH
facebook AS (SELECT id
                          FROM company
                          WHERE name = 'Facebook'),
                                
count_inst AS (SELECT p.id,
                      COUNT(e.instituition)
               FROM facebook
               INNER JOIN people AS p ON facebook.id = p.company_id
               INNER JOIN education AS e ON p.id = e.person_id
               GROUP BY p.id)

SELECT AVG(count)
FROM count_inst

--	19

WITH
filter_rounds AS (SELECT *
                  FROM funding_round
                  WHERE EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2012 AND 2013),
   
filter_companies AS (SELECT *
                     FROM company
                     WHERE milestones > 6)   
   
SELECT f.name AS name_of_fund,
       fc.name AS name_of_company ,
       fr.raised_amount AS amount 
       
FROM investment as i
INNER JOIN filter_companies AS fc ON i.company_id = fc.id
INNER JOIN fund AS f ON i.fund_id = f.id
INNER JOIN filter_rounds AS fr ON i.funding_round_id = fr.id


--	20

SELECT c.name AS acquiring_company_name,
       price_amount,
       com.name AS acquired_company_name,
       com.funding_total,
       ROUND(price_amount / com.funding_total) AS margin
       
FROM acquisition as a
LEFT OUTER JOIN company as c ON a.acquiring_company_id = c.id
LEFT OUTER JOIN company as com ON a.acquired_company_id = com.id
WHERE price_amount <> 0
      AND com.funding_total <> 0
ORDER BY price_amount DESC, acquired_company_name
LIMIT 10

--	21

SELECT c.name, EXTRACT(month FROM CAST(funded_at AS date)) AS month
FROM funding_round as fr
LEFT OUTER JOIN company as c ON fr.company_id = c.id
WHERE EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2010 AND 2013
      AND company_id IN(SELECT id
                        FROM company
                        WHERE category_code = 'social')
      AND raised_amount <> 0

--	22

WITH
filter_fund AS (SELECT *
                FROM fund
                WHERE country_code = 'USA'),
              
funds_USA AS (SELECT EXTRACT(month FROM CAST(funded_at AS date)) as month,
              COUNT(DISTINCT f.name) AS fund_names_USA
       FROM funding_round AS fr
       INNER JOIN investment AS i ON fr.id = i.funding_round_id
       INNER JOIN filter_fund AS f ON i.fund_id = f.id
       WHERE EXTRACT(YEAR FROM CAST(funded_at AS date)) BETWEEN 2010 AND 2013
       GROUP BY month),
       
acq AS (SELECT EXTRACT(month FROM CAST(acquired_at AS date)) AS month,
               COUNT(acquired_company_id) AS asquired_companies,
               SUM(price_amount) AS total_amount
        FROM acquisition
        WHERE EXTRACT(YEAR FROM CAST(acquired_at AS date)) BETWEEN 2010 AND 2013
        GROUP BY month)

SELECT fu.month,
       fund_names_USA,
       asquired_companies,
       total_amount
FROM funds_USA as fu
INNER JOIN acq ON fu.month = acq.month

--	23

WITH

year_2011 AS (SELECT country_code,
                     AVG(funding_total) AS rev_2011
              FROM company as c
              WHERE EXTRACT(YEAR FROM CAST(c.founded_at as date)) = 2011
              GROUP BY country_code),
             
year_2012 AS (SELECT country_code,
                    AVG(funding_total) AS rev_2012
              FROM company as c
              WHERE EXTRACT(YEAR FROM CAST(c.founded_at as date)) = 2012
              GROUP BY country_code),             
             
year_2013 AS (SELECT country_code,
                    AVG(funding_total) AS rev_2013
              FROM company as c
              WHERE EXTRACT(YEAR FROM CAST(c.founded_at as date)) = 2013
              GROUP BY country_code)            

SELECT year_2011.country_code,
       rev_2011,
       rev_2012,
       rev_2013
FROM year_2011
INNER JOIN year_2012 ON year_2011.country_code = year_2012.country_code
INNER JOIN year_2013 ON year_2012.country_code = year_2013.country_code
WHERE year_2011.country_code IS NOT NULL
ORDER BY rev_2011 DESC
