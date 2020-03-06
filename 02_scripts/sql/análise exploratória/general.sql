--My Precious


--Quais NCMs tenho as informações de exportação?
/*
"12019000"	"Soja, mesmo triturada, exceto para semeadura"
"10059010"	"Milho em grăo, exceto para semeadura"
"09011110"	"Café năo torrado, năo descafeinado, em grăo"
*/


--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? 


--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? 


--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - >= and <=


--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - Order by OK

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - Somente os 3 primeiros

--Quais os 3 maiores estados exportadores de SOJA (USD) entre 2014 e 2018? - Somente os 3 primeiros

/*
EM TONELADAS

"MT"	"     5.653.372.256"
"PR"	"     3.395.010.429"
"SP"	"     2.730.859.851"
*/

--Quais os 3 maiores estados exportadores de SOJA (BRL) entre 2014 e 2018? - Somente os 3 primeiros

--Quais os 3 maiores estados exportadores de SOJA (BRL) com TONELADAS TOTAIS entre 2014 e 2018? - Somente os 3 primeiros
/*"     5.653.372.256"
"     3.395.010.429"
"     2.730.859.851"*/

--Analisando SP

--De agora em diante só análise de tonelada e fazer o mesmo estudo para cada um dos commodites

--"12019000"	"Soja, mesmo triturada, exceto para semeadura"

--"10059010"	"Milho em grăo, exceto para semeadura"

--"09011110"	"Café năo torrado, năo descafeinado, em grăo"

--Para evitar exportar cada uma das queries por NCM pq nao uni-las? - UNION - Pegadinha do Malandro - TEM ERRO 

--Nao eh feiticaria eh tecnologia


/* ==============================   Hora de pensar... e pensar... e pensar... ====================== */











/* ==== E PENSAR ===== */












/* O Brasil é o 3o maior produto mundial de milho... e o maior produto mundial de soja. Pq o número do milho estah TAO elevado? */













/* Bora analisar o milho x soja na tabela de NCM x EXPORTACOES em JAN 2018 no MT */

--EUREKA corrigindo o retorno temos


--Corrigindo a fonte de dados do milho para não apresentar mais este problema do Kg x Ton - UPDATE (DML)

--rollback or commit?



--E indices? Temos? Precisa (DDL)


--DROP INDEX 
--rollback ou commit?

--Exercicio HOMEWORK

/*
Seu chefinho quer mais uma analise previa dos dados... ele quer saber quais os 5 PAISES 
(NOME) que mais compraram SOJA, MILHO E CAFE (em toneladas) DO Brasil em 2018

Ex:
Cafe... China 1.500.000.000
Cafe... Japao 1.300.000.000
...
Milho... Portugal 35.000.000
...
Soja... Australia 2.000.000
....


Go Ahead!
*/




------- BONUS ---------

--join de todas as tabelas


--total de linhas por NCM por ano


--Bonus analisando dados duplicados
