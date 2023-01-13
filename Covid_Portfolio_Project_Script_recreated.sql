SELECT *
FROM Prototype..CovidDeaths$
ORDER BY 3,4;

--SELECT *
--FROM Prototype..CovidVaccination$
--ORDER BY 3,4;

-- select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from Prototype..CovidDeaths$
order by 1,2;

-- looking at total cases vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS percentage_of_death
from Prototype..CovidDeaths$
where location like 'Nigeria'
order by 1,2;

-- looking at countries with highest infection rate compared to Population

select location, Population, MAX(total_cases) AS HighestInfectionCounts,MAX((total_cases/population))*100 AS Percentage_population_infected
from Prototype..CovidDeaths$
where location like 'Nigeria'
GROUP BY location, Population
order by Percentage_population_infected DESC;

-- countries with the highest death count per population

select location,  MAX(cast(total_deaths AS int)) AS TotalDeathCounts
from Prototype..CovidDeaths$
--where location like 'Nigeria'
where continent IS NOT NULL
GROUP BY location
order by TotalDeathCounts DESC;


-- Let's break things down y continent


-- showing the continents with the highest death counts.


select continent, MAX(cast(total_deaths AS int)) AS TotalDeathCounts
from Prototype..CovidDeaths$
--where location like 'Nigeria'
where continent IS NOT NULL
GROUP BY continent
order by TotalDeathCounts DESC;


-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100
as DeathPercentage
FROM Prototype..CovidDeaths$
where continent is not null
order by 1,2;


-- joining tables

-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location)
from Prototype..CovidDeaths$ AS dea
join Prototype..CovidVaccination$ AS vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location)
from Prototype..CovidDeaths$ AS dea
join Prototype..CovidVaccination$ AS vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- creating view to store data for later visualization

create view vizual as 

select continent, MAX(cast(total_deaths AS int)) AS TotalDeathCounts
from Prototype..CovidDeaths$
--where location like 'Nigeria'
where continent IS NOT NULL
GROUP BY continent
--order by TotalDeathCounts DESC;
