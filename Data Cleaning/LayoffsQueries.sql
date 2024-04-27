-- Data Cleaning

SELECT * from layoffs;

-- Removing duplicates
-- Standardizing Data
-- Deal with null or blank values



CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * from layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT *, ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT * from duplicate_cte WHERE row_num > 1;

SELECT * from layoffs_staging WHERE company = 'Casper';
SELECT * from layoffs_staging WHERE company = 'Oda';

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
DELETE from duplicate_cte WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * from layoffs_staging2 WHERE row_num > 1;
DELETE from layoffs_staging2 WHERE row_num > 1;
SELECT * from layoffs_staging2;

-- Standardizing Data
SELECT company, TRIM(company) from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT distinct(industry) from layoffs_staging2 
ORDER by 1;
-- Removing crypto doubles
SELECT * from layoffs_staging2 WHERE industry like 'Crypto%';

UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- Checking for issues
SELECT distinct(location) from layoffs_staging2
ORDER by 1;

SELECT distinct(country) from 
ORDER by 1;

SELECT distinct(country), TRIM(TRAILING '.' from country) from layoffs_staging2
ORDER by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'United States%';

SELECT * from layoffs_staging2;
-- Converting date column from text to date type
SELECT `date`, str_to_date(`date`, '%m/%d/%Y') from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY column `date` DATE;

SELECT * from layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off is NULL;

SELECT distinct(industry) from layoffs_staging2;

SELECT industry from layoffs_staging2 WHERE industry = NULL or industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * from layoffs_staging2
WHERE company = 'Airbnb';

SELECT * from layoffs_staging2
WHERE company like 'Bally%';


SELECT layoffs1.industry, layoffs2.industry
FROM layoffs_staging2 layoffs1
JOIN layoffs_staging2 layoffs2 
	ON layoffs1.company = layoffs2.company
    
WHERE (layoffs1.industry = NULL or layoffs1.industry = '') and layoffs2.industry IS NOT NULL;

UPDATE layoffs_staging2 layoffs1
JOIN layoffs_staging2 layoffs2
	ON layoffs1.company = layoffs2.company
SET layoffs1.industry = layoffs2.industry
WHERE (layoffs1.industry IS NULL or layoffs1.industry = '')
AND layoffs2.industry IS NOT NULL;

-- Removing redundant rows
SELECT * 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT * from layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



