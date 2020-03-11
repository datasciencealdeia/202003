gc(reset=TRUE)

setwd("/home/ds/Documents/") 

# Carregando os pacotes

library(dplyr)
library(data.table)
library(Matrix)
library(readxl)
library(corrplot)
library(stringr)
library(forecast)
library(forecastHybrid)



# Importando o arquivo proviniente da ETL

export_graos <- data.table(read.csv2("https://raw.githubusercontent.com/datasciencealdeia/201903/master/03_dados/auxiliares/Base_AgroXP_0504.csv", header = T, sep=";"))

View(export_graos)



# Importando o arquivo com os Paises Importadores

paises_import <- data.table(read.table("https://raw.githubusercontent.com/datasciencealdeia/201903/master/03_dados/auxiliares/Paises_Importadores.txt", header = T, sep=";", encoding = "UTF-8"))

View(paises_import)



# Criando Informacoes das NCM de soja, milho e cafe

ncm <- data.table(CO_NCM=c(12019000,9011110,10059010), Nome=c("Soja","Cafe","Milho"))

View(ncm)



# Recomenda-se a utilizacao do tempo e da variavel resposta para modelar a previsao
## Serao utilizados os modelos de Series Temporais - ARIMA e Hybrid

# Agrupando as informacoes de vendas de graos, mes a mes, para cada tipo de produto

soja_inf <- data.frame((export_graos[export_graos$CO_NCM==12019000,] %>%
                          group_by(CO_NCM,CO_ANO_MES) %>%
                          dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                          )),
                       row.names = NULL)
View(soja_inf)


cafe_inf <- data.frame((export_graos[export_graos$CO_NCM==9011110,] %>%
                          group_by(CO_NCM,CO_ANO_MES) %>%
                          dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                          )),
                       row.names = NULL)
View(cafe_inf)



milho_inf <- data.frame((export_graos[export_graos$CO_NCM==10059010,] %>%
                           group_by(CO_NCM,CO_ANO_MES) %>%
                           dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                           )),
                        row.names = NULL)
View(milho_inf)


# Separando informacoes para teste dos Modelos

soja_teste    <- soja_inf[soja_inf$CO_ANO_MES >= 201901,]

cafe_teste    <- cafe_inf[cafe_inf$CO_ANO_MES >= 201901,]

milho_teste  <- milho_inf[milho_inf$CO_ANO_MES >= 201901,]

soja_teste



# Separando dados para construcao dos Modelos de Series Temporais

soja_treino    <- soja_inf[soja_inf$CO_ANO_MES < 201901,]

cafe_treino    <- cafe_inf[cafe_inf$CO_ANO_MES < 201901,]

milho_treino  <- milho_inf[milho_inf$CO_ANO_MES >= 201201 & milho_inf$CO_ANO_MES < 201901,]

milho_treino



# Transformando as informacoes em Objetos de Series Temporais

## Soja

min(soja_treino$CO_ANO_MES)

max(soja_treino$CO_ANO_MES)

soja_st <-  ts(soja_treino$Toneladas, frequency = 12, start = c(2012,01), end = c(2018,12))



## Cafe

min(cafe_treino$CO_ANO_MES)

max(cafe_treino$CO_ANO_MES)

cafe_st <-  ts(cafe_treino$Toneladas, frequency = 12, start = c(1997,01), end = c(2018,12))



## Milho

min(milho_treino$CO_ANO_MES)

max(milho_treino$CO_ANO_MES)

milho_st <-  ts(milho_treino$Toneladas, frequency = 12, start = c(2012,01), end = c(2018,12))

## Analisando os graficos de Series Temporais

x11()

par(mfrow=c(3, 1))  

plot(soja_st)

plot(cafe_st)

plot(milho_st)


## Analisando os graficos Ve-se a oportunidade de colocar todos na mesma medida temporal

## Gerando os modelos para cada serie

# ARIMA

soja_mod_ARIMA <- auto.arima(soja_st, seasonal = TRUE, stepwise = FALSE, parallel = TRUE)

