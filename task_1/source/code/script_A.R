# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo jajaja)
# Fecha de elaboracion: 15/09/2021
# Ultima modificacion: por definir XX/09/2021

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) # Instalar la librería pacman
p_load(rio,readxl,haven,skimr,WriteXLS,tidyverse) # Llamar y/o instalar las librerías de la clase
installed.packages() # Confirmar las librerias o paquetes instalados en el momento
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
    # Para trabajar con las filas con funcion SUBSET() o tambien con filter()
    # mutate() nos pemrite crear nuevas variables

cultivo_xlsx_sinNA <- cultivo_xlsx %>% drop_na() # Ahora todas las observaciones tienen info y ningun NA
cultivo_xlsx_sintotal <- cultivo_xlsx[c(-9, -63, -69, -86, -99, -105, -122, -151, -160, -188,
                                        -195, -200, -207, -212, -216, -221, -236, -272, -291, 
                                        -302, -333, -341, -348, -352, -353, -354, -355), ] # Remover a mano por indexacion negativa

cultivo_final <- cultivo_xlsx %>% drop_na(MUNICIPIO) # Al borrar un NA de una variable se borra la fila/observacion completa
cultivo_final <- cultivo_final[c(-329), ] # BASE FINAL :)

  # Codigo para convertir las variables/columnas en tipo character
  # Codigo con las variables de tipo char por medio de un loop
    # years = 1999:2007 %>% as.character()
      # for(var in years){
        # data[,var] = as.numeric(data[,var])
      # }

  # Tambien se puede utilizar la funcion de as.numeric o as.character para transformar las columnas

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

rm(cultivo_xlsx, cultivo_xlsx_sinNA, cultivo_xlsx_sintotal)
view(cultivo_final)

cultivo_final %>% pivot_longer(!CODDEPTO:MUNICIPIO, names_to="year", values_to="cultivos") 
cultivo_long = cultivo_final %>% pivot_longer(!CODDEPTO:MUNICIPIO, names_to="year", values_to="cultivos") # base de cultivos final


#------------------------------------------------------------------------------#
#----------------- PUNTO 3 - Base de datos dataframe GEIH ---------------------#
#------------------------------------------------------------------------------#
rm(list = ls())

