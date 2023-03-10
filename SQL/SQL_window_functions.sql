
--1. Найдите количество вопросов, которые набрали больше 300 очков или как минимум 100 раз были добавлены в «Закладки».

SELECT COUNT(p.id)--, id, title, score, favorites_count
FROM stackoverflow.posts p
JOIN stackoverflow.post_types t ON p.post_type_id = t.id
WHERE t.type = 'Question'
      AND (score > 300 OR favorites_count >= 100);
      
--2. Сколько в среднем в день задавали вопросов с 1 по 18 ноября 2008 включительно? Результат округлите до целого числа.
      
WITH
tmp AS (
SELECT DATE_TRUNC('day', creation_date)::date,
       COUNT(id) AS daily_questions
FROM stackoverflow.posts
WHERE DATE_TRUNC('day', creation_date) BETWEEN '2008-11-01' AND '2008-11-18'
      AND post_type_id = 1
GROUP BY DATE_TRUNC('day', creation_date)::date
ORDER BY DATE_TRUNC('day', creation_date)::date
    )
    
SELECT ROUND(AVG(daily_questions), 0)
FROM tmp;

-- 3. Сколько пользователей получили значки сразу в день регистрации? Выведите количество уникальных пользователей. 
     
SELECT COUNT (DISTINCT u.id)
FROM stackoverflow.users u 
JOIN stackoverflow.badges b ON u.id = b.user_id
WHERE DATE_TRUNC('day', u.creation_date)::date = DATE_TRUNC('day', b.creation_date)::date;

--4. Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос?

SELECT COUNT(*)
FROM (SELECT DISTINCT p.id, COUNT(v.id)
FROM stackoverflow.users u
JOIN stackoverflow.posts p ON u.id = p.user_id
JOIN stackoverflow.votes v ON p.id = v.post_id
WHERE p.id IN (SELECT DISTINCT p.id  AS joel_posts_id
               FROM stackoverflow.users u
               JOIN stackoverflow.posts p ON u.id = p.user_id 
               WHERE u.display_name = 'Joel Coehoorn')
GROUP BY p.id
HAVING p.id >= 1) tmp2;
            
--5. Выгрузите все поля таблицы vote_types. Добавьте к таблице поле rank, в которое войдут номера записей в обратном порядке.
--Таблица должна быть отсортирована по полю id.

