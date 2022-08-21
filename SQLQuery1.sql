SELECT * FROM SQLPortfolio..CovidFatalities
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SQLPortfolio..CovidFatalities
ORDER BY 1,2;


-- Looking at the total cases vs total deaths (DeathPercentage) 
-- Shows likeleyhood of Covid related deaths 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'China'
ORDER BY 1,2;


-- U.S.
-- Looking at Total cases vs Population (InfectionPercentage) & Total cases vs Total deaths
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE Location = 'United States'
ORDER BY 1,2

-- Creating View to store data later for visualizations

CREATE VIEW LocationPercentage AS
SELECT Location, date, population, (total_cases/population)*100 AS InfectionPercentage, (total_deaths/total_cases)*100 AS DeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL

-- Taking a look at Current Average InfectionPercentage and DeathPercentage by Country(Location)
SELECT Location, population, AVG(InfectionPercentage) AS AverageInfectionPercentage, AVG(DeathPercentage) AS AverageDeathPercentage
FROM LocationPercentage
GROUP BY Location, population
ORDER BY 1,2


-- Looking at all countries specifically Highest InfectionCount & their InfectionPercentage
SELECT Location, population, MAX(total_cases) AS HighestInfectionLocation, MAX((total_cases/population))*100 AS InfectionPercentageofCountry
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY Location, population
ORDER BY 3 DESC

--Looking at all countries specifically Highest DeathCount & DeathPercentage
SELECT Location, MAX(cast(Total_deaths AS INT)) AS HighestDeathbyCountry, MAX((total_deaths/population))*100 AS DeathsPercentageofCountry
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY HighestDeathbyCountry DESC

-- Taking a look by Continents now
-- Continent Total Deaths
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeaths
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL AND Location NOT LIKE '%income%' AND Location NOT LIKE '%Union%' AND Location NOT LIKE '%International%' AND Location NOT LIKE '%World%'
GROUP BY continent
ORDER BY TotalDeaths DESC

-- GLOBAL BREAKDOWN

-- Global Cases vs Global Deaths vs GlobalDeathPercentage by Date
SELECT date, SUM(new_cases) AS GlobalCases, SUM(cast(new_deaths AS INT)) AS GlobalDeaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 AS GlobalDeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

 -- Total Global Cases vs Total Global Deaths vs Total GlobalDeathPercentage
SELECT SUM(new_cases) AS GlobalCases, SUM(cast(new_deaths AS INT)) AS GlobalDeaths, SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 AS GlobalDeathPercentage
FROM SQLPortfolio..CovidFatalities
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations
With PopvsVac (continent, locaiton, date, population, new_vaccinations, RollingVaccinationCount)
AS
(
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL
-- ORDER BY 2,3
)
SELECT *, (RollingVaccinationCount/Population)*100
FROM PopvsVac

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent NVARCHAR(255),
Location NVARCHAR(255),
Date Datetime,
Population numeric,
new_vaccinations numeric,
RollingVaccinationCount numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL

SELECT *, (RollingVaccinationCount/Population)*100
FROM #PercentPopulationVaccinated

-- Creating View to store data later for visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT covD.continent, covD.location, covD.date, covD.population, covV.new_vaccinations, SUM(CONVERT(BIGINT, covV.new_vaccinations)) OVER (Partition by covD.Location ORDER BY covD.location, covD.date) AS RollingVaccinationCount
FROM SQLPortfolio..CovidFatalities covD
JOIN SQLPortfolio..CovidVaccinations covV
	ON covD.location = covV.location
	AND covD.date = covV.date
WHERE covD.continent IS NOT NULL
--ORDER BY 2,3

