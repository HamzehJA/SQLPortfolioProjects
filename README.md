COVID Data Analysis
Overview
This repository contains SQL queries used to analyze and visualize COVID-19 related data. It includes queries for understanding the relationship between total cases, deaths, and vaccinations across different locations and continents. The data is stored in the SQLPortfolio..CovidFatalities and SQLPortfolio..CovidVaccinations tables.

The analysis explores key metrics like the Infection Rate (InfectionPercentage), Death Rate (DeathPercentage), and Vaccination Progress. The results are visualized through queries that aggregate and break down the data by location, country, continent, and globally.

Queries Overview
1. Basic Data Retrieval
sql
Copy
SELECT * 
FROM SQLPortfolio..CovidFatalities
ORDER BY 3, 4;
Fetches all columns from the CovidFatalities table, ordered by the 3rd and 4th columns.
sql
Copy
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SQLPortfolio..CovidFatalities
ORDER BY 1, 2;
Retrieves location-based COVID data including cases, deaths, and population, ordered by Location and Date.
2. Case Fatality Rate (DeathPercentage)
sql
Copy
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'China'
ORDER BY 1, 2;
Analyzes the death percentage in relation to total cases for China. The DeathPercentage is calculated as (total_deaths / total_cases) * 100.
3. U.S. Specific Analysis (Infection and Death Percentages)
sql
Copy
SELECT Location, date, population, total_cases, 
    (total_cases/population)*100 AS InfectionPercentage, 
    total_deaths, 
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'United States'
ORDER BY 1, 2;
Focuses on the United States and calculates:
Infection Percentage: (total_cases / population) * 100
Death Percentage: (total_deaths / total_cases) * 100
4. Creating Views for Visualization
sql
Copy
CREATE VIEW LocationPercentage AS
SELECT Location, date, population, 
    (total_cases/population)*100 AS InfectionPercentage, 
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL;
Creates a view LocationPercentage that stores data on infection and death percentages for visualization.
5. Average Infection and Death Percentages by Country
sql
Copy
SELECT Location, population, AVG(InfectionPercentage) AS AverageInfectionPercentage, AVG(DeathPercentage) AS AverageDeathPercentage
FROM LocationPercentage
GROUP BY Location, population
ORDER BY 1, 2;
Calculates the average infection and death percentages for each country (Location).
6. Highest Infection Count & Infection Percentage by Country
sql
Copy
SELECT Location, population, MAX(total_cases) AS HighestInfectionLocation, MAX((total_cases/population))*100 AS InfectionPercentageofCountry
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY Location, population
ORDER BY 3 DESC;
Identifies countries with the highest infection counts and their infection percentage.
7. Highest Death Count & Death Percentage by Country
sql
Copy
SELECT Location, MAX(cast(Total_deaths AS INT)) AS HighestDeathbyCountry, MAX((total_deaths/population))*100 AS DeathsPercentageofCountry
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY HighestDeathbyCountry DESC;
Identifies countries with the highest death counts and their death percentage.
8. Continent-Level Data
sql
Copy
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeaths
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL AND Location NOT LIKE '%income%' AND Location NOT LIKE '%Union%' AND Location NOT LIKE '%International%' AND Location NOT LIKE '%World%'
GROUP BY continent
ORDER BY TotalDeaths DESC;
Fetches the total number of deaths by continent, excluding certain locations such as those involving income levels, unions, or international organizations.
9. Global Breakdown by Date
sql
Copy
SELECT date, SUM(new_cases) AS GlobalCases, SUM(cast(new_deaths AS INT)) AS GlobalDeaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 AS GlobalDeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;
Analyzes the global cases and deaths, calculating the global death percentage by date.
10. Total Global Cases, Deaths, and Death Percentage
sql
Copy
SELECT SUM(new_cases) AS GlobalCases, SUM(cast(new_deaths AS INT)) AS GlobalDeaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 AS GlobalDeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
ORDER BY 1, 2;
Summarizes the total global cases, deaths, and death percentage.
11. Population vs Vaccination Analysis
sql
Copy
With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinationCount)
AS
(
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL
)
SELECT *, (RollingVaccinationCount/Population)*100
FROM PopvsVac;
Analyzes population data versus vaccination progress, calculating the rolling total of vaccinations and its percentage of the population.
12. Temporary Table for Vaccination Analysis
sql
Copy
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
continent NVARCHAR(255),
Location NVARCHAR(255),
Date Datetime,
Population numeric,
new_vaccinations numeric,
RollingVaccinationCount numeric
);
INSERT INTO #PercentPopulationVaccinated
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL;

SELECT *, (RollingVaccinationCount/Population)*100
FROM #PercentPopulationVaccinated;
Creates a temporary table to store vaccination-related data and calculates the percentage of population vaccinated.
13. Creating View for Vaccination Data
sql
Copy
CREATE VIEW PercentPopulationVaccinated AS
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL;
Creates a view to store vaccination data, enabling easier access for future visualizations.
