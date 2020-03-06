gc(reset=TRUE)

setwd("/home/ds/Documents/") 


# Carregando os pacotes

library(RMySQL)
library(dplyr)
library(data.table)
library(Matrix)
library(corrplot)
library(stringr)
library(forecast)
library(forecastHybrid)
library(RPostgreSQL)

# Definindo o driver para conexao com o BD 'datascience'

drv <- dbDriver("PostgreSQL")

# Declarando senha do BD e demais informacoes para conexao

pw <- {
  "dsdb2019"
}

conexao <- dbConnect(drv, dbname = "datascience",
                     host = "localhost", 
                     user = "dsdb", password = pw)



# Consulta diretamente no BD com a consulta padrao Postgresql

export_graos <- dbGetQuery(conexao, "select 
e.co_ano co_ano,
e.co_mes,
e.co_ncm,
ncm.no_ncm_por,
ncm.co_unid,
ncm.no_unid,
e.co_pais,
pa.no_pais,
e.co_uf,
e.co_urf,
e.qt_estat,
case when ncm.co_unid=10
then (e.qt_estat / 1000)
else e.qt_estat
end as co_toneladas,
e.vl_fob,
e.ano_mes as co_ano_mes,
ct.cotacao
from 
ds_exportacoes as e
left join
ds_ncm as ncm on e.co_ncm=ncm.co_ncm
inner join
ds_cotacao as ct on e.ano_mes = ct.ano_mes 
left join
ds_pais as pa on e.co_pais = pa.co_pais
;")

View(export_graos)

export_graos


# Analisando a Qualidade dos Dados

## Nomes dos Campos

names(export_graos)



# Valores Maximos e Minimos dos principais campos

## ANO

min(export_graos$co_ano)

max(export_graos$co_ano)



## Toneladas

min(export_graos$co_toneladas)

max(export_graos$co_toneladas)

## Aqui tem uma irregularidade e deverá ser tratada

export_graos <- export_graos[export_graos$co_toneladas>=0,]

## Verificando ajuste

min(export_graos$co_toneladas)

# Grafico para entender melhor a distribuicao

plot(export_graos$co_toneladas~export_graos$co_ano)

boxplot(export_graos$co_toneladas~export_graos$co_ano)

boxplot(export_graos$co_toneladas[export_graos$co_ano<=2018&export_graos$co_toneladas>=500000]~export_graos$co_ano[export_graos$co_ano<=2018&export_graos$co_toneladas>=500000])

unique(export_graos$no_ncm_por)

unique(export_graos$co_uf[export_graos$co_toneladas>=150000000&export_graos$co_ano==2018&export_graos$no_ncm_por=='Soja, mesmo triturada, exceto para semeadura'])


## Valor em Dolares

min(export_graos$vl_fob)

max(export_graos$vl_fob)




## Cotacao do Dolar

min(export_graos$cotacao)

max(export_graos$cotacao)





## Ou prode-se fazer isto no atacado

summary(export_graos)




## Agora após ajustados os dados, eles serao explorados

## Qual e o maior pais Importador geral de Graos em Valor?

import <- data.frame((export_graos %>%
                        group_by(co_pais,no_pais) %>%
                        dplyr::summarise(Dolares=sum(vl_fob, NA, na.rm = TRUE)
                        )),
                     row.names = NULL)

import

summary(import)


## Armazenando e encontrando o Pais

m_v <- max(import$Dolares)

p <- import[import$Dolares == m_v,]

p


## E o maior importador em Toneladas?

import_2 <- data.frame((export_graos %>%
                          group_by(co_pais,no_pais) %>%
                          dplyr::summarise(Toneladas=sum(co_toneladas, NA, na.rm = TRUE)
                          )),
                       row.names = NULL)

head(import_2,5)

tail(import_2,6)

## Agrupamento gerou varios valores nulos, serao substituidos

import_2$Toneladas[which(is.na(import_2$Toneladas))] <- 0


## Encontrando e armazenando o Pais

m_v <- max(import_2$Toneladas)

t <- import_2[import_2$Toneladas == m_v,]

t


## E os maiores em toneladas por tipo de graos

### Agrupando os valores em codigo e nome de pais + codigo e nome de ncm e sumarizando Toneladas

import_3 <- data.frame((export_graos %>%
                          group_by(co_pais,no_pais,co_ncm,no_ncm_por) %>%
                          dplyr::summarise(Toneladas=sum(co_toneladas, NA, na.rm = TRUE)
                          )),
                       row.names = NULL)

head(import_3,3)

### Separando os codigos e nomes dos ncm ou Graos

desc_ncm <- data.frame((import_3 %>%
                          group_by(co_ncm)%>%
                          dplyr::summarise(desc_ncm=min(no_ncm_por, NA, na.rm = TRUE)))
                       ,
                       row.names=NULL)

unique(desc_ncm)

### Ordenando as toneladas por tipo de Graos

m_i_soja <- data.table(head(import_3 %>%
                              filter(co_ncm=='?') %>%  
                              group_by(co_pais, no_pais, Grao=no_ncm_por) %>%
                              arrange(desc(Toneladas)),1) 
)

m_i_cafe <- data.table(head(import_3 %>%
                              filter(co_ncm=='?') %>%  
                              group_by(co_pais, no_pais, Grao=no_ncm_por) %>%
                              arrange(desc(Toneladas)),1))


m_i_milho <- data.table(head(import_3 %>%
                               filter(co_ncm=='?') %>%  
                               group_by(co_pais, no_pais, Grao=no_ncm_por) %>%
                               arrange(desc(Toneladas)),1))

m_i_graos <- full_join(m_i_soja, m_i_cafe)

m_i_graos <- full_join(m_i_graos, m_i_milho)

m_i_graos


# E os maiores estados exportadores de Graos em Valor?

export <- data.frame((export_graos %>%
                        group_by(co_uf,co_ncm) %>%
                        dplyr::summarise(Dolares=sum(vl_fob, NA, na.rm = TRUE)
                        )),
                     row.names = NULL)

export

unique(desc_ncm)

m_e_soja <- data.table(head(export %>%
                              filter(co_ncm=='?') %>%  
                              group_by(co_uf,Grao="Soja") %>%
                              arrange(desc(Dolares)),1))

m_e_cafe <- data.table(head(export %>%
                              filter(co_ncm=='?') %>%  
                              group_by(co_uf,Grao="Cafe") %>%
                              arrange(desc(Dolares)),1))


m_e_milho <- data.table(head(export %>%
                               filter(co_ncm=='?') %>%  
                               group_by(co_uf,Grao="Milho") %>%
                               arrange(desc(Dolares)),1))
m_e_soja
m_e_cafe
m_e_milho


## Agora vamos verificar quais variaveis sao mais relevantes para continuarmos com o estudo:

# Correlacao entre quantidade de exportacao e variacao do dolar

cor.test(export_graos$qt_estat,export_graos$cotacao)


## Grafico de correlacao entre estas variaveis

corrplot.mixed(cor(data.frame(Quantidade=export_graos$qt_estat,Dolar=export_graos$cotacao)), 
               number.cex = 1.5, upper = 'ellipse')


## Como a variavel dolar explica a quantidade exportada?

qt_vs_dolar <- lm(export_graos$qt_estat~export_graos$cotacao)

print(qt_vs_dolar)

summary(qt_vs_dolar)


## Estao faltando variaveis para explicar esta relacao, vamos em frente

## Relacao entre pais importador e quantidade exportada

cor.test(export_graos$qt_estat,export_graos$co_pais)

## O que deu de errado?










## Como concertar?
















cor.test(export_graos$qt_estat,as.numeric(export_graos$co_pais))





## Grafico de correlacao entre estas variaveis

corrplot.mixed(cor(data.frame(Quantidade=export_graos$qt_estat,Pais=as.numeric(export_graos$co_pais))), 
               number.cex = 1.5, upper = 'ellipse')


## Como uma variavel explica a quantidade importada?

qt_vs_pais <- lm(export_graos$qt_estat~as.numeric(export_graos$co_pais))

print(qt_vs_pais)

summary(qt_vs_pais)




## Como a variavel co_pais e nominal, nao e possivel fazer esta analise ! ! ! ! ! ! ! ! !

## Quantidade exportada e valor do grao no momento da venda


cor.test(export_graos$qt_estat,export_graos$vl_fob)


corrplot.mixed(cor(data.frame(Quantidade=export_graos$qt_estat,Valor=export_graos$vl_fob)), 
               number.cex = 1.5, upper = 'ellipse')


qt_vs_valor <- lm(export_graos$qt_estat~export_graos$vl_fob)

print(qt_vs_valor)

summary(qt_vs_valor)





# E se verificarmos Valor e dolar juntos com quantidade?


corrplot.mixed(cor(data.frame(Quantidade=export_graos$qt_estat,Valor=export_graos$vl_fob, 
                              Dolar=export_graos$cotacao)), number.cex = 1.5, upper = 'ellipse')


qt_vs_valor_e_dolar <- lm(export_graos$qt_estat~export_graos$vl_fob+export_graos$cotacao)

print(qt_vs_valor_e_dolar)

summary(qt_vs_valor_e_dolar)


# Conseguimos cruzar todas as variaveis e validar todas de uma unica vez?










## Basta separar todas as variaveis numericas numa unica tabela


tab_cor <- data.frame(Quantidade=export_graos$qt_estat,
                      Valor=export_graos$vl_fob, 
                      Dolar=export_graos$cotacao, 
                      Toneladas=export_graos$co_toneladas)


## E fazer a analise de correlacao

corrplot.mixed(cor(tab_cor), number.cex = 1.5, upper = 'ellipse')




## Aqui verifica-se que existe relacao direta entre toneladas comercializadas e o valor em dolar

ton_vs_dolar <- lm(export_graos$co_toneladas~export_graos$vl_fob)

print(ton_vs_dolar)

summary(ton_vs_dolar)



## Neste caso nao existem variaveis neste conjunto que expliquem a quantidade em toneladas exportadas, seria necessario separar por graos e fazer a mesma validacao

# Conclusao: Talvez existam outras variaveis a ser encontradas e anexadas para explicar as vendas de graos