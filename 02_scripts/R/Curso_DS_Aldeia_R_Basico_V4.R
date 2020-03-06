# Primeiramente, explicarei como funciona o R + RStudio

## Como executar os comandos no R por aqui???

# E para ter sorte com a linguagem:

print('Hello World')

# Comando para configurar a pasta onde o R puxara e copiara as informacoes

setwd('/home/ds/Documents/')


# Baixando e Instalando Pacotes

install.packages('SamplerCompare')



# Chamando os Pacotes

Require(dplyr)

library(CorrMixed)

# **** IMPORTANTE - Sempre e necessario iniciar o pacote para pode-lo utilizar!



#Parte 1

# Tipos do Dados

## Caracter

# Para criar uma variavel e sempre necessario utilizar o '<-', facilmente criado com o atalho Alt + -  

caracter <-  ("Exemplo Caracter")

class(caracter)

# ou

is.character(caracter)

caracter

## Numerico

numerico <- 13

class(numerico)

# ou

is.numeric(numerico)

## Data

data <- as.Date('2019-07-28')

class(data)

# Criando um objeto Caracter Simples

turma_ds <- ("Rumo ao Futuro")

# Mostrar na tela o conteudo do objeto

print(turma_ds)


## Quero outras duas formas de mostrar "Hello word" sem a função print!



# Criando objetos numericos

dois <- 2

dez <- 10

vinte <- 20

class(dois)

## Agora criem uma variavel com nome louco, com cartacteres, numeros, acentos, etc:



## Quem nao conseguiu? Por que?


# Funcoes matematicas:

## Soma

10 + 20


## Menos
10 - 20

## Divisao ?? Como Faz?


## Exponencial ??



## Raiz Quadrada  

sqrt(vinte*dez)


## Logaritmo

log(20)

## Media

(dois+dez+vinte)/3

# ou

media <- mean(c(2,10,20))

media

# Criando um vetor

x <- c(1,2,3,4,5,6)   

print(x)

# Elevando cada valor ao quadrado

y <- c(1^2,2^2,3^2,4^2,5^2,6^2)

y

# E o jeito mais facil? Qual?












# Esse!!!!

y <- x^2 

y   

# Somando todos os valores de cada vetor

sum(x)

sum(y)

# Criando um objeto com os valores somados

soma_x_y <- c(sum(x),sum(y))

print(soma_x_y)

# Calculando a media do Vetor

mean(y)               

# A variancia

var(y)                

var(x)

# O desvio padrao, maos a obra! Vcs tem 2 minutos!















sqrt(var(y))

# ou

sd(y)

# Produto entre vetores

x*y

length(x)

length(y)



# Criando matrizes com vetores

## Vetores como colunas

z <- cbind(x,y)

z


## Qual é a classe do objeto 'z'?













## Vetores como linhas

w <- rbind(x,y)

w

class(w)

## Operacoes com Matrizes

z + 1

z * 10

z / 10

## Operacoes entre Matrizes

z2 <- cbind(x*2,y*2)

z2

z + z2

z - z2

z * z2


# Criando Data Frames

a <- c(1,3,5,7,9,11)

b <- c(2,4,8,16,32,64)

d_f_1 <- data.frame(impares=a,potencia_2=b, row.names = NULL)

View(d_f_1)

d_f_2 <- ## Utilizar as variaveil 'x' e 'y' !!!!

View(d_f_2)

d_f_1 * d_f_2


# Criando Listas

lista <- list(z,d_f_1,"Locura")

lista

z[1,1]

lista[[1]][1,1]

# Criando Graficos

riqueza <- c(15,18,22,24,25,30,31,34,37,39,41,43)

area <- c(2,4.5,6,10,30,34,50,56,60,77.5,80,85)

area.cate <- rep(c("pequeno", "grande"), each=6)

plot(riqueza~area)

plot(area,riqueza) # o mesmo que o anterior

# Editando os graficos

## Aumentando as margens

par(cex=1.2)

## Representacao grafica do diagrama dos cinco numeros

boxplot(riqueza~area.cate)

boxplot(riqueza~area.cate, horizontal = TRUE, col = c("grey","gold"))

## Diagrama de Barras

barplot(riqueza)

## Histograma

hist(riqueza)

## Inserindo Cores

hist(rnorm(20000),col=c("blue","red","orange","green","pink"))

