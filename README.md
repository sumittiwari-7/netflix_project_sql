# Netflix Content Analytics & Business Insights using SQL

![Netflix logo](https://github.com/sumittiwari-7/netflix_project_sql/blob/main/netflix%20logo.jpg)

## Business Context
Netflix's content strategy team needs to understand which regions, genres, and content types are driving the most catalog growth — enabling smarter acquisition, production, and investment decisions. This analysis answers key business questions using structured SQL queries on Netflix's global content dataset.

## Overview
This project analyzes the Netflix dataset using PostgreSQL to uncover insights into content distribution, growth trends, and regional contributions. It explores genres, directors, actors, and content characteristics through structured SQL queries. The analysis applies intermediate and advanced SQL techniques such as CTEs, window functions, and text parsing.

## Objective
- Analyze Netflix's content growth and distribution over time.
- Identify dominant countries, genres, directors, and actors in Netflix's catalog.
- Apply intermediate and advanced SQL concepts such as CTEs, window functions, and conditional logic.
- Explore and categorize content based on specific criteria and keywords.
- Deliver actionable business recommendations based on data findings.

## Dataset
The data for this project is sourced from the Kaggle dataset:
**Dataset Link:** [Netflix Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
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

## Business Problems and Solutions

### 1. Find content added in the last 5 years.
```sql
SELECT 
    *
FROM netflix
WHERE to_date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Analyze Netflix's recent catalog growth by identifying content added within the last five years.

---

### 2. Find the Directors with highest Netflix Presence.
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

---

### 3. Find Genre-wise content distribution.
```sql
SELECT
    listed_in AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;
```
**Objective:** Understand the distribution of Netflix content across different genres.

---

### 4. Find TV Shows with more than 5 seasons.
```sql
SELECT
    title,
    duration
FROM netflix
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;
```
**Objective:** Find long-running TV shows on Netflix with more than five seasons to assess viewer retention trends.

---

### 5. Count the number of content items in each Genre.
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in,',')) AS Genre,
    COUNT(show_id)
FROM Netflix
GROUP BY 1;
```
**Objective:** Measure the volume of content available in each genre by breaking down multi-genre listings.

---

### 6. Find the top 5 years with the highest average content release by India on Netflix.
```sql
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS year,
    COUNT(*),
    COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM Netflix WHERE country = 'India') * 100 AS avg_content_per_year
FROM Netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY avg_content_per_year DESC
LIMIT 5;
```
**Objective:** Analyze trends in Indian content production on Netflix by identifying years with the highest average releases.

---

### 7. List all movies listed as Documentaries.
```sql
SELECT *
FROM NETFLIX
WHERE listed_in ILIKE '%documentaries';
```
**Objective:** Retrieve all Netflix titles classified under the Documentary genre.

---

### 8. Find how many movies actor Salman Khan appeared in during the last 10 years.
```sql
SELECT
    COUNT(*) AS total_movies
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective:** Determine the number of movies featuring Salman Khan released on Netflix in the past decade.

---

### 9. Find the top 10 actors who appeared in the highest number of movies produced in India.
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
**Objective:** Identify the most frequently appearing actors in Netflix content produced in India.

---

### 10. Categorize content based on keywords 'kill' and 'violence' in the description.
```sql
WITH new_table AS (
    SELECT
        *,
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad Content'
            ELSE 'Good Content'
        END AS Category
    FROM Netflix
)
SELECT
    Category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY 1;
```
**Objective:** Categorize Netflix content into "Good" or "Bad" based on the presence of violence-related keywords in descriptions.

---

### 11. How has Netflix's content volume grown over time, and which year had the highest additions?
```sql
WITH yearly_content AS (
    SELECT
        release_year,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY release_year
)
SELECT
    release_year,
    total_content,
    RANK() OVER (ORDER BY total_content DESC) AS content_rank
FROM yearly_content
ORDER BY release_year;
```
**Objective:** Analyze year-wise growth in Netflix content and identify the year with the highest number of additions.

---

### 12. Which countries dominate Netflix's catalog and what is their percentage contribution?
```sql
SELECT
    country,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_share,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY country_rank;
```
**Objective:** Evaluate country-level contributions to Netflix's catalog by calculating content volume and percentage share.

---

## Key Findings & Business Recommendations

### Findings
- **US Dominance:** The United States contributes the largest share of Netflix's catalog, followed by India and the United Kingdom.
- **India's Fast Growth:** Indian content shows consistent year-over-year growth, reflecting Netflix's increasing regional investment in South Asia.
- **Genre Concentration:** Drama, Comedy, and Documentaries dominate the platform — together accounting for the majority of all content.
- **Recent Expansion:** A large portion of content has been added in the last 5 years, indicating aggressive catalog expansion.
- **Long-running Shows:** A significant number of TV shows have run beyond 5 seasons, pointing to strong viewer retention in certain genres.

### Recommendations
1. **Double down on Indian content** — YoY growth trend makes it the highest-potential regional market for new production investment.
2. **Diversify beyond Drama/Comedy** — Over-indexing on two genres creates churn risk; investing in Thriller and True Crime could attract new audience segments.
3. **Prioritize long-running show renewals** — Shows with 5+ seasons demonstrate strong retention; these should be prioritized for renewal decisions.
4. **Audit low-rated content** — Content flagged under violence keywords should be reviewed for proper age-gating to reduce regulatory risk.
5. **Expand documentary catalog** — Documentaries punch above their weight in engagement; targeted investment here offers high ROI.

---

## Query Optimization & Readability
- Used CTEs to break complex logic into readable, maintainable steps.
- Filtered data early in queries to reduce unnecessary computation.
- Avoided repeated calculations by reusing intermediate results.
- Prioritized clarity and maintainability over condensed one-line queries.

---

## Technology Stack
- **Database:** PostgreSQL
- **SQL Techniques:** DDL, DML, Aggregations, Subqueries, CTEs, Window Functions, Text Parsing
- **Tools:** pgAdmin 4, PostgreSQL

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Run `Schemas.sql` to create the database schema.
3. Import `netflix_titles.csv` into the netflix table.
4. Execute queries from `Business_Problems.sql` and `Business_Solutions.sql`.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data:** Build a Power BI or Tableau dashboard on top of these SQL findings.
- **Expand Dataset:** Add more recent data for broader analysis and trend validation.
- **Advanced Querying:** Explore query performance optimization on larger datasets.
