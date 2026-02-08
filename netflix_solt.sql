 --Netflix Project
drop table if exists Netflix;
CREATE TABLE Netflix
	(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title   VARCHAR(150),
	director VARCHAR(208),	
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT	,
	rating	VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(105),
	description VARCHAR(250)
	);
	
	select * from Netflix;

	SELECT
	COUNT(*) AS total_content
	FROM Netflix;

	SELECT
	distinct type
	FROM Netflix;



	--15 Buisness Problems

1. find content added in the last 5 years.

		SELECT 
		*
		FROM netflix
		WHERE
		     to_date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

			 
2. Find the Directors with highest Netflix Presence.			 
			  
		SELECT
		    director,
		    COUNT(*) AS total_titles
		FROM netflix
		WHERE director IS NOT NULL
		GROUP BY director
		ORDER BY total_titles DESC
		LIMIT 10;


3. Find Genre wise content wise distribution.

		SELECT
		    listed_in AS genre,
		    COUNT(*) AS total_content
		FROM netflix
		GROUP BY listed_in
		ORDER BY total_content DESC;
		

4. Find TV SHOWS with more than 5 seasons.

		SELECT
		title,  
		duration
		FROM netflix
		WHERE type = 'TV Show'
		AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;



5.  Count the number of content items in each Genre.

		SELECT
		UNNEST(STRING_TO_ARRAY(listed_in,','))as Genre,
		COUNT(show_id)
		FROM Netflix
		group by 1;

6.  Find each year and the average numbers of content release by India on Netflix 
    return top 5 year with highest average content release !

		SELECT
		EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD, YYYY'))as year,
		COUNT(*),
		COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM Netflix where country ='India')* 100 as avg_content_per_year
		FROM Netflix
		WHERE country='India'
		GROUP BY 1;

7.  List all the movies  that are listed as Documentries.

		SELECT *
		FROM NETFLIX
		WHERE
		listed_in
		ILIKE '%documentaries';

8.  Find how many movie actor 'salman khan'	appeared in the last 10 years.


		SELECT
		COUNT(*) AS total_movies
		FROM netflix
		WHERE casts ILIKE '%Salman Khan%'
		AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

		
9.  Find the top 10 Actors who have appeared in the highest number of movies produced in India.	

		SELECT
		--SHOW ID,
		--CASTS,
		UNNEST(STRING_TO_ARRAY(casts,','))as actors,
		COUNT (*) as total_content
		FROM netflix
		WHERE country ILIKE '%India'
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10;

10.  Categorize the content based on the presence of keywords 'kill' and 'violence' in the description
     field. Label Content containing these keywords as 'Bad' and all other as 'Good' count how many items
	 fall into each category.


		WITH new_table
		as
		(
		SELECT
		*,
		CASE 
		WHEN
		    description ILIKE '%kill%' OR
			description ILIKE '%violence%' THEN 'bad_content'
			ELSE 'Good Content'
			END Category
			FROM Netflix
			)
		SELECT 
		CATEGORY,
		COUNT(*)AS total_content
		FROM new_table
		GROUP BY 1;

11.  How has Netflix’s content volume grown over time, and which year had the highest additions?

		WITH yearly_content
		AS 
		(
		SELECT
		release_year,
		COUNT(*) AS total_content
		FROM netflix
		GROUP BY release_year
		)
		SELECT
	    release_year,
		total_content,
		RANK() 
		OVER 
		(ORDER BY total_content DESC) AS content_rank
		FROM yearly_content
		ORDER BY release_year;

12.  Which countries dominate Netflix’s catalog, and what is their percentage contribution.


		SELECT
		country,
		COUNT(*) AS total_content,
		ROUND(
		COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
		2) AS percentage_share,
		RANK()
		OVER
		(ORDER BY COUNT(*) DESC) AS country_rank
		FROM netflix
		WHERE country IS NOT NULL
		GROUP BY country
		ORDER BY country_rank;


	




