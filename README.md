# OTT India Market Expansion Study — SQL Analytics on Netflix Content Data

![Netflix logo](https://github.com/sumittiwari-7/netflix_project_sql/blob/main/netflix%20logo.jpg)

---

## Business Context

India is one of the fastest-growing OTT markets in the world, with Netflix competing against JioCinema, Amazon Prime Video, and Disney+ Hotstar for regional dominance. Despite massive global expansion, Netflix's India-specific content strategy remains a key business challenge.

> **Core Business Question: Is Netflix's current content investment aligned with Indian market demand — and where are the gaps?**

This study uses PostgreSQL to analyze Netflix's global content catalog and extract strategic insights about India's position, genre preferences, content growth trends, and regional benchmarking — directly relevant to content acquisition and production decisions.

---

## Objective

- Measure India's share and growth trajectory within Netflix's global catalog.
- Identify which genres and content types are underrepresented for Indian audiences.
- Benchmark India's content growth against top competing markets (US, UK).
- Analyze content rating patterns to understand audience targeting strategy.
- Deliver data-backed recommendations for Netflix's India content investment.

---

## Dataset

- **Source:** Kaggle — Netflix Shows Dataset
- **Link:** [Netflix Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
- **Size:** 8,800+ titles across movies and TV shows
- **Coverage:** 2008–2021, 90+ countries

---

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

---

## Analysis & SQL Queries

### 1. How much of Netflix's catalog comes from India vs other top countries?
*(Uses: GROUP BY, ORDER BY)*

```sql
SELECT
    country,
    COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 10;
```

**Business Insight:** Shows India's catalog share vs the US and UK — revealing how large the investment gap is for the Indian market.

---

### 2. How has India's content grown on Netflix year by year?
*(Uses: GROUP BY, ORDER BY, Date Filter)*

```sql
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_titles_added
FROM netflix
WHERE country = 'India'
AND date_added IS NOT NULL
GROUP BY 1
ORDER BY year;
```

**Business Insight:** Tracks whether Netflix is speeding up or slowing down its India content investment year over year.

---

### 3. Is India's catalog more Movies or TV Shows — and is that the right strategy?
*(Uses: GROUP BY, CASE WHEN)*

```sql
SELECT
    type,
    COUNT(*) AS total,
    CASE
        WHEN COUNT(*) > 500 THEN 'High Volume'
        WHEN COUNT(*) BETWEEN 200 AND 500 THEN 'Medium Volume'
        ELSE 'Low Volume'
    END AS volume_category
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY type;
```

**Business Insight:** India's audiences are shifting toward binge-worthy series. If Netflix India is over-indexed on movies, that is a direct retention risk.

---

### 4. Which genres are most common in India's Netflix catalog?
*(Uses: GROUP BY, WHERE, ORDER BY)*

```sql
SELECT
    listed_in AS genre,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY listed_in
ORDER BY total_content DESC
LIMIT 10;
```

**Business Insight:** Identifies which genres Netflix is betting on for Indian audiences — and which high-demand genres like Thriller or Crime are missing.

---

### 5. How does India compare to the US and UK in content volume?
*(Uses: WHERE IN, GROUP BY, ORDER BY)*

```sql
SELECT
    country,
    type,
    COUNT(*) AS total_titles
FROM netflix
WHERE country IN ('India', 'United States', 'United Kingdom')
GROUP BY country, type
ORDER BY country, total_titles DESC;
```

**Business Insight:** Directly benchmarks India's content mix against Netflix's two biggest markets — showing exactly where India's strategy diverges.

---

### 6. What audience age groups is Netflix targeting in India?
*(Uses: GROUP BY, ORDER BY, WHERE)*

```sql
SELECT
    rating,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
AND rating IS NOT NULL
GROUP BY rating
ORDER BY total_content DESC;
```

**Business Insight:** Reveals whether Netflix India skews adult, teen, or family — and whether this matches India's young demographic profile.

---

### 7. Categorize India's Netflix content by how old it is
*(Uses: CASE WHEN, GROUP BY)*

```sql
SELECT
    CASE
        WHEN release_year >= 2020 THEN 'Very Recent (2020+)'
        WHEN release_year BETWEEN 2015 AND 2019 THEN 'Recent (2015-2019)'
        WHEN release_year BETWEEN 2010 AND 2014 THEN 'Older (2010-2014)'
        ELSE 'Classic (Before 2010)'
    END AS content_age_group,
    COUNT(*) AS total_titles
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY total_titles DESC;
```

**Business Insight:** Shows whether Netflix India's catalog is fresh or outdated — fresh content is key to reducing subscriber churn.

---

### 8. Which Indian directors appear most on Netflix?
*(Uses: WHERE, GROUP BY, ORDER BY)*

```sql
SELECT
    director,
    COUNT(*) AS total_titles
FROM netflix
WHERE country ILIKE '%India%'
AND director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
```

**Business Insight:** Identifies Netflix's key Indian creative partnerships — important for talent retention and exclusive content deal strategy.

---

### 9. Flag Indian content that may face regulatory risk in India
*(Uses: CASE WHEN, WHERE, GROUP BY)*

```sql
SELECT
    title,
    listed_in,
    rating,
    CASE
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Needs Review'
        ELSE 'Clear'
    END AS compliance_flag
FROM netflix
WHERE country ILIKE '%India%'
ORDER BY compliance_flag DESC
LIMIT 20;
```

**Business Insight:** India has strict content regulations (IT Rules 2021). Flagging sensitive content helps Netflix proactively manage regulatory compliance risk.

---

### 10. What are the most recent Indian titles added to Netflix?
*(Uses: WHERE, ORDER BY, Date Function)*

```sql
SELECT
    title,
    type,
    date_added,
    listed_in AS genre,
    rating
FROM netflix
WHERE country ILIKE '%India%'
AND date_added IS NOT NULL
ORDER BY TO_DATE(date_added, 'Month DD, YYYY') DESC
LIMIT 10;
```

**Business Insight:** The most recently added Indian titles reveal Netflix's current India content priorities — genres, formats, and audience targets they are actively investing in right now.

---

## Key Findings

| # | Finding | Business Implication |
|---|---------|---------------------|
| 1 | US dominates Netflix catalog; India is top 3 but significantly behind | Large investment gap exists for India |
| 2 | India content additions grew sharply after 2018 | Netflix is accelerating India strategy but started late |
| 3 | India catalog is heavily movie-skewed | Misaligned with India's growing appetite for series |
| 4 | Drama and Comedy dominate India's genres | Thriller, Crime, Reality genres are underserved |
| 5 | Adult-rated content dominates India's catalog | Family and children's content is a major gap |

---

## Business Recommendations

1. **Increase series investment for India** — India's catalog is over-indexed on movies while audiences are shifting to binge-worthy series. Closing this gap could directly improve monthly retention.

2. **Invest in underrepresented genres** — Thriller, True Crime, and Reality content are significantly underserved in India's catalog. These genres drive high engagement on competing platforms like JioCinema.

3. **Build a family content pipeline for India** — The gap in family and children's content is a missed opportunity given India's young demographic profile.

4. **Lock in exclusive Indian creator deals** — Top Indian directors appear repeatedly in the catalog. Exclusive partnerships with key creators would defend against content poaching by Amazon and Disney.

5. **Invest in regional language originals** — Tamil, Telugu, and Malayalam content has shown strong global crossover appeal. A regional language content fund could drive both India retention and international growth.

---

## SQL Concepts Used

| Concept | Used In |
|---|---------|
| WHERE + LIKE / ILIKE | Queries 1, 4, 6, 7, 8, 9, 10 |
| GROUP BY + ORDER BY | All queries |
| CASE WHEN | Queries 3, 7, 9 |
| Subquery / IN filter | Query 5 |
| Date Functions (EXTRACT, TO_DATE) | Queries 2, 10 |
| String Filter (ILIKE) | Queries 3, 4, 6, 8, 9 |

---

## Technology Stack

- **Database:** PostgreSQL
- **SQL Techniques:** Aggregations, Filtering, Grouping, Sorting, CASE WHEN, Date Functions
- **Tools:** pgAdmin 4, PostgreSQL

---

## How to Run

1. Install PostgreSQL and pgAdmin.
2. Run `Schemas.sql` to create the database schema.
3. Import `netflix_titles.csv` into the netflix table.
4. Execute queries from `Business_Problems.sql` and `Business_Solutions.sql`.

---

## Next Steps

- Build a Power BI dashboard to visualize India vs global benchmarks visually.
- Expand with external data (IMDb ratings, subscriber counts) for deeper validation.
- Apply the same framework to competitor platforms (Amazon Prime, Hotstar) for a full comparative OTT market study.

---

## Resume Line for This Project

> *"Conducted OTT India market expansion analysis on 8,800+ Netflix titles using PostgreSQL — identifying genre gaps and content mix misalignment, with strategic recommendations for improving Netflix India's subscriber retention."*
