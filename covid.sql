Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, 
(total_deaths *1. /total_cases)*100 as DeathPercentage  --*1. is used for division
From CovidDeaths
Where continent is not null AND location like 'India' ;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, Population, total_cases,  
(total_cases *1. /population)*100 as PercentPopulationInfected
From CovidDeaths
Where continent is not null 
--Where location like 'India'
order by 1,2;

-- Countries with Highest Infection Rate compared to Population
Select Location, population, 
MAX(total_cases) as HighestInfectionCount,
MAX((total_cases *1. /population))*100 as PercentPopulationInfected
From CovidDeaths
Where continent is not null 
GROUP BY location,population
order by PercentPopulationInfected DESC;


-- Countries with Highest Death Counts
Select Location, MAX(cast(total_deaths as INT)) as TotalDeathCount
--Here we are using cast as total_deaths is nvchar error and we are converting to int
From CovidDeaths
Where continent is not null 
GROUP BY location
order by TotalDeathCount DESC;


---- Ordering by contintents with the highest death count per population
SELECT continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
GROUP BY continent
order by TotalDeathCount DESC;


--Death Percentage Globally On A Daily Basis
-- Select cast(date as .....), SUM(new_cases) as total_cases, 
-- SUM(cast(new_deaths as int)) as total_deaths, 
-- SUM(cast(new_deaths as int) *1. )/SUM(New_Cases)*100 as DeathPercentage
-- From  CovidDeaths
-- where continent is not null 
-- group by date;



--Global Death Percentage Till Date
Select SUM(new_cases) as total_cases_globally, 
SUM(cast(new_deaths as int)) as total_deaths_globally, 
SUM(cast(new_deaths as int) *1. )/SUM(New_Cases)*100 as DeathPercentage_Globally
--Here we are using cast to convert new_deaths from text to int
From CovidDeaths
where continent is not null;



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,

SUM(Cast(vac.new_vaccinations as int)) 

	OVER (PARTITION by dea.location Order by dea.location, dea.Date) 

	as RollingPeopleVaccinated 

-- 	(RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea JOIN CovidVaccinations vac

	on dea.location = vac.location

	and dea.date = vac.date

where dea.continent is not null;





-- Using CTE to perform Calculation on Partition By in previous query



With PopvsVac (Continent, Location, Date, Population, 

New_Vaccinations, RollingPeopleVaccinated)

as

(

Select dea.continent, dea.location, dea.date, 

dea.population, vac.new_vaccinations,

SUM(Cast(vac.new_vaccinations as int))

	OVER (Partition by dea.Location Order by dea.location, dea.Date) 

	as RollingPeopleVaccinated

	-- (RollingPeopleVaccinated/population)*100

From CovidDeaths dea Join CovidVaccinations vac

	On dea.location = vac.location

	and dea.date = vac.date

where dea.continent is not null 

)

Select *, (RollingPeopleVaccinated *1. /Population)*100 as PeopleVaccinatedPercentage

From PopvsVac





-- Creating View to store data for later visualizations



Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations

, SUM(Cast(vac.new_vaccinations as int))

 OVER (Partition by dea.Location Order by dea.location, dea.Date) 

 as RollingPeopleVaccinated



 From CovidDeaths dea

Join  CovidVaccinations vac

	On dea.location = vac.location

	and dea.date = vac.date

where dea.continent is not null; </sql><current_tab id="0"/></tab_sql></sqlb_project>