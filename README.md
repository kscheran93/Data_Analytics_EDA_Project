# Exploratory Data Analysis of Layoffs Data

This project performs an Exploratory Data Analysis (EDA) on layoffs data to uncover insights and trends. The analysis uses SQL queries to explore various aspects of the layoffs dataset, which is stored in the `layoffs_staging2` table.

## Project Agenda

### 1. Introduction
- **Objective**: To analyze layoffs data to identify trends, patterns, and key statistics.
- **Data Source**: The `layoffs_staging2` table from the reference project [Data Analytics Portfolio Project: Data Cleaning](https://github.com/kscheran93/Data_analytics_portfolio_project_data_cleaning).

### 2. Data Exploration Queries
1. **Overview of the Data**
   ```sql
   SELECT *
   FROM layoffs_staging2;
   ```

2. **Identify Maximum Layoffs**
   ```sql
   SELECT MAX(total_laid_off), MAX(percentage_laid_off)
   FROM layoffs_staging2;
   ```

3. **Companies with 100% Layoffs**
   ```sql
   SELECT *
   FROM layoffs_staging2
   WHERE percentage_laid_off = 1
   ORDER BY funds_raised_millions DESC;
   ```

4. **Total Layoffs by Company**
   ```sql
   SELECT company, SUM(total_laid_off)
   FROM layoffs_staging2
   GROUP BY company
   ORDER BY 2 DESC;
   ```

5. **Date Range of the Data**
   ```sql
   SELECT MIN(`date`), MAX(`date`)
   FROM layoffs_staging2;
   ```

6. **Total Layoffs by Industry**
   ```sql
   SELECT industry, SUM(total_laid_off)
   FROM layoffs_staging2
   GROUP BY industry
   ORDER BY 2 DESC;
   ```

7. **Total Layoffs by Country**
   ```sql
   SELECT country, SUM(total_laid_off)
   FROM layoffs_staging2
   GROUP BY country
   ORDER BY 2 DESC;
   ```

8. **Yearly Layoffs Trend**
   ```sql
   SELECT YEAR(`date`), SUM(total_laid_off)
   FROM layoffs
   GROUP BY YEAR(`date`)
   ORDER BY 1 DESC;
   ```

9. **Layoffs by Company Stage**
   ```sql
   SELECT stage, SUM(total_laid_off)
   FROM layoffs
   GROUP BY stage
   ORDER BY 2 DESC;
   ```

10. **Average Layoff Percentage by Company**
    ```sql
    SELECT company, AVG(percentage_laid_off)
    FROM layoffs_staging2
    GROUP BY company
    ORDER BY 2 DESC;
    ```

11. **Monthly Layoffs Trend**
    ```sql
    SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC;
    ```

12. **Rolling Total of Layoffs**
    ```sql
    WITH Rolling_Total AS 
    (
    SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS Total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
    )
    SELECT `MONTH`, Total_off, 
    SUM(Total_off) OVER(ORDER BY `MONTH`)
    FROM Rolling_Total;
    ```

13. **Total Layoffs by Company (Repeated)**
    ```sql
    SELECT company, SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company
    ORDER BY 2 DESC;
    ```

14. **Yearly Layoffs by Company**
    ```sql
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ORDER BY 3 DESC;
    ```

15. **Top 5 Companies by Yearly Layoffs**
    ```sql
    WITH Company_Year(company, years, total_laid_off) AS 
    (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ), Company_Year_Rank AS
    (
    SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_Year
    WHERE years IS NOT NULL
    )
    SELECT *
    FROM Company_Year_Rank
    WHERE Ranking <= 5;
    ```

## Conclusion
This EDA provides a comprehensive analysis of layoffs data, helping to identify key trends and insights. The SQL queries above cover various dimensions, including overall data overview, maximum layoffs, company-specific analysis, industry and country breakdowns, and temporal trends.

## References
- [Data Analytics Portfolio Project: Data Cleaning](https://github.com/kscheran93/Data_analytics_portfolio_project_data_cleaning)

## Author
- [Sai Charan katkam](https://github.com/kscheran93)
