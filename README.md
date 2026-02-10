# Netflix Content Analytics & Business Insights using SQL

![Netflix logo](https://github.com/sumittiwari-7/netflix_project_sql/blob/main/netflix%20logo.jpg)

## Overview
This project analyzes the Netflix dataset using PostgreSQL to uncover insights into content distribution, growth trends, and regional contributions. It explores genres, directors, actors, and content characteristics through structured SQL queries. The analysis applies intermediate and advanced SQL techniques such as CTEs, window functions, and text parsing. The project demonstrates practical data analysis skills aligned with entry-level Data Analyst roles.

## Objective

- Analyze Netflix’s content growth and distribution over time.
- Identify dominant countries, genres, directors, and actors in Netflix’s catalog.
- Apply intermediate and advanced SQL concepts such as CTEs, window functions, and conditional logic.
- Explore and categorize content based on specific criteria and keywords.
- Demonstrate real-world data analysis skills using PostgreSQL.

- ## Dataset

- The data for this project is sourced from the Kaggle dataset:

-  **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

-  ## Schema
-  ```sql
   DROP TABLE IF EXISTS netflix;
   CREATE TABLE netflix
   (
       show_id      VARCHAR(5),
       type         VARCHAR(10),
       title        VARCHAR(250),
       director     VARCHAR(550),
       casts        VARCHAR(1050),
       country      VARCHAR(550),
       date_added   VARCHAR(55),
       release_year INT,
       rating       VARCHAR(15),
       duration     VARCHAR(15),
       listed_in    VARCHAR(250),
       description  VARCHAR(550)
   );
   ```
-  ## Buisness Problems and Solutions 
-  ### 1. find content added in the last 5 years.

```sql
SELECT 
		*
		FROM netflix
		WHERE
		     to_date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Analyze Netflix’s recent catalog growth by identifying content added within the last five years.

### 2.  Find the Directors with highest Netflix Presence.

```sql
SELECT
		    director,
		    COUNT(*) AS total_titles
		FROM netflix
		WHERE director IS NOT NULL
		GROUP BY director
		ORDER BY total_titles DESC
		LIMIT 10;
```

**Objective:** Identify the most prolific directors on Netflix based on the total number of titles they have contributed.

### 3. Find Genre wise content wise distribution.

```sql
SELECT
		    listed_in AS genre,
		    COUNT(*) AS total_content
		FROM netflix
		GROUP BY listed_in
		ORDER BY total_content DESC;
```

**Objective:** Understand the distribution of Netflix content across different genres.

### 4. Find TV SHOWS with more than 5 seasons.
```sql
SELECT
		title,  
		duration
		FROM netflix
		WHERE type = 'TV Show'
		AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;
```

**Objective:** Find long-running TV shows on Netflix with more than five seasons to assess viewer retention trends.

### 5. Count the number of content items in each Genre.

```sql
SELECT
		UNNEST(STRING_TO_ARRAY(listed_in,','))as Genre,
		COUNT(show_id)
		FROM Netflix
		group by 1;
```

**Objective:** Measure the volume of content available in each genre by breaking down multi-genre listings.

### 6. Find each year and the average numbers of content release by India on Netflix return top 5 year with highest average content release!


```sql
SELECT
		EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD, YYYY'))as year,
		COUNT(*),
		COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM Netflix where country ='India')* 100 as avg_content_per_year
		FROM Netflix
		WHERE country='India'
		GROUP BY 1;
```

**Objective:** Analyze trends in Indian content production on Netflix by identifying years with the highest average releases.

### 7. List all the movies  that are listed as Documentries.

```sql
SELECT *
		FROM NETFLIX
		WHERE
		listed_in
		ILIKE '%documentaries';
```

**Objective:** Retrieve all Netflix titles classified under the Documentary genre.

### 8. Find how many movie actor 'salman khan'	appeared in the last 10 years.

```sql
SELECT
		COUNT(*) AS total_movies
		FROM netflix
		WHERE casts ILIKE '%Salman Khan%'
		AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Determine the number of movies featuring Salman Khan released on Netflix in the past decade.

### 9.  Find the top 10 Actors who have appeared in the highest number of movies produced in India.	

```sql
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
```

**Objective:** Identify the most frequently appearing actors in Netflix content produced in India.

### 10.Categorize the content based on the presence of keywords 'kill' and 'violence' in the description
 field. Label Content containing these keywords as 'Bad' and all other as 'Good' count how many items
 fall into each category.

```sql
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
```

**Objective:** Categorize Netflix content into “Good” or “Bad” based on the presence of violence-related keywords in descriptions.

### 11. How has Netflix’s content volume grown over time, and which year had the highest additions?

```sql
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
```

**Objective:** Analyze year-wise growth in Netflix content and identify the year with the highest number of additions.

### 12.  Which countries dominate Netflix’s catalog and what is their percentage contribution.

```sql
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
```
**Objective:**Evaluate country-level contributions to Netflix’s catalog by calculating content volume and percentage share.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Recent Growth:** A large portion of content has been added in recent years, showing rapid platform expansion.
- **Regional Focus:** Indian content shows strong year-wise growth, reflecting Netflix’s increasing regional investment.
- **Genre Preference:** Drama, Comedy, and Documentaries dominate the platform’s content library.
  
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


---

## Query Optimization & Readability Theory

- Used CTEs to break complex logic into readable steps.
- Filtered data early to reduce unnecessary computation.
- Avoided repeated calculations by reusing intermediate results.
- Prioritized clarity and maintainability over one-line queries.

---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Subqueries, Data handling & Filtering
- **Tools**: pgAdmin 4 , PostgreSQL

- ## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---





  
   

   

 
