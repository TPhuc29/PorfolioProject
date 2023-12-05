USE porfolioproject;

SELECT * 
FROM coviddeaths c 
WHERE c.continent !=''
ORDER BY 3,4;

-- Select Data for using

SELECT location,`date` , total_cases ,new_cases ,total_deaths ,population 
FROM coviddeaths c 
ORDER BY 1,2;

-- Total Cases vs Total Deaths

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage  
FROM coviddeaths c 
WHERE location LIKE '%Vietnam%'
ORDER BY 1,2

-- Total Cases vs Population

SELECT location,date,total_cases ,population ,(total_cases /population)*100 AS AffectedPercentage
FROM coviddeaths c 
WHERE location LIKE '%Vietnam'
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population

SELECT location,MAX(total_cases) AS HighestInfectionCount, population, Max((total_cases /population))*100 AS AffectedPercentage
FROM coviddeaths c  
GROUP BY location,population
ORDER BY AffectedPercentage desc;

-- Countries with Highest Death cases 

SELECT location, MAX(total_deaths) AS HighestDeathsCount
FROM coviddeaths c 
WHERE continent!=''
GROUP BY location
ORDER BY HighestDeathsCount DESC;

-- Deaths by Continents
SELECT continent, MAx(total_deaths) AS DeathsCount
FROM coviddeaths c 
WHERE continent !=''
GROUP BY continent 
ORDER BY DeathsCount DESC;

-- Global Numbers

SELECT
	sum(new_cases) AS Cases,
	sum(new_deaths) AS Deaths,
	sum(new_deaths)/ sum(new_cases) AS Deathpercentage
FROM
	coviddeaths c
WHERE
	continent != ''
	-- GROUP BY `date` 
ORDER BY
	1,
	2;
--------------------

SELECT c.continent ,c.location , c.`date` ,c.population , v.new_vaccinations, sum(v.new_vaccinations) OVER (PARTITION BY c.location ORDER BY c.location,c.`date`)AS RollingPeopleVaccinated
FROM coviddeaths c JOIN covidvaccinations v 
ON c.location =v.location AND c.`date` =v.`date`
WHERE c.continent !=''
ORDER BY 2,3;

-- Use CTE
WITH PopvsVac
AS (
SELECT c.continent ,c.location , c.`date` ,c.population , v.new_vaccinations, sum(v.new_vaccinations) OVER (PARTITION BY c.location ORDER BY c.location,c.`date`)AS RollingPeopleVaccinated
FROM coviddeaths c JOIN covidvaccinations v 
ON c.location =v.location AND c.`date` =v.`date`
WHERE c.continent !=''
ORDER BY 2,3)
SELECT *, (RollingpeopleVaccinated/Popvsvac.population)*100 AS RollingPopulationVaccinatedPercentage 
FROM PopvsVac;



-- Temp Table 
CREATE TABLE Temp
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,  
New_vaccinations nvarchar(255),
RollingPeopleVaccinated NUMERIC
);
INSERT IGNORE INTO Temp 
SELECT c.continent ,c.location , c.`date` ,c.population , v.new_vaccinations, sum(v.new_vaccinations) OVER (PARTITION BY c.location ORDER BY c.location,c.`date`)AS RollingPeopleVaccinated
FROM coviddeaths c JOIN covidvaccinations v 
ON c.location =v.location AND c.`date` =v.`date`
WHERE c.continent !='';

SELECT *, (RollingpeopleVaccinated/population)*100 AS RollingPopulationVaccinatedPercentage 
FROM Temp;

-- Creating View to store data for visualization
CREATE VIEW PopulationVaccinated as
SELECT c.continent ,c.location , c.`date` ,c.population , v.new_vaccinations, sum(v.new_vaccinations) OVER (PARTITION BY c.location ORDER BY c.location,c.`date`)AS RollingPeopleVaccinated
FROM coviddeaths c JOIN covidvaccinations v 
ON c.location =v.location AND c.`date` =v.`date`
WHERE c.continent !='';
-- ORDER BY 2,3;


SELECT * 
FROM Populationvaccinated

