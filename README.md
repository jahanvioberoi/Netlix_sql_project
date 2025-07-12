# Netlix Movies and TV shows Data analysis using SQL
![Netflix_logo](https://github.com/jahanvioberoi/Netlix_sql_project/blob/main/Netflix%20logo.png)

##  📝 OVERVIEW
This project involves a structured analysis of Netflix's Movies and TV Shows data using SQL. The primary goal is to extract meaningful insights and solve business-centric queries using raw content metadata. The SQL script answers 15 different analytical questions related to content types, genre trends, countries of origin, key contributors, and viewer-targeted characteristics. The project demonstrates strong command over string functions, date filtering, and aggregation logic.

## 🎯OBJECTIVES

Analyze the distribution of content types: Movies vs. TV Shows

Identify the most frequent ratings across both content types

List and explore content by release year, country, and duration

Determine trends in director and actor participation

Categorize content using keywords in descriptions (e.g., violence, kill)

Highlight high-content producing countries and popular genres

Extract content insights based on addition timelines and duration logic

Apply filtering techniques to isolate niche content like documentaries

## 📂 DATASET
The data for this project is sourced from the Netflix Movies and TV Shows dataset available on Kaggle.

🔗 Dataset Link: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

The dataset includes details like title, cast, country, rating, and date when the content was added to the platform.

## SCHEMA

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


##  Business Problems & Solutions

## 1. Count the number of Movies vs TV Shows
  select 
  type,
  count(*) as total_content
  From netflix
  Group by type;
  
## 2. Find the most common rating for movies and TV shows
 select type,rating
 from(
select type,rating,count(*),
rank()over(partition by type order by
count(*) desc)as ranking
from netflix
group by type,rating
)as t1
where ranking=1;
 
## 3. List all movies released in a specific year (e.g., 2020)
    select * from netflix
	where 
	type='Movie'
	AND
	release_year= 2020
	
## 4. Find the top 5 countries with the most content on Netflix
      select
	  unnest(string_to_array(country,',')) as new_country,
	  count(show_id) as total_content
	  from netflix
	  group by 1
	  order by 2 desc
	  limit 5
       
## 5. --Identify the longest movie
      SELECT * FROM NETFLIX
	  WHERE
	  type='Movie'
	  AND
	  duration = (SELECT MAX(duration)from netflix)

## 6.--Find content added in the last 5 years
   SELECT * FROM netflix
   WHERE
   date_added>= CURRENT_DATE - INTERVAL '5 years'

## 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
     SELECT * FROM netflix
	 WHERE director like'%Rajiv Chilaka%';
    
## 8. List all TV shows with more than 5 seasons
   SELECT *,
   SPLIT_PART(duration,' ',1) as seasons
   FROM netflix
   WHERE
   type='TV Show'
   AND
   SPLIT_PART(duration,' ',1)::numeric > 5 
    

## 9. Count the number of content items in each genre
     SELECT
	 UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	 COUNT(show_id) as total_content
	 FROM netflix
	 GROUP BY 1;
    
## 10.Find each year and the average numbers of content release in India on netflix. 
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
	
	
	 
## 11. List all movies that are documentaries
    SELECT * FROM netflix
	WHERE
	listed_in ILIKE '%documentaries%'

	
## 12. Find all content without a director
      SELECT * FROM netflix
	  WHERE
	  director IS NULL;
     
## 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
       SELECT * FROM netflix
	   WHERE
	   casts ILIKE '%salman khan%'
	   AND
	   release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;
    
## 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
      SELECT 
	  UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
	  COUNT(*) as total_content
	  FROM netflix
	  WHERE country ILIKE '%india'
	  GROUP BY 1
	  ORDER BY 2 DESC
	  LIMIT 10;
   
## 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' 

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

## 📌 Findings & Conclusion
## Content Distribution
Movies dominate the platform, but there is a significant and growing number of TV Shows.
The overall distribution suggests Netflix prioritizes variety in format and content type.

## Common Ratings
TV-MA (Mature Audience) and TV-14 are among the most frequent ratings.
Indicates Netflix focuses largely on mature and young adult audiences rather than kids.

 ## Release Year Trends
A large proportion of content was released after 2010, with peaks around 2018–2020.
This reflects Netflix’s shift toward original programming and recent acquisitions.

## Geographical Insights
The United States, India, and the United Kingdom are the top countries contributing to Netflix’s library.
India consistently contributes a sizable portion of content annually.
Regional diversity has increased in recent years with entries from Korea, Canada, and Australia.

## Longest Duration
Identifying the longest movie revealed how outliers can be used for marketing or niche content targeting.

## Content Categorization (Good vs. Bad)
Keyword-based classification using terms like “kill” or “violence” helps in content tagging and moderation.
Majority of content is “Good” by this metric, but this logic can be extended for sentiment or genre-specific filters.

## Genre Preferences

Documentaries, Dramas, and Comedies dominate across both content types.
These genres show higher versatility across both Movies and TV Shows.

## Actor/Director Patterns
Some actors (e.g., Salman Khan) appear repeatedly in Indian content over the last 10 years.
Directors like Rajiv Chilaka have a strong presence in kids/animated shows, revealing niche specialization.

## TV Show Duration Insights
Multiple TV shows have more than 5 seasons, indicating long-term viewer engagement.
This can signal shows with cult followings or high renewal rates.

## Recent Additions (Last 5 Years)
A surge in content additions between 2018–2021 reflects Netflix's expansion strategy.
Post-pandemic, the platform continued to invest in both local and global content acquisitions.

## ✅ Conclusion
This SQL-based analysis of Netflix’s content library gives a structured, data-driven look into:

## 1) Viewer preferences (genre, rating)
## 2) Content strategy (regional focus, duration trends)
## 3) Data-driven categorization (keywords and sentiment cues)
## 4) Potential indicators for content planning, localization, and audience targeting

This project can help media strategists, data teams, and content creators understand market trends and design viewer-centric offerings more effectively.

 ##  🙌 Connect With Me

- ![LinkedIn: Jahanvi Oberoi](https://www.linkedin.com/in/jahanvioberoi/)
- ![GitHub: @jahanvioberoi](https://github.com/jahanvioberoi)




