# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo jajaja)
# Fecha de elaboracion: 15/09/2021
# Ultima modificacion: por definir /09/2021

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) # Instalar la librería pacman
p_load(rio,readxl,haven,skimr,WriteXLS,tidyverse) # Llamar y/o instalar las librerías de la clase
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

#######################################
#             TALLER A                #
#######################################


#------------------------------------------------------------------------------#
#---------------------------- PUNTO 1 - VECTORES ------------------------------#
#------------------------------------------------------------------------------#

cat("Cree un vector que contenga los números del 1 al 100, posteriormente cree otro vector que contenga los números impares de 1 a 99. Use el vector de números impares para crear un vector con los números pares de del primer vector.")

vector_1 = c(1:100)
  # Funcion de seq (secuencia) es la que permite crear con criterios
  # Tambien otra opcion podria ser un vector_impar2 = c(1:50)*2-1
  # rm(vector_impar2)
vector_impar = seq(1,99, by = 2)
vector_par = vector_impar + 1


#------------------------------------------------------------------------------#
#------------------- PUNTO 2 - Limpiar una base de datos ----------------------#
#------------------------------------------------------------------------------#
rm(list = ls())

cat("Importe la base de datos cultivos que se encuentra en la carpeta data/input, limpie la base de datos eliminando las observaciones que no tienen información relevante. Luego pivotee la base de datos para que quede en formato long.")

installed.packages()
?rio::import

  # Opcion de importar con el paquete rio
cultivo_xlsx = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/cultivos.xlsx", skip = 8 , col_names = TRUE) # Me salto primeras 8 filas y nombres de columnas permanecen

  # Opcion de importar excel predeterminada
# cultivos <- read_excel("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/cultivos.xlsx", sheet = "CultivosIlicitos", skip = 8)

class(cultivo_xlsx) # es un dataframe
View(cultivo_xlsx)

  # Curioseando con las funciones
nrow(cultivo_xlsx) # 355 observaciones
ncol(cultivo_xlsx) # 25 variables
dim(cultivo_xlsx) # Bota las filas y columnas de una
head(cultivo_xlsx) # Perspectiva de primeras observaciones de variables
skim(cultivo_xlsx) # Un tipo de summarize del dataframe
str(cultivo_xlsx) # Clase de objeto, filas y columnas, carac de variables
glimpse(cultivo_xlsx) # Tipo de variables y filas y columnas
object.size(cultivo_xlsx) # Peso del archivo en bytes

  # Para la lIMPIEZA del DATAFRAME
    # Pata trabajar con las columnas con funcion SELECT() y derivados
    # Para trabajar con las filas con funcion SUBSET()

cultivo_xlsx_sinNA <- cultivo_xlsx %>% drop_na() # Ahora todas las observaciones tienen info y ningun NA
cultivo_xlsx_sintotal <- cultivo_xlsx[c(-9, -63, -69, -86, -99, -105, -122, -151, -160, -188,
                                        -195, -200, -207, -212, -216, -221, -236, -272, -291, 
                                        -302, -333, -341, -348, -352, -353, -354, -355), ] # Remover a mano por indexacion negativa








