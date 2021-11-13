# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo jajaja)
# Fecha de elaboracion: 07/11/2021
# Ultima modificacion: por definir XX/09/2021
# Version de R: 4.1.2
# Taller 2 (A) de Taller de R: Estadística y Programación


# Configuracion inicial ---------------------------------------------------
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) # Instalar la librería pacman
p_load(rio,readxl,haven,skimr,tidyverse) # Llamar y/o instalar las librerías de la clase
installed.packages() # Confirmar las librerias o paquetes instalados en el momento
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8


# Punto 1 -----------------------------------------------------------------
basic_dir <- "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/"
setwd(paste0(basic_dir,"task_2")) # Tener objetos y direcciones a lo STATA
getwd()

cat("1.0. Crear lista: Cree un objeto tipo lista vacío, llámelo chip.")
chip = list()

cat("1.1. Importar datos: Use un loop para importar cada archivo .xlsx de data/imput en 
    un elemento/posición diferente de chip. Esta lista debería 80 elementos (dataframes de 
    la base de datos CHIP -Consolidador de Haciendas e información Pública- para los años 2017, 
    2018, 2019 y 2020).")

# Documentacion de list.files() para determinar opciones y sacar directorios de archivos
?list.files
?unlist
list.files(".")
list.files("data/") #Usar el TAB para observar los archivos en el directorio
list.files("data/imput/2017", full.names = TRUE)

a2017 <- list.files("data/imput/2017", full.names = TRUE) # Objeto que guarda nombres en char
rm(a2017)

files = lapply(2017:2020, 
               function(x) 
                 list.files(paste0("data/imput/",x),full.names=T)) # objeto lista por lapply
class(files) # List, necesidad de usar funcion unlist para tener objeto tipo char

for (i in 1:4){
  print(files[[i]]) # Loop para observar las direcciones de todos los archivos a importar
}
  
files = lapply(2017:2020, function(x) list.files(paste0("data/imput/",x),full.names=T)) %>% unlist()
class(files) # Char

# Loop de importacion en la lista chip
for (i in 1:length(files)){
  chip[[i]] = import(file = files[i]) 
}


# Punto 2 -----------------------------------------------------------------
cat("Crear función: Cree una función que extraiga de un dataframe dentro de chip, el 
    valor PAGOS(Pesos) para la categoría EDUCACION. Asegúrese de extraer el código DANE 
    del municipio y el periodo de la información.")

?as.data.frame
?subset
?select

df1 = as.data.frame(chip[[1]])
View(df1)
# Podemos observar que el codigo Dane esta en nombre columna 1
# Periodo de informacion esta en observacion 2 columna 1.
# Valor PAGOS(Pesos) esta en fila 7 columna 8
# Valor de Categoria EDUCACION esta en la observacion 8 columna 2

# Creacion de la funcion para extrae datos
extractdata = function(i, list, criterio){
  list_i = lista[[i]]
  
  
  
}

f_extrac = function(n,lista,tipo_rubro){
  lista_n = lista[[n]] 
  colnames(lista_n) = lista_n[7,]
  valor = lista_n %>% subset(NOMBRE==tipo_rubro) %>% select(`PAGOS(Pesos)`)
  return(valor)  
}
f_extrac(n = 10 , lista = chip , tipo_rubro = "EDUCACION")


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

f_extrac(n = 10 , lista = chip , tipo_rubro = "EDUCACION")





# Punto 3 -----------------------------------------------------------------

# final = lapply(2017:2020, extractdata() 