## Aumentando as marcacoes

plot(riqueza~area, cex=1)

plot(riqueza~area, cex=1.5)

plot(riqueza~area, cex=2)

plot(riqueza~area, cex=2.5)

plot(riqueza~area, cex=3)

## Inserindo dois graficos no mesmo objeto

par(mfrow=c(2,1), cex=0.6)

plot(riqueza~area)

boxplot(riqueza~area.cate, horizontal = TRUE, col = c("grey","gold"))

## Inserindo uma reta no grafico

par(mfrow=c(1,1))

plot(riqueza~area)

abline(15,0.35)

## Inserindo quadrantes conforme a media 

plot(riqueza~area)

abline(v=mean(area))

abline(h=mean(riqueza))


## Inserindo texto

plot(riqueza~area)
text(79,43,"Ponto Mais Distante >>")

## Agora crie os seu proprio grafico, em 10 minutos, valendo um **Kinder B u e n o** ao mais criativo
## (Na real, qual eu gostar mais...)! 




## Como consultar os detalhes das funcoes e pacotes

??lapply

??`dplyr-package`


## Abrindo numa nova janela

x11()

plot(riqueza~area)
text(79,43,"Ponto Mais Distante >>")

## Salvando o grafico em arquivo

jpeg(filename = "Grafico_R.jpg", width = 1080, height = 1080, 
     units = "px", pointsize = 12, quality = 100,
     bg = "white",  res = NA, restoreConsole = TRUE)

par(mfrow=c(1,2), cex=2)
par(mar=c(14,4,8,2), cex=2)
plot(riqueza~area)
boxplot(riqueza~area.cate)

dev.off()




# ETL Basico em R

## criando tabela com os valores abaixo:

vendas <- data.frame(vendedor=c(13,26,39,39,07,14,13,07,21),vendas=c(300,500,110,150,280,580,90,20,800))

vendas

metas <- data.frame(vendedor=c(07,13,14,21,26,39),meta=c(2000,800,1250,1050,1400,1550))

metas


# Juncoes

## Juntar informacoes numa única tabela

valida_metas <- merge(vendas,metas,"vendedor")

valida_metas

valida_metas_2 <- ???(vendas,metas,"vendedor") ### Tem outra maneira

valida_metas_2

# Agrupamentos
## Somando as vendas


result_mes <- data.frame((valida_metas %>%
                            group_by(vendedor) %>%
                            dplyr::summarise(meta=max(meta, na.rm = TRUE),
                                             vendas= sum(vendas, na.rm = TRUE)
                            )),
                         row.names = NULL)

View(result_mes)


# Transformacoes
## A meta esta em reais e as vendas em dolares

result_mes$vendas <- result_mes$vendas*3.9

result_mes

# Criacao de Variaveis
## Criar campo para que seja validado quem atingiu a meta

result_mes$ating_meta <- ifelse(result_mes$vendas>=result_mes$meta,"SIM","NaO")

result_mes

#-----------------------------------------------------------#

# Calculos mais complexos

## Correlacao entre duas variaveis

cor.test(riqueza,area)

# Ajustando um modelo de regrecao linear >> "y = f(x)" ou "y = B0 + (B1 * x)"

## E guardando as informacoes na variavel lm_1

lm_1<-lm(riqueza ~ area)    

## Mostrando o modelo construido

print(lm_1)           

## Verificando detalhes do modelo

summary(lm_1)          

## Dimensionando uma janela 2 por 2 (4 graficos)

par(mfrow=c(2, 2))    

## Explicacao Grafica do Modelo

plot(lm_1)   

#-----------------------------------------------------------#

# Verificando o poder grafico do R

library(caTools)        # external package providing write.gif function 
jet.colors<-colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
m<-1200                # define size
C<-complex( real=rep(seq(-1.8,0.6, length.out=m), each=m ),
            imag=rep(seq(-1.2,1.2, length.out=m), m ) )
C<-matrix(C,m,m)       # reshape as square matrix of complex numbers
Z<-0                   # initialize Z to zero
X<-array(0, c(m,m,50)) # initialize output 3D array 
for (k in 1:50) {       # loop with 50 iterations
  Z<-Z^2+C             # the central difference equation
  X[,,k]<-exp(-abs(Z)) # capture results
}
write.gif(X, "Data_Science_Aldeia.gif", col=jet.colors, delay=100)
