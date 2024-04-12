--Select *
--From [Portfolio Project]..DeathsCovid
--where continent is not null
--order by 3, 4

--Select *
--From [Portfolio Project]..VaccinationsCovid
--order by 3, 4

--Select Location, date, total_cases, new_cases, total_deaths, population
--From [Portfolio Project]..DeathsCovid
--order by 1, 2

-- Converting rows from varchar to int
--ALTER TABLE [Portfolio Project]..DeathsCovid
--ALTER COLUMN total_cases FLOAT
--ALTER TABLE [Portfolio Project]..DeathsCovid
--ALTER COLUMN total_deaths FLOAT


---- Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..DeathsCovid
order by 1, 2

--EXEC sp_help DeathsCovid

Select Location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..DeathsCovid
Where location like '%India%'
order by 1, 2

-- Total Cases vs Population
Select location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
From [Portfolio Project]..DeathsCovid
-- Where location like '%India%'
order by 1, 2


-- Countries with highest infection rates vs population

Select location, MAX(total_cases) as HighestInfections, population, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From [Portfolio Project]..DeathsCovid
GROUP BY location, population
-- Where location like '%India%'
order by InfectedPopulationPercentage desc --remove desc for ascending order

-- Countries with Highest Death Count per population

Select Location, MAX(total_deaths) as TotalDeathCount
From [Portfolio Project]..DeathsCovid
-- where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Breaking down data by continent
Select location, MAX(total_deaths) as TotalDeathCount
From [Portfolio Project]..DeathsCovid
-- where location like '%India%'
where continent is null
Group by location
order by TotalDeathCount desc

 
-- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage 
From [Portfolio Project]..DeathsCovid
-- where location like %India%
where continent is not null
Group by date
order by 1, 2


-- Joining both tables

SELECT * 
From [Portfolio Project]..DeathsCovid deaths
Join [Portfolio Project]..VaccinationsCovid vacs
	On deaths.location = vacs.location 
	and deaths.date = vacs.date

-- Total Population that got vaccines
--ALTER TABLE VaccinationsCovid
--ALTER COLUMN new_vaccinations BIGINT



-- Making a temp table

With PopulvsVac(Continent, Location, Date, Population, new_vaccinations, IncreasingDailyVaccinationsCount)
as
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(cast(vacs.new_vaccinations as bigint)) OVER (Partition by deaths.location Order by deaths.location, deaths.date) as IncreasingDailyVaccinationsCount
From [Portfolio Project]..DeathsCovid deaths
Join [Portfolio Project]..VaccinationsCovid vacs
	On deaths.location = vacs.location 
	and deaths.date = vacs.date
where deaths.continent is not null
--order by 2, 3
)
Select * ,(IncreasingDailyVaccinationsCount/Population)*100
From PopulvsVac


--------------
DROP Table if exists PercentageVaccinatedPopulation
CREATE Table PercentageVaccinatedPopulation
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric, 
IncreasingDailyVaccinationsCount numeric
)

Insert into PercentageVaccinatedPopulation

-- View to store data for visualization
Create View PercentageVaccinatedPopulation as 
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations,
SUM(cast(vacs.new_vaccinations as bigint)) OVER (Partition by deaths.location Order by deaths.location, deaths.date) as IncreasingDailyVaccinationsCount
From [Portfolio Project]..DeathsCovid deaths
Join [Portfolio Project]..VaccinationsCovid vacs
	On deaths.location = vacs.location 
	and deaths.date = vacs.date
where deaths.continent is not null
--order by 2, 3

Select * ,(IncreasingDailyVaccinationsCount/Population)*100
From PercentageVaccinatedPopulation