cafe_mod_ARIMA <- auto.arima(cafe_st, seasonal = TRUE, stepwise = FALSE, parallel = TRUE)

milho_mod_ARIMA <- auto.arima(milho_st, seasonal = FALSE, stepwise = FALSE, parallel = TRUE)


## Previsao

soja_prev <- forecast(soja_mod_ARIMA,level = 80, h = 6)

cafe_prev <- forecast(cafe_mod_ARIMA,level = 80, h = 6)

milho_prev <- forecast(milho_mod_ARIMA,level = 80, h = 6)



# Modelo Hybrid

soja_mod_hybrid <- hybridModel(soja_st, errorMethod = 'RMSE')

cafe_mod_hybrid <- hybridModel(cafe_st, errorMethod = 'RMSE')

milho_mod_hybrid <- hybridModel(milho_st, errorMethod = 'RMSE')


## Previsao

soja_prev_h <- forecast(soja_mod_hybrid,level = 80, h = 6)

cafe_prev_h <- forecast(cafe_mod_hybrid,level = 80, h = 6)

milho_prev_h <- forecast(milho_mod_hybrid,level = 80, h = 6)


## Analisando os graficos das Previsoes ARIMA

x11()

par(mfrow=c(3, 1))  

plot(soja_prev, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev, showgap = FALSE, xlab = 'CAFE')

plot(milho_prev, showgap = FALSE, xlab = 'MILHO')


## Analisando os graficos das Previsoes Hybrid

x11()

par(mfrow=c(3, 1))  

plot(soja_prev_h, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev_h, showgap = FALSE, xlab = 'CAFE')

plot(milho_prev_h, showgap = FALSE, xlab = 'MILHO')


## Preparacao das infomacoes para validar qual foi o melhor modelo


soja_teste$Prev_ARIMA <- c(soja_prev[["mean"]][1],soja_prev[["mean"]][2])
soja_teste$Prev_Hybrid <- c(soja_prev_h[["mean"]][1],soja_prev_h[["mean"]][2])

soja_teste$MAPE_ARIMA <- abs(soja_teste$Prev_ARIMA-soja_teste$Toneladas)/soja_teste$Toneladas
soja_teste$MAPE_Hybrid <- abs(soja_teste$Prev_Hybrid-soja_teste$Toneladas)/soja_teste$Toneladas


cafe_teste$Prev_ARIMA <- c(cafe_prev[["mean"]][1],cafe_prev[["mean"]][2])
cafe_teste$Prev_Hybrid <- c(cafe_prev_h[["mean"]][1],cafe_prev_h[["mean"]][2])

cafe_teste$MAPE_ARIMA <- abs(cafe_teste$Prev_ARIMA-cafe_teste$Toneladas)/cafe_teste$Toneladas
cafe_teste$MAPE_Hybrid <- abs(cafe_teste$Prev_Hybrid-cafe_teste$Toneladas)/cafe_teste$Toneladas


milho_teste$Prev_ARIMA <- c(milho_prev[["mean"]][1],milho_prev[["mean"]][2])
milho_teste$Prev_Hybrid <- c(milho_prev_h[["mean"]][1],milho_prev_h[["mean"]][2])

milho_teste$MAPE_ARIMA <- abs(milho_teste$Prev_ARIMA-milho_teste$Toneladas)/milho_teste$Toneladas
milho_teste$MAPE_Hybrid <- abs(milho_teste$Prev_Hybrid-milho_teste$Toneladas)/milho_teste$Toneladas



# AND NOW, THE OSCAR GOES TO...



soja_teste

cafe_teste

milho_teste










#   M O D E L O    H Y B R I D  ! ! ! ! ! ! !


# E qual o melhor commodities para investir neste semestre?

## Graficos das Previsoes ARIMA

x11()

par(mfrow=c(3, 1))  

plot(soja_prev, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev, showgap = FALSE, xlab = 'CAFE')

plot(milho_prev, showgap = FALSE, xlab = 'MILHO')

## Recomenda-se que o investimento seja realizado em SOJA!!

