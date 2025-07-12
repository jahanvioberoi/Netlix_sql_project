DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
show_id	VARCHAR(6),
type  VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added DATE,
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);
select * from netflix;


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
  select 
  type,
  count(*) as total_content
  From netflix
  Group by type;
--2. Find the most common rating for movies and TV shows
 select type,rating
 from(
select type,rating,count(*),
rank()over(partition by type order by
count(*) desc)as ranking
from netflix
group by type,rating
)as t1
where ranking=1;
 
--3. List all movies released in a specific year (e.g., 2020)
    select * from netflix
	where 
	type='Movie'
	AND
	release_year= 2020
	
--4. Find the top 5 countries with the most content on Netflix
      select
	  unnest(string_to_array(country,',')) as new_country,
	  count(show_id) as total_content
	  from netflix
	  group by 1
	  order by 2 desc
	  limit 5
       
5. --Identify the longest movie
      SELECT * FROM NETFLIX
	  WHERE
	  type='Movie'
	  AND
	  duration = (SELECT MAX(duration)from netflix)

6.--Find content added in the last 5 years
   SELECT * FROM netflix
   WHERE
   date_added>= CURRENT_DATE - INTERVAL '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
     SELECT * FROM netflix
	 WHERE director like'%Rajiv Chilaka%';
    
--8. List all TV shows with more than 5 seasons
   SELECT *,
   SPLIT_PART(duration,' ',1) as seasons
   FROM netflix
   WHERE
   type='TV Show'
   AND
   SPLIT_PART(duration,' ',1)::numeric > 5 
    

--9. Count the number of content items in each genre
     SELECT
	 UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	 COUNT(show_id) as total_content
	 FROM netflix
	 GROUP BY 1;
    
--10.Find each year and the average numbers of content release in India on netflix. 
    return top 5 year with highest avg content release!

total content 333/972
	
     SELECT 
	EXTRACT (YEAR FROM date_added) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*) :: numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric*100
	,2)as avg_content_per_year
	FROM netflix
	WHERE country = 'India'
	GROUP BY year
	ORDER BY avg_content_per_year DESC
	LIMIT 5;
	
	
	 
--11. List all movies that are documentaries
    SELECT * FROM netflix
	WHERE
	listed_in ILIKE '%documentaries%'

	
--12. Find all content without a director
      SELECT * FROM netflix
	  WHERE
	  director IS NULL;
     
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
       SELECT * FROM netflix
	   WHERE
	   casts ILIKE '%salman khan%'
	   AND
	   release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
      SELECT 
	  UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
	  COUNT(*) as total_content
	  FROM netflix
	  WHERE country ILIKE '%india'
	  GROUP BY 1
	  ORDER BY 2 DESC
	  LIMIT 10;
--15.
 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
( SELECT 
*,
CASE 
WHEN
description ILIKE '%kills%' OR
description ILIKE '%violence%' THEN 'Bad_content'
ELSE 'Good content'
End category
FROM netflix
)
SELECT 
category,
COUNT(*) as total_content
FROM new_table
GROUP BY 1;



