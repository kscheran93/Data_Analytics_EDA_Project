-- Exploratory Data Analysis

-- Select all columns from the layoffs_staging2 table
SELECT *
FROM layoffs_staging2;

-- Select the maximum values for total_laid_off and percentage_laid_off columns
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Select all columns from layoffs_staging2 where percentage_laid_off is 1
-- Order the results by funds_raised_millions in descending order
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Select the company and the sum of total_laid_off for each company
-- Group the results by company
-- Order the results by the sum of total_laid_off in descending order
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Select the minimum and maximum dates from the layoffs_staging2 table
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Select the industry and the sum of total_laid_off for each industry
-- Group the results by industry
-- Order the results by the sum of total_laid_off in descending order
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Select the country and the sum of total_laid_off for each country
-- Group the results by country
-- Order the results by the sum of total_laid_off in descending order
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Select the year from the date and the sum of total_laid_off for each year from the layoffs table
-- Group the results by year
-- Order the results by year in descending order
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Select the stage and the sum of total_laid_off for each stage
-- Group the results by stage
-- Order the results by the sum of total_laid_off in descending order
SELECT stage, SUM(total_laid_off)
FROM layoffs
GROUP BY stage
ORDER BY 2 DESC;

-- Select the company and the average percentage_laid_off for each company
-- Group the results by company
-- Order the results by the average percentage_laid_off in descending order
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Select the year and month from the date and the sum of total_laid_off for each month
-- Filter out rows where the year and month are not null
-- Group the results by month
-- Order the results by month in ascending order
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Create a common table expression (CTE) named Rolling_Total
-- Select the year and month from the date and the sum of total_laid_off for each month
-- Filter out rows where the year and month are not null
-- Group the results by month
-- Order the results by month in ascending order
WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS Total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
-- Select the month, total_laid_off, and a running total of total_laid_off ordered by month
SELECT `MONTH`, Total_off, 
SUM(Total_off) OVER(ORDER BY `MONTH`)
FROM Rolling_Total;

-- Select the company and the sum of total_laid_off for each company
-- Group the results by company
-- Order the results by the sum of total_laid_off in descending order
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Select the company, the year from the date, and the sum of total_laid_off for each company-year combination
-- Group the results by company and year
-- Order the results by the sum of total_laid_off in descending order
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Create a common table expression (CTE) named Company_Year
-- Select the company, the year from the date, and the sum of total_laid_off for each company-year combination
-- Group the results by company and year
WITH Company_Year(company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
-- Create another CTE named Company_Year_Rank
-- Select all columns from Company_Year and rank the results within each year by total_laid_off using DENSE_RANK
-- Partition the results by year and order by total_laid_off in descending order
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
-- Select all columns from Company_Year_Rank where the ranking is less than or equal to 5
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;