SELECT *,
       ROW_NUMBER() OVER(ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;      
            
--6. Отберите 10 пользователей, которые поставили больше всего голосов типа Close.
-- Отобразите таблицу из двух полей: идентификатором пользователя и количеством голосов.
-- Отсортируйте данные сначала по убыванию количества голосов, потом по убыванию значения идентификатора пользователя.

SELECT v.user_id,
       COUNT(v.id) AS votes_cnt
FROM stackoverflow.votes v
JOIN stackoverflow.vote_types vt ON v.vote_type_id = vt.id
WHERE name = 'Close'
GROUP BY v.user_id
ORDER BY votes_cnt DESC, user_id DESC
LIMIT 10;   
      
--7. Отберите 10 пользователей по количеству значков, полученных в период с 15 ноября по 15 декабря 2008 года включительно.
--Отобразите несколько полей: идентификатор пользователя; число значков; --место в рейтинге — чем больше значков, тем выше рейтинг.
--Пользователям, которые набрали одинаковое количество значков, присвойте одно и то же место в рейтинге.
--Отсортируйте записи по количеству значков по убыванию, а затем по возрастанию значения идентификатора пользователя. 

SELECT *,
       DENSE_RANK () OVER(ORDER BY cnt DESC)
FROM (SELECT user_id,
             COUNT(DISTINCT id) AS cnt
      FROM stackoverflow.badges
      WHERE creation_date::date BETWEEN '2008-11-15' AND '2008-12-15'
      GROUP BY user_id
      ORDER BY cnt DESC, user_id) tmp
LIMIT 10;

--8. Сколько в среднем очков получает пост каждого пользователя? Сформируйте таблицу из следующих полей:
--заголовок поста; идентификатор пользователя; число очков поста; среднее число очков пользователя за пост, округлённое до целого числа.
--Не учитывайте посты без заголовка, а также те, что набрали ноль очков.
      
SELECT title,
       user_id,
       score,
       ROUND(AVG(score) OVER(PARTITION BY user_id), 0)
FROM stackoverflow.posts p
WHERE title != '' AND score != 0;

--9. Отобразите заголовки постов, которые были написаны пользователями, получившими более 1000 значков.
-- Посты без заголовков не должны попасть в список.

SELECT title
FROM stackoverflow.posts
WHERE title != ''
      AND user_id IN (SELECT u.id
                             --COUNT(b.id) AS badges_cnt
                      FROM stackoverflow.users u
                      JOIN stackoverflow.badges b ON u.id = b.user_id
                      GROUP BY u.id
                      HAVING COUNT(b.id) > 1000);
                      
 -- 10. Напишите запрос, который выгрузит данные о пользователях из США (англ. United States). Разделите пользователей на три группы в зависимости от количества просмотров их профилей:
--пользователям с числом просмотров больше либо равным 350 присвойте группу 1;
--пользователям с числом просмотров меньше 350, но больше либо равно 100 — группу 2;
--пользователям с числом просмотров меньше 100 — группу 3.
--Отобразите в итоговой таблице идентификатор пользователя, количество просмотров профиля и группу. Пользователи с нулевым количеством просмотров не должны войти в итоговую таблицу.                     

SELECT id,
       views,
       CASE
           WHEN views >= 350 THEN 1
           WHEN views < 350 AND views >= 100 THEN 2
           WHEN views < 100 THEN 3
       END
FROM stackoverflow.users u 
WHERE views != 0
      AND (location LIKE '%United States%');
      
      
--11. Дополните предыдущий запрос. Отобразите лидеров каждой группы — пользователей, которые набрали максимальное число просмотров в своей группе.
-- Выведите поля с идентификатором пользователя, группой и количеством просмотров.
-- Отсортируйте таблицу по убыванию просмотров, а затем по возрастанию значения идентификатора.
      
WITH
temp_table AS (SELECT id,
                      views,
                      CASE
                          WHEN views >= 350 THEN 1
                          WHEN views < 350 AND views >= 100 THEN 2
                          WHEN views < 100 THEN 3
                      END AS view_group
               FROM stackoverflow.users u 
               WHERE views != 0
                     AND location LIKE '%United States%')
                 
SELECT id, view_group, views
FROM temp_table
WHERE views IN(SELECT MAX(views)
                 FROM temp_table
                 GROUP BY view_group)
ORDER BY views DESC, id;

--12. Посчитайте ежедневный прирост новых пользователей в ноябре 2008 года. Сформируйте таблицу с полями: номер дня;
-- число пользователей, зарегистрированных в этот день; сумму пользователей с накоплением.


WITH
profiles AS (SELECT DATE_TRUNC('day', creation_date)::date AS registration_date,
                    COUNT(id) AS users_per_day
             FROM stackoverflow.users
             WHERE DATE_TRUNC('month', creation_date)::date = '2008-11-01'
             GROUP BY DATE_TRUNC('day', creation_date)::date
             ORDER BY DATE_TRUNC('day', creation_date)::date
             )
             
SELECT ROW_NUMBER () OVER(),
       users_per_day,
       SUM(users_per_day) OVER(ORDER BY registration_date)
FROM profiles
ORDER BY registration_date;

--13. Для каждого пользователя, который написал хотя бы один пост, найдите интервал между регистрацией и временем создания первого поста.
--Отобразите: идентификатор пользователя; разницу во времени между регистрацией и первым постом.

SELECT u.id AS user_id,
       MIN(p.creation_date - u.creation_date) AS delta
FROM stackoverflow.users u
JOIN stackoverflow.posts p ON u.id = p.user_id
WHERE u.id IN (SELECT u.id
               FROM stackoverflow.users u
               JOIN stackoverflow.posts p ON u.id = p.user_id
               GROUP BY u.id
               HAVING COUNT(p.id) >= 1)
GROUP BY u.id;

-- 14. Выведите общую сумму просмотров постов за каждый месяц 2008 года. Если данных за какой-либо месяц в базе нет, такой месяц можно
-- пропустить. Результат отсортируйте по убыванию общего количества просмотров.

SELECT DATE_TRUNC('month', creation_date)::date,
       SUM(views_count) AS month_views_count
FROM stackoverflow.posts p
WHERE EXTRACT(YEAR FROM p.creation_date) = 2008
GROUP BY DATE_TRUNC('month', creation_date)::date
ORDER BY month_views_count DESC;

-- 15. Выведите имена самых активных пользователей, которые в первый месяц после регистрации (включая день регистрации) дали
-- больше 100 ответов. Вопросы, которые задавали пользователи, не учитывайте. Для каждого имени пользователя выведите количество уникальных значений user_id.
-- Отсортируйте результат по полю с именами в лексикографическом порядке.

SELECT display_name,
       COUNT(DISTINCT user_id) AS cnt
FROM stackoverflow.users AS u
JOIN stackoverflow.posts AS p ON u.id = p.user_id
LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
WHERE type = 'Answer'
  AND p.creation_date::date BETWEEN u.creation_date::date AND (u.creation_date::date + INTERVAL '1 month')
GROUP BY display_name
HAVING COUNT(user_id) > 100
ORDER BY display_name;

-- 16. Выведите количество постов за 2008 год по месяцам. Отберите посты от пользователей, которые зарегистрировались в
-- сентябре 2008 года и сделали хотя бы один пост в декабре того же года. Отсортируйте таблицу по значению месяца по убыванию.

SELECT DATE_TRUNC('month', p.creation_date)::date,
       COUNT(p.id) AS posts_cnt
FROM stackoverflow.users u 
JOIN stackoverflow.posts p ON u.id = p.user_id
WHERE EXTRACT(YEAR FROM p.creation_date) = 2008
      AND u.id IN (SELECT u.id
                   FROM stackoverflow.users u 
                   JOIN stackoverflow.posts p ON u.id = p.user_id 
                   WHERE DATE_TRUNC('month', u.creation_date)::date = '2008-09-01'
                         AND DATE_TRUNC('month', p.creation_date)::date = '2008-12-01'
                   )
GROUP BY DATE_TRUNC('month', p.creation_date)::date
ORDER BY DATE_TRUNC('month', p.creation_date)::date DESC

-- 17. Используя данные о постах, выведите несколько полей: идентификатор пользователя, который написал пост; дата создания поста;
-- количество просмотров у текущего поста; сумму просмотров постов автора с накоплением.
-- Данные в таблице должны быть отсортированы по возрастанию идентификаторов пользователей, а данные об одном и том же пользователе — по возрастанию даты создания поста.

SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER(PARTITION BY user_id ORDER BY creation_date)
FROM stackoverflow.posts
ORDER BY user_id, creation_date

--18. Сколько в среднем дней в период с 1 по 7 декабря 2008 года включительно пользователи взаимодействовали с платформой?
-- Для каждого пользователя отберите дни, в которые он или она опубликовали хотя бы один пост. Нужно получить одно целое число — не забудьте округлить результат.

WITH
active_days AS (SELECT user_id,
                       COUNT(DATE_TRUNC('day', creation_date)::date) AS days_cnt
                FROM stackoverflow.posts 
                WHERE creation_date::date BETWEEN '2008-12-01' AND '2008-12-07'
                GROUP BY user_id
                ORDER BY user_id, days_cnt)
        
SELECT ROUND(AVG(days_cnt), 0)-1
FROM active_days

--19. Выгрузите данные активности пользователя, который опубликовал больше всего постов за всё время.
-- Выведите данные за октябрь 2008 года в таком виде:номер недели; дата и время последнего поста, опубликованного на этой неделе.

WITH
most_active_user AS (SELECT user_id,
                            COUNT(id)
                     FROM stackoverflow.posts
                     GROUP BY user_id
                     ORDER BY 2 DESC
                     LIMIT 1)

SELECT DISTINCT EXTRACT(WEEK FROM creation_date),
       LAST_VALUE(creation_date) OVER(PARTITION BY EXTRACT(WEEK FROM creation_date)
                                      ORDER BY creation_date
                                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM stackoverflow.posts
WHERE user_id IN (SELECT user_id
                  FROM stackoverflow.posts
                  GROUP BY user_id
                  ORDER BY COUNT(id) DESC
                  LIMIT 1)
      AND DATE_TRUNC('month', creation_date) = '2008-10-01'




















