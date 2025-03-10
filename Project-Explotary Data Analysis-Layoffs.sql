SELECT *
FROM layoffs_staging2;

---

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

----

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

----

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

----

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

----

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

----

SELECT 	year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 2 DESC;

----

SELECT 	stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

----

SELECT substring(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

---- CTE,

WITH Rolling_Total AS
(SELECT substring(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC)
SELECT `Month`, total_off,
SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

----

SELECT company, year(`date`) AS years,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`) 
ORDER BY 3 DESC;

----

WITH Company_year (company, Years, total_laid_off) AS
(SELECT company, year(`date`) AS Years,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, Years
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE Years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

----

SELECT industry, year(`date`) AS Years, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, years
ORDER BY 3 DESC;

WITH Industry_Year (industry, Years, total_laid_off) AS
(SELECT industry, year(`date`) AS Years, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry, years
), Industry_year_rank AS 
(SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_Off DESC) AS Ranking
FROM Industry_Year
WHERE Years  IS NOT NULL
)
SELECT *
FROM Industry_year_rank
WHERE ranking <= 5;

---

WITH Company_Month (company, `month`, total_laid_off) AS
(SELECT company, month(`date`) AS `month`,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `month`
), Company_month_Rank AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY `month` ORDER BY total_laid_off DESC) AS Ranking
FROM Company_month
WHERE `month` IS NOT NULL)
SELECT *
FROM Company_month_Rank
WHERE Ranking <= 5;

---

SELECT country, year(`date`) AS Years, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, Years
ORDER BY 3 DESC;

WITH Country_years (country, Years, total_laid_off) AS
(SELECT country, year(`date`) AS Years, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, Years), country_rank_Year AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY total_laid_off DESC) AS ranking
FROM country_years
WHERE years IS NOT NULL)
SELECT *
FROM country_rank_year
WHERE ranking <= 5


;

---- ---- ----













