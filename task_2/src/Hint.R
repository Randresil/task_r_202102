
# librerias
rm(list=ls())
require(pacman)
p_load(rio,tidyverse)

# punto 1
paths = lapply(2017:2020 , function(x) list.files(paste0("task_2/data/imput/",x),full.names=T)) %>%
        unlist()

list_chip = list()
for (i in 1:length(paths)){
     list_chip[[i]] = import(file = paths[i])  
}


  
# punto 2
f_extrac = function(n,lista,tipo_rubro){
  lista_n = lista[[n]] 
  colnames(lista_n) = lista_n[7,]
valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
return(valor)  
}
f_extrac(n = 10 , lista = list_chip , tipo_rubro = "SALUD")


# Completando la funcion
f_extrac = function(n,lista,tipo_rubro){
  
  # crear df
  df = data.frame(valor=NA,cod_dane=NA,periodo=NA)  
  lista_n = lista[[n]] 
  
  # extraer codigo dane
  df$cod_dane = colnames(lista_n)[1]
  
  # extraer periodo
  df$periodo = lista_n[2,1]
  
  # extraer el valor
  colnames(lista_n) = lista_n[7,]
  df$valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)

return(df)  
}
f_extrac(n = 10 , lista = list_chip , tipo_rubro = "SALUD")







