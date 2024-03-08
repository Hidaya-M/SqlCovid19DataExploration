--Covid 19 Data Exploration 

 --Retrieves all data from the CovidDeaths table, ordering the results by the third and fourth columns.
SELECT *
  FROM [ProtfolioProject].[dbo].[CovidDeaths$]
  order by 3,4

-- Retrieves data on COVID-19 cases, deaths, and population for locations starting with 'alg' (such as Algeria) from the CovidDeaths table.
SELECT location,date,total_cases,new_cases,total_deaths,population
  FROM [ProtfolioProject].[dbo].[CovidDeaths$]
  where location like 'alg%'
  
  --Calculates the death percentage in Algeria based on total cases and total deaths.
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
  FROM [ProtfolioProject].[dbo].[CovidDeaths$]
  where location = 'Algeria'

-- Retrieves the maximum death percentage among COVID-19 cases in Algeria.
SELECT location, MAX(DeathPercentage) as MaxDeathPercentageValue
FROM (

    SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
    FROM [ProtfolioProject].[dbo].[CovidDeaths$]
    WHERE location = 'Algeria'
) AS Subquery
 group by location

-- Retrieves the minimum death percentage among COVID-19 cases in Algeria.
SELECT location, MIN(DeathPercentage) as MinDeathPercentageValue
FROM (

    SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
    FROM [ProtfolioProject].[dbo].[CovidDeaths$]
    WHERE location = 'Algeria'
) AS Subquery
group by location

 --Retrieves data for COVID-19 cases in Algeria, including location, date, total cases, population,
 --and the percentage of cases relative to the population.
Select location,date,total_cases,population ,(total_cases/population)*100 as CasesPercentage 
  From ProtfolioProject..CovidDeaths$
 WHERE location='Algeria'

 -- Retrieves the maximum CasesPercentage for COVID-19 cases in Algeria.
Select location, MAX(CasesPercentage ) as MAXCasesPercentage
 from (Select location,date,total_cases,population ,(total_cases/population)*100 as CasesPercentage 
  From ProtfolioProject..CovidDeaths$
 WHERE location='Algeria') AS Subquery
 group by location

  -- Retrieves the minimum CasesPercentage for COVID-19 cases in Algeria.
Select location, MIN(CasesPercentage ) as MINCasesPercentage
 from (Select location,date,total_cases,population ,(total_cases/population)*100 as CasesPercentage 
  From ProtfolioProject..CovidDeaths$
 WHERE location='Algeria') AS Subquery
 group by location

 
--Retrieve max COVID cases by location.
 select location , Max ( total_cases) as MaxTotalCases
 From ProtfolioProject..CovidDeaths$
 where continent is not null 
GROUP BY location
ORDER BY  location, Max ( total_cases) DESC ;

---Retrieve max COVID deaths by location.
 select location , Max ( total_deaths) as MaxTotalDeaths
 From ProtfolioProject..CovidDeaths$
 where continent is not null 
GROUP BY location
ORDER BY  location, Max ( total_deaths) DESC ;

--Retrieve max COVID cases by continent.
 select continent , Max ( total_cases) as MaxTotalCases
 From ProtfolioProject..CovidDeaths$
 where continent is not null 
GROUP BY continent
ORDER BY  continent, Max ( total_cases) DESC ;

---Retrieve max COVID deaths by continent
 select continent , Max ( total_deaths) as MaxTotalDeaths
 From ProtfolioProject..CovidDeaths$
 where continent is not null 
GROUP BY continent
ORDER BY  continent, Max ( total_deaths) DESC ;

--Calculate COVID new cases, deaths, and death percentage.
Select sum(cast(new_deaths as int)) as TotalNewDeaths , SUM(new_cases) as TotalNewCases , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
 From ProtfolioProject..CovidDeaths$

 --Retrieve TotalNewDeaths ,TotalNewCases,DeathPercentage by date.
Select date , sum(cast(new_deaths as int)) as TotalNewDeaths , SUM(new_cases) as TotalNewCases , (sum(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
 From ProtfolioProject..CovidDeaths$
 where continent is not null
 group by date 
 order by 1 

  --Retrieve population vs new_vaccinations
select de.continent , de.location,de.date,de.population,va.new_vaccinations
 From ProtfolioProject..CovidDeaths$ de
 join ProtfolioProject..CovidVaccinations$ va
 on de.location = va.location
 and de.date = va.date 
 where de.continent is not null
 order by 2,3

  --Retrieve Totalnew_vaccinations by location.
select de.continent , de.location,de.date,de.population,va.new_vaccinations , 
SUM(cast(va.new_vaccinations as int)) over (partition by de.location) as PeopleVaccinated
 From ProtfolioProject..CovidDeaths$ de
 join ProtfolioProject..CovidVaccinations$ va
 on de.location = va.location
 and de.date = va.date 
 where de.continent is not null
 order by 2,3

 --Retrieve People Vaccinated Percantege by location.
 WITH PopVacPerTable (continent , location,date,population ,new_vaccinations,PeopleVaccinated) AS
(
 select de.continent , de.location,de.date,de.population,va.new_vaccinations , 
SUM(cast(va.new_vaccinations as int)) over (partition by de.location) as PeopleVaccinated
 From ProtfolioProject..CovidDeaths$ de
 join ProtfolioProject..CovidVaccinations$ va
 on de.location = va.location
 and de.date = va.date 
 where de.continent is not null
 
)
 
 select * ,(PeopleVaccinated/population)*100 as VacPeoplePercentage 
 from PopVacPerTable

      


