SELECT COUNT(p.id)--, id, title, score, favorites_count
FROM stackoverflow.posts p
JOIN stackoverflow.post_types t ON p.post_type_id = t.id
WHERE t.type = 'Question'
      AND (score > 300 OR favorites_count >= 100)

SELECT COUNT(p.id)--, id, title, score, favorites_count
FROM stackoverflow.posts p
JOIN stackoverflow.post_types t ON p.post_type_id = t.id
WHERE t.type = 'Question'
      AND (score > 300 OR favorites_count >= 100)

SELECT COUNT(p.id)--, id, title, score, favorites_count
FROM stackoverflow.posts p
JOIN stackoverflow.post_types t ON p.post_type_id = t.id
WHERE t.type = 'Question'
      AND (score > 300 OR favorites_count >= 100)

