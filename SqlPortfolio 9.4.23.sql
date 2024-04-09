Select location, population,total_cases, (total_deaths/total_cases) AS DeathPerCase
From Project2.dbo.CovidDeathes


Select location, Date, total_cases, total_deaths, population
From Project2..CovidDeathes
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Show liklihood of dying if you contact covid in your country

Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project2..CovidDeathes
where location like '%state%'
order by 1,2

-- Looking at Total Cases in your country

Select location, date, total_cases, population

,convert(decimal,total_cases)/(population)*100 as CasesPop
From Project2..CovidDeathes
where location like '%state%'
order by total_cases DESC

--Modify Population issue using convert 
--(CONVERT(float,total_cases)/nullif (CONVERT(decimal,population),0))*100 as CasesPop
--1
select location, total_cases,population 
,(CONVERT(decimal,total_cases)/nullif (CONVERT(decimal,population),0))*100 as CasesPop
from Project2..CovidDeathes
--2
select location,total_cases,population , ((total_cases)/Nullif (convert(decimal,population),0))*100as Nopeople
from Project2..CovidDeathes

-- Looking at countries with Highest Infection Rate compare to Poppulation
Select location, population
, MAX(total_cases) as HighestInfectionCount
, MAX((total_cases)/Nullif (convert(decimal,population),0)*100)as PercenPopInfected
From Project2..CovidDeathes
--where location like '%state%'
Group by location, population 
order by location, PercenPopInfected Desc

-- Showing Countries with Highest Death Count per Poppulation

Select location
, MAX(total_deaths) as HighestDeathCount
From Project2..CovidDeathes
where continent is not null
Group by location
order by  HighestDeathCount Desc



SELECT 
    location, Population,
    MAX(CAST(total_deaths AS int)) AS HighestDeathCount,
    (MAX(CAST(total_deaths AS int)) / NULLIF(CONVERT(DECIMAL, MAX(population)), 0)) * 100 AS PercentOfHighestCountperPop
FROM 
    Project2..CovidDeathes
WHERE 
    continent IS NOT NULL
GROUP BY 
    location, Population
ORDER BY 
    PercentOfHighestCountperPop DESC;


-- let's break things down by continent
Select continent
, MAX(CAST(total_deaths AS int)) as HighestDeathCount
From Project2..CovidDeathes
where continent is not null
Group by continent
order by HighestDeathCount Desc

--Show continents with the hightest death count per population
Select continent
, MAX(CAST(total_deaths AS int)) as HighestDeathCount
From Project2..CovidDeathes
where continent is not null
Group by continent
order by HighestDeathCount Desc


-- global Numbers


Select date,SUM(new_cases) as SumCases, SUM(new_deaths) as SumnewDeaths
, SUM(cast(new_deaths as decimal))/SUM(cast(new_cases as decimal))* 100 as PercentDeath
From Project2..CovidDeathes
--where location like '%state%'
where new_cases <> 0 and new_deaths <> 0
group by date
order by 2 Desc


Select SUM(new_cases) as SumCases, SUM(cast(new_deaths as int)) as SumnewDeaths
--, SUM(cast(new_deaths as decimal))/SUM(cast(new_cases as decimal))* 100 as PercentDeath
, sum(new_deaths)/sum(new_cases)*100 as Pert
From Project2..CovidDeathes
where continent is not null
--group by date
--order by 1,2


-- Looking at Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated
--, RollingPopvaccinated/population*100
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopVac (continent, location, date, population, new_vaccinations, RollingPopvaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *
From PopVac



--Temp Table
Drop Table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255)
,location nvarchar(225)
,Date datetime
,Population numeric
,New_Vaccinations numeric
,RollingPopVaccinated2 numeric
)

Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated2
--, RollingPopvaccinated2/population*100
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
Select *, (RollingPopVaccinated2/Population)*100 as PercentOf
From #PercentPopulationVaccinated


-- creating  View to store data for later visualization

Create View PertPopVaccinated As
select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PertPopVaccinated