cat("Instruccion 3.1: Importe las bases de datos Cabecera - Caracteristicas generales (Personas).rds, Cabecera - Ocupados.rds, Cabecera - Desocupados.rds, Cabecera - Inactivos.rds y Cabecera - Fuerza de trabajo.rds de la carpeta data/input/2019. 
    Luego use las variables secuencia_p, orden y directorio para unir en una única base de datos. 
    Mantenga en la base de datos únicamente las variables secuencia_p, orden, directorio, P6020, P6040, P6920, INGLABO, DPTO, fex_c_2011, ESC, MES, P6050 y las variables
    que usted va a generar para saber si una persona es ocupada, desocupada, inactiva y/o fuerza de trabajo.")

cat("Variables a buscar: secuencia_p, orden, directorio, P6020, P6040, P6920, INGLABO, DPTO, fex_c_2011, ESC, MES, P6050 y las demas que considere")

setwd("/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019")
list.files() # Listar los archivos que se encuentran en el directorio

cgen = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Caracteristicas generales (Personas).rds")
desoc = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Desocupados.rds") %>% mutate(desocupado =1)
fuerza = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Fuerza de trabajo.rds") %>% mutate(fuerza =1)
inact = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Inactivos.rds") %>% mutate(inactivo =1)
ocup = import(file = "/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/input/2019/Cabecera - Ocupados.rds") %>% mutate(ocupado =1)

glimpse(cgen)

cgen = cgen %>% select_all(tolower) 
desoc = desoc %>% select_all(tolower) 
fuerza = fuerza %>% select_all(tolower) 
inact = inact %>% select_all(tolower) 
ocup = ocup %>% select_all(tolower) 
  # Variables de interes son: directorio, secuencia_p, orden
  # Variables a mantener son: secuencia_p, orden, directorio, P6020, P6040, P6920, INGLABO, DPTO, fex_c_2011, ESC, MES, P6050 y las demas que considere
  # Esencial empezar con la base de cg
  # CARACTERISTICAS GENERALES: P6020 P6040 ESC MES P6050 DPTO fex_c_2011
  # Ocupados: INGLABO P6920 dpto fex inglabo

  # FORMA ALTERNA CON PIPES 
    # geih = left_join(cgen,desoc,c("secuencia_p","orden","directorio")) %>% left_join(.,fuerza,c("secuencia_p","orden","directorio")) %>%
    #   left_join(.,inact,c("secuencia_p","orden","directorio")) %>% left_join(.,ocup,c("secuencia_p","orden","directorio")) 

base_unica = left_join(x = cgen, y = desoc, by = c("directorio","secuencia_p","orden"), suffix = c("", ""))
base_unica = left_join(x = base_unica, y = fuerza, by = c("directorio","secuencia_p","orden"), suffix = c("", ""))
base_unica = left_join(x = base_unica, y = inact, by = c("directorio","secuencia_p","orden"), suffix = c("", ""))
base_unica = left_join(x = base_unica, y = ocup, by = c("directorio","secuencia_p","orden"), suffix = c("", ""))

colnames(base_unica)

vector_var = c("directorio", "secuencia_p", "orden", "p6020", "p6040", "p6050", "inglabo", "dpto", "fex_c_2011", "esc", "mes", "desocupado", "fuerza", "inactivo", "ocupado")

base_unica = base_unica %>% select(vector_var) #quedarme con las variables de interes


#-------- PUNTO 3.2 - Estad. descriptivas GEIH -----------#
cat("Use las funciones ggplot(), group_by() y summarize() entre otras, para generar algunas estadísticas descriptivas (gráficos y tablas) numero de ocupados, desocupados y los ingresos laborales promedio. 
    Tenga en cuenta algunas dimensiones como departamento, sexo y edad. 
    Las tablas las puede plotear sobre la consola, pero los gráficos los debe exportar en formato .jpeg a la carpeta views. Debe generar al menos 5 gráficos y 5 tablas.")

skim(base_unica)
getwd()
setwd("/Users/ricardoandressilvatorres/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_1/data/output")

save(base_unica, file = "base_final.Rdata") # guardar la base de datos en output
import(file = "base_final.Rdata")

# 5 tablas minimo y 5 graficos minimo
base_unica %>% summarise(total = table(p6020)) # tabla de total hombres y mujeres
base_unica %>% group_by(p6020, dpto) %>% summarise(media = mean(p6040), na.rm = TRUE) # tabla de edad promedio segun sexo y dpto
base_unica %>% group_by(p6020, dpto) %>% summarise(media = mean(esc), na.rm = TRUE) # tabla de escolaridad promedio segun sexo y dpto
base_unica %>% group_by(p6020) %>% summarise(ingresos_promedio = mean(p6500, na.rm = TRUE)) # ingresos promedios de los hombres y mujeres
base_unica %>% group_by(p6020, dpto) %>% summarise(total = table(ocupado), na.rm = FALSE) # tabla de ocupacion segun sexo y dpto
base_unica %>% group_by(p6020, dpto) %>% summarise(total = table(fuerza), na.rm = FALSE) # tabla de fuerza de trabajo segun sexo y dpto
base_unica %>% group_by(p6020) %>% summarise(total = table(inactivo), na.rm = FALSE) # tabla de inactivos segun sexo
base_unica %>% group_by(p6020) %>% summarise(total = table(desocupado), na.rm = FALSE) # tabla de desocupados segun sexo
base_unica %>% group_by(p6020) %>% summarise(media = mean(p6040)) # tabla de edad promedio segun sexo


base_male = base_unica %>% filter(p6020 == 1) # base de solo hombres
base_female = base_unica %>% filter(p6020 == 2) # base de solo mujeres

graph1 = ggplot(data = base_unica) + geom_point(aes(x = esc, y = p6040)) + 
              labs(title = "Edad y años de educacion",
                                    x = "Escolaridad",
                                    y = "Edad") +
             theme_fivethirtyeight()
graph1
