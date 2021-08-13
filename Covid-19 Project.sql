-- Look inside the table for Covid cases and deaths
SELECT *
FROM CovidProject.dbo.CovidCases$

-- Look inside the table for Covid vaccinations stats
SELECT *
FROM CovidProject.dbo.CovidVaccinations$

-- Covid cases stats (total cases and population infected) of every country 
SELECT location, population, MAX(total_cases) as total_cases,
(MAX(total_cases) / population) as population_infected
FROM CovidProject.dbo.CovidCases$
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY population_infected

-- Covid cases and deaths in every country
SELECT location, date, population, total_cases, total_deaths
FROM CovidProject.dbo.CovidCases$
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Covid cases, deaths, and mortality rate in the United States day-by-day
SELECT location, date, total_cases, total_deaths, 
(total_deaths / total_cases) * 100 as mortality_rate
FROM CovidProject.dbo.CovidCases$
WHERE continent IS NOT NULL AND location = 'United States'
ORDER BY location, date

-- Covid stats (cases, deaths, infection rate, and death rate) of every country
SELECT location, population, MAX(total_cases) as total_cases, MAX(cast(total_deaths as int)) as total_deaths,
(MAX(total_cases) / population) * 100 as population_infected,
(MAX(cast(total_deaths as int)) / population) * 100 as population_died
FROM CovidProject.dbo.CovidCases$
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY total_cases DESC

-- Covid stats by continent
SELECT location, population, MAX(total_cases) as total_cases, MAX(cast(total_deaths as int)) as total_deaths,
(MAX(total_cases) / population) * 100 as population_infected,
(MAX(cast(total_deaths as int)) / population) * 100 as population_died
FROM CovidProject.dbo.CovidCases$
WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location, population
ORDER BY total_cases DESC

-- Covid stats - Worldwide/Globally (as of 8/10/2021)
SELECT population, MAX(total_cases) as total_cases, MAX(cast(total_deaths as int)) as total_deaths,
(MAX(total_cases) / population) * 100 as population_infected,
(MAX(cast(total_deaths as int)) / population) * 100 as population_died
FROM CovidProject.dbo.CovidCases$
WHERE location = 'World'
GROUP BY population

-- Covid vaccinations stats (total vaccinations, new vaccinations per day)
-- Joining the CovidCases table with CovidVaccinations
SELECT cas.location, cas.date, vac.total_vaccinations, vac.new_vaccinations
FROM CovidProject.dbo.CovidCases$ cas
JOIN CovidProject.dbo.CovidVaccinations$ vac
ON cas.location = vac.location AND cas.date = vac.date
WHERE cas.continent IS NOT NULL
ORDER BY location, date

-- People vaccinated, fully vaccinated, and the percentage over the entire population
SELECT cas.location, cas.date, cas.population, vac.people_vaccinated,
(vac.people_vaccinated / cas.population) * 100 as partial_vaxxed,
vac.people_fully_vaccinated,
(vac.people_fully_vaccinated / cas.population) * 100 as fully_vaxxed
FROM CovidProject.dbo.CovidCases$ cas
JOIN CovidProject.dbo.CovidVaccinations$ vac
ON cas.location = vac.location AND cas.date = vac.date
WHERE cas.continent IS NOT NULL
ORDER BY location, date, population

