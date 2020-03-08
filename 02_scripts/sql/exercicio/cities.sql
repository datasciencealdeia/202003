--minha primeira query em SQL (DDL)
SELECT 'Hello World!';

--minha primeira query util
--city
select * from city;

--country
select * from country;

--countrylanguage
select * from countrylanguage;

--Sera que temos curitiba na base? (Clausula WHERE)
select * from city where name = 'Curitiba';

--Sera que temos Brasil? (Clausula WHERE)
select upper('hello world');

select * from country where upper(name) = 'BRASIL';
select * from country where upper(name) like 'BRA%';
select * from country where upper(name) like '%BRA%';
select * from country where upper(name) like 'BRA%' OR upper(name) like 'ARGEN%';

--Quais todas as cidades do Brasil listadas?
select * from city where countrycode='BRA';

select 
  city.name
  ,country.name
from 
  city inner join country on city.countrycode = country.code 
where 
  upper(country.name) like 'UNI%';

--Quantas cidades do Brasil temos? (COUNT)
select 
  count(*)
from 
  city inner join country on city.countrycode = country.code 
where 
  upper(country.name) like 'BRA%';
  
--Ordenando a listagem de cidades do Brasil por... populacao... (ORDER BY)
select 
  city.*
from 
  city inner join country on city.countrycode = country.code 
where 
  upper(country.name) like 'BRA%'
order by
  city.population;
  
--Ordenando a query acima da maior para menor (ORDER BY DESC)
select 
  city.*
from 
  city inner join country on city.countrycode = country.code 
where 
  upper(country.name) like 'BRA%'
order by
  city.population DESC;
  
select 
  city.*
from 
  city inner join country on city.countrycode = country.code 
where 
  upper(country.name) like 'BRA%'
order by
  5 DESC;

--Quais as linguas faladas no Brasil?
select
countrylanguage.*
from
country
,countrylanguage
where
country.code = countrylanguage.countrycode
and upper(country.name) like 'BRA%'
;

--Quais todas as cidades de todos os paises (CARTESIANO)
select
*
from
city
,country;

--Quais todas as cidades de todos os paises (JOIN CORRETO / AS DUAS SINTAXES)
select
*
from
city
,country
where
city.countrycode=country.code;

select
*
from
city inner join country on city.countrycode = country.code;

--Quem eh o chefe de estado do vaticano e quais as linguas faladas? (LIKE e booleano AND)
select
country.name as Pais
,country.headofstate as ChefeDeEstado
,countrylanguage.language as LinguaFalada
from
country inner join countrylanguage on countrylanguage.countrycode = country.code
where
upper(country.name) like '%VAT%' ;

--Primeiro desafio Kit Kat... Quantas cidades da America Latina temos na base? (10 min)
--Dica America Latina sao 20 paises ao todo que tem como lingua oficial Spanish, Portuguese e French
--Puerto Rico (PRI), Saint Pierre and Miquelon (SPM), Guadeloupe (GLP), Canada (CAN) e Martinique (MTQ), não estao na lista de paises da america latina

--Resp: 684
select 
  count(city.*) 
from 
  country
  inner join countrylanguage on countrylanguage.countrycode = country.code
  inner join city on city.countrycode = country.code
where 
  country.continent in ('South America', 'North America') 
  and countrylanguage.isofficial is true 
  and countrylanguage.language in ('Spanish', 'Portuguese', 'French')
  and country.code not in ('PRI','SPM','GLP','CAN','MTQ') 
  ;

--Quais os 10 paises com maior populacao somando a populacao das cidades? (SUM e GROUP BY e ORDER BY)
select
country.name as pais
,country.headofstate
,sum(city.population) as populacao
from
country inner join city on city.countrycode = country.code
group by
country.name
,country.headofstate
order by 3 DESC
LIMIT
10;

--Segundo desafio Kit Kat... Qual a quantidade, por sistema de governo, dos paises, 
--ordenada do maior para o menor? (5 min)
--"Republic"	"122"
--"Constitutional Monarchy"	"29"
--"Federal Republic" "15"
cit
select
governmentform
,count(*)
from
country
group by
governmentform
order by 2 desc
;

--Qual o pais que teve sua independencia mais recente? (MAX)
select
*
from
country
where
indepyear in (select max(indepyear) from country);

--Qual o pais com independencia mais antiga? (MIN)
select
*
from
country
where
indepyear in (select min(indepyear) from country);

--Qual o maior pais do mundo em populacao? Qual o menor pais do mundo (UNION e SUBQUERY, ALIAS COLUNA)
select
*
from
country
where
population in (select max(population) from country)
UNION
select
*
from
country
where
population in (select min(population) from country where population>0);

--Qual a maior cidade em populacao e em qual pais esta? E a menor e o pais (UNION e SUBQUERY, ALIAS COLUNA)
select
ct.name
,c.*
from
country as ct inner join city as c on ct.code = c.countrycode
where
c.population in (select max(population) from city)
UNION
select
ct.name
,c.*
from
country as ct inner join city as c on ct.code = c.countrycode
where
c.population in (select min(population) from city where population>0);

--Terceiro desafio Kit Kat...
--Qual o pais com a maior expectativa de vida,qual é a expectativa e sua capital? Qual o pais com a menor expectiva de vida, sua expectativa e a capital?

--MAIOR EXPECTATIVA Andorra 83.5 Andorra la Vella
--MENOR EXPECTATIVA Zambia 37.2 Lusaka

select
'MENOR EXPECTATIVA'
,ct.name as País
,ct.lifeexpectancy as Expectativa
,c.name
from
country ct
inner join city c on c.id = ct.capital
where
ct.lifeexpectancy in (select min(lifeexpectancy) from country)
UNION
select
'MAIOR EXPECTATIVA'
,ct.name as País
,ct.lifeexpectancy as Expectativa
,c.name
from
country ct
inner join city c on c.id = ct.capital
where
ct.lifeexpectancy in (select max(lifeexpectancy) from country)
;

--FAZER COM OR (Retirando label de expectativa)
