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
    # Para trabajar con las columnas con funcion SELECT() y derivados
    # Para trabajar con las filas con funcion SUBSET()

cultivo_xlsx_sinNA <- cultivo_xlsx %>% drop_na() # Ahora todas las observaciones tienen info y ningun NA
cultivo_xlsx_sintotal <- cultivo_xlsx[c(-9, -63, -69, -86, -99, -105, -122, -151, -160, -188,
                                        -195, -200, -207, -212, -216, -221, -236, -272, -291, 
                                        -302, -333, -341, -348, -352, -353, -354, -355), ] # Remover a mano por indexacion negativa

cultivo_final <- cultivo_xlsx %>% drop_na(MUNICIPIO) # Al borrar un NA de una variable se borra la fila/observacion completa
cultivo_final <- cultivo_final[c(-329), ] # BASE FINAL :)

  # Codigo para convertir las variables/columnas en tipo character
cultivo_final$`2008` = as.character(cultivo_final$`2008`) # Toca colocar con `` la variable
cultivo_final$`2009` = as.character(cultivo_final$`2009`)
cultivo_final$`2010` = as.character(cultivo_final$`2010`)
cultivo_final$`2011` = as.character(cultivo_final$`2011`)
cultivo_final$`2012` = as.character(cultivo_final$`2012`)
cultivo_final$`2013` = as.character(cultivo_final$`2013`)
cultivo_final$`2014` = as.character(cultivo_final$`2014`)
cultivo_final$`2015` = as.character(cultivo_final$`2015`)
cultivo_final$`2016` = as.character(cultivo_final$`2016`)
cultivo_final$`2017` = as.character(cultivo_final$`2017`)
cultivo_final$`2018` = as.character(cultivo_final$`2018`)
cultivo_final$`2019` = as.character(cultivo_final$`2019`)
glimpse(cultivo_final)

  # Codigo con funcion lapply para convertir (por medio de loops) el variables en chr
    # cultivo_xlsx_sinNA2 = lapply(data_xls,as.character) %>% data.frame()

cultivo_final %>% pivot_longer(!CODDEPTO,!DEPARTAMENTO,!CODMPIO,!MUNICIPIO,names_to="year",values_to="cultivos") 
cultivo_final = cultivo_final %>% pivot_longer(CODDEPTO:MUNICIPIO,names_to="year",values_to="cultivos") 



#------------------------------------------------------------------------------#
#----------------- PUNTO 3 - Base de datos dataframe GEIH ---------------------#
#------------------------------------------------------------------------------#
rm(list = ls())

cat("Instruccion 3.1: Importe las bases de datos Cabecera - Caracteristicas generales (Personas).rds, Cabecera - Ocupados.rds, Cabecera - Desocupados.rds, Cabecera - Inactivos.rds y Cabecera - Fuerza de trabajo.rds de la carpeta data/input/2019. Luego use las variables secuencia_p, orden y directorio para unir en una única base de datos. Mantenga en la base de datos únicamente las variables secuencia_p, orden, directorio, P6020, P6040, P6030S1, P6440, P6450, P6920, INGLABO, DPTO, fex_c_2011, ESC, MES, P6050 y las variables que usted va a generar para saber si una persona es ocupada, desocupada, inactiva y/o fuerza de trabajo.")

setwd("/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019")
list.files() # Listar los archivos que se encuentran en el directorio

data_ccg = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds")
data_cdesoc = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Desocupados.rds")
data_cfuerza = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102task_1/data/input/2019/Cabecera - Fuerza de trabajo.rds")
data_cinact = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Inactivos.rds")
data_cocup = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Ocupados.rds")

str(data_ccg)
colnames(data_ccg) 
  # Variables de interes son: directorio secuencia_p orden
  # Variables a mantener son: directorio secuencia_p orden P6020 P6040 P6030S1 P6440 P6450 P6920 INGLABO DPTO fex_c_2011 ESC MES P6050 y las demas que considere

