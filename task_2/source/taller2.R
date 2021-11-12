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
list.files(".")
list.files("data/") #Usar el TAB para observar los archivos en el directorio
list.files("data/imput/2017", full.names = TRUE)

a2017 <- list.files("data/imput/2017", full.names = TRUE) # Objeto que guarda nombres en char
class(a2017)
a2017

files = lapply(2017:2020, function(x) list.files(paste0("data/imput/",x),full.names=T)) # objeto lista por lapply
files[[1]]

files = lapply(2017:2020, function(x) list.files(paste0("data/imput/",x),full.names=T)) %>% unlist()



# Punto 2 -----------------------------------------------------------------
cat("Crear función: Cree una función que extraiga de un dataframe dentro de chip, el 
    valor PAGOS(Pesos) para la categoría EDUCACION. Asegúrese de extraer el código DANE 
    del municipio y el periodo de la información.")

?subset
?select


