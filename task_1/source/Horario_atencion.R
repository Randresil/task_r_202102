
#
rm(list=ls())
require(pacman)
p_load(tidyverse,rio,skimr)

#=========#
# Punto 1 #
#=========#

1:100
n_1_100 = seq(1,100,1)
impares = seq(1,99,2)
pares = 
  
a = 10:15
a
a[1]
a[4]
a[2]
a[-4]

1:5 %in% 3:6 

!1:5 %in% 3:6

!n_1_100  %in% impares
n_1_100[!n_1_100  %in% impares]

a[c(T,F,F,F,F,T)]


pares = n_1_100[!n_1_100  %in% impares]


#=========#
# Punto 2 #
#=========#

# importar datos
data = import("task_1/data/input/cultivos.xlsx")

# renombrar datos
colnames(data) = data[4,] %>% tolower()

# covertir codmpio en numerica
data$codmpio = as.numeric(data$codmpio)

# eliminar NA
data = data %>% drop_na(codmpio)

# convertir variables en numericas
years = 1999:2007 %>% as.character()
for(var in years){
    data[,var] = as.numeric(data[,var])
}

# pivotear los datos
pivot = data %>% pivot_longer(!coddepto:municipio,names_to="year",values_to="ha_cultivos")

#=========#
# Punto 3 #
#=========#

# punto 3
cabe_cg = readRDS("task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds")

cabe_ocu = readRDS("task_1/data/input/2019/Cabecera - Ocupados.rds") %>% mutate(ocupado=1)

cabe_des = readRDS("task_1/data/input/2019/Cabecera - Desocupados.rds") %>% mutate(desocupado=1)

# unir datos
geih = left_join(cabe_cg,cabe_ocu,c("secuencia_p","orden","directorio")) %>%
        left_join(.,cabe_des,c("secuencia_p","orden","directorio")) 

skim(geih)




