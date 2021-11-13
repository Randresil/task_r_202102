# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo jajaja)
# Fecha de elaboracion: 07/11/2021
# Ultima modificacion: 13/11/2021
# Version de R: 4.1.2
# Version de MacOS: 12.0.1 Monterrey
# Taller 2 (A) de Taller de R: Estadística y Programación 
# Aunque creo que termine haciendo el B por la categoria del punto 2 jaja


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

print("1. Loops")
cat("1.0.Crear lista: Cree un objeto tipo lista vacío, llámelo chip.")
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
  
files = lapply(2017:2020, 
               function(x) 
                 list.files(paste0("data/imput/",x),full.names=T)) %>% unlist()
class(files) # Char

# Loop de importacion en la lista chip
for (i in 1:length(files)){
  chip[[i]] = import(file = files[i]) 
}



# Punto 2 -----------------------------------------------------------------
print("2. Funciones")
cat("Crear función: Cree una función que extraiga de un dataframe dentro de chip, el 
    valor PAGOS(Pesos) para la categoría EDUCACION. Asegúrese de extraer el código DANE 
    del municipio y el periodo de la información.")

?as.data.frame
?data.frame
?subset
?select

df1 = as.data.frame(chip[[1]])
View(df1)
# Podemos observar que el codigo Dane esta en nombre columna 1
# Periodo de informacion esta en observacion 2 columna 1.
# Valor PAGOS(Pesos) esta en fila 7 columna 8
# Valor de Categoria EDUCACION esta en la observacion 8 columna 2
rm(df1)


# Creacion de la funcion para extrae datos
extractdata = function(i, list, criterio){
  # Primero, crear un dataframe con funcion tibble() o data.frame(), problemas por data_frame() deprecated. 
  df = data.frame(Codigo = NA, Periodo = NA, Valor = NA)
  list_i = list[[i]]
  
  # Extraccion de Codigo DANE
  df$Codigo =  colnames(list_i[1]) # Value
  
  # Extraccion de Periodo 
  df$Periodo = list_i[2,1] # Value
  
  # Nombres a columnas de la lista
  colnames(list_i) = list_i[7,]
  # Valor segun el criterio
  df$Valor =  list_i %>% subset(NOMBRE == criterio) %>% select(`PAGOS(Pesos)`) # Value
  return(df)
}

# Chequeo de la funcion construida
extractdata(i = 80, list = chip, criterio = "EDUCACIÓN")



# Punto 3 -----------------------------------------------------------------
print("3. Familia Apply")
cat("Aplique la función creada en el punto anterior a todos los elementos de la lista chip.")

# Aplicacion del lapply para tener una lista, desde 1 a 80, con cambios en extract i a partir de function(x)
lapply(1:length(chip),
               function(x) 
                 extractdata(i = x, list = chip, criterio = "EDUCACIÓN"))


# UNOS EXTRA POR JUGAR UN POCO
# Una lista final donde se tengan los resultados del lapply anterior a todos los objetos
lista_educacion = lapply(1:length(chip),
       function(x) 
         extractdata(i = x, list = chip, criterio = "EDUCACIÓN"))

lista_totalinversion = lapply(1:length(chip),
                              function(x) 
                                extractdata(i = x, list = chip, criterio = "TOTAL INVERSIÓN"))

lista_salud = lapply(1:length(chip),
                              function(x) 
                                extractdata(i = x, list = chip, criterio = "SALUD"))