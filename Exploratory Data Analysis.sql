-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- 1. Maximum employees laid off and percentage laid off in one go

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 2. Finding companies that had 100% of their employees laid off and the exact date when the layoff was made

SELECT company, SUM(total_laid_off), `date`
FROM layoffs_staging2
WHERE percentage_laid_off = 1
GROUP BY company, `date`
ORDER BY SUM(total_laid_off) DESC;

-- 3. Looking at the industry and the country where most laid offs were made
SELECT *
FROM layoffs_staging2;

SELECT industry, country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, country
ORDER BY 3 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- 4. Looking at the year where most laid offs were made

SELECT *
FROM layoffs_staging2;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- 5. Looking at rolling laid offs with dates

SELECT *
FROM layoffs_staging2;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS (
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS laid_offs_totals
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT `MONTH`,laid_offs_totals, SUM(laid_offs_totals) OVER(ORDER BY `MONTH`) AS rolling_totals
FROM Rolling_Total;


-- 6. Ranking companies by most layoffs and layoffs year


SELECT company, SUM(total_laid_off), YEAR (`date`)
FROM layoffs_staging2
GROUP BY company, YEAR (`date`)
;


WITH Company_Year (company, total_laid_off, years) AS 
(
SELECT company, SUM(total_laid_off), YEAR (`date`)
FROM layoffs_staging2
GROUP BY company, YEAR (`date`)

), Company_Year_Rank As 
-- 7. Ranking by the top 5 companies that did laid offs per year
(SELECT * , DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
AND total_laid_off IS NOT NULL
)

SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;








































