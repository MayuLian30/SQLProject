Select location, population,total_cases, (total_deaths/total_cases)
From Project2.dbo.CovidDeathes


--use Project2 
--Select location, DAT, total_cases
--From CovidDeathes


use Project2
Select location, Date, total_cases, total_deaths, population
From Project2..CovidDeathes
order by 1,2

-- Looking at Total Cases vd Total Deaths
-- Show liklihood of dying if you contact covid in your country
use Project2
Select location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project2..CovidDeathes
where location like '%state%'
order by 1,2

-- Looking at Total Cases in your country
Select location, date, total_cases, total_deaths,( Convert (decimal, total_deaths)/Nullif (convert (decimal,total_cases),0))*100 as DeathePercentage
From Project2..CovidDeathes
where location like '%state%'
order by 1,2

Select location, date, total_cases, population
,(CONVERT(float,total_cases)/Nullif (CONVERT(decimal,population),0))*100 as CasesPop
From Project2..CovidDeathes
where location like '%state%'

--Modify Population issue using convert 
select total_cases,population , (convert(int,total_cases)/Nullif (convert(decimal,population),0) )as Nopeople
from Project2..CovidDeathes

select total_cases,population , ((total_cases)/Nullif (convert(decimal,population),0) )as Nopeople
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
--where location like '%state%'
Group by location
order by  HighestDeathCount Desc

Select location
, MAX(CAST(total_deaths AS int)) as HighestDeathCount
From Project2..CovidDeathes
where continent is not null
Group by location
order by HighestDeathCount Desc

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

use Project2
Select SUM(new_cases) as SumCases, SUM(new_deaths) as SumnewDeaths
, SUM(cast(new_deaths as decimal))/SUM(cast(new_cases as decimal))* 100 as PercentDeath
From Project2..CovidDeathes
--where location like '%state%'
where new_cases <> 0 and new_deaths <> 0
group by date
order by 2 Desc

use Project2
Select SUM(new_cases) as SumCases, SUM(cast(new_deaths as int)) as SumnewDeaths
--, SUM(cast(new_deaths as decimal))/SUM(cast(new_cases as decimal))* 100 as PercentDeath
, sum(new_deaths)/sum(new_cases)*100 as Pert
From Project2..CovidDeathes
--where location like '%state%'
where continent is not null
--group by date
order by 1,2


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



--Temp Table
Drop Table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
Continent nvarchar(255)
,location nvarchar(225)
,Date datetime
,Population numeric
,New_Vaccinations numeric
,RollingPopVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated
--, RollingPopvaccinated/population*100
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
Select *, (RollingPopVaccinated/Population)*100
From #PercentPopulationVaccinated


-- creating  View to store data for later visualization

Create View PercentPopulationVaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPopvaccinated
--, RollingPopvaccinated/population*100
From Project2..CovidDeathes dea
Join Project2..Vaccinn vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated










