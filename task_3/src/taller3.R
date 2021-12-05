# Elaborado por: Ricardo Andres Silva Torres
# Codigo de estudiante: 201821978
# Colaboradores: Ninguno (solo yo jajaja)
# Fecha de elaboracion: 01/12/2021
# Ultima modificacion: XX/12/2021
# Version de R: 4.1.2
# Version de MacOS: 12.0.1 Monterrey
# Taller 3 (A) de Taller de R: Estadística y Programación 

# Configuracion inicial ---------------------------------------------------
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) 
p_load(rio,tidyverse,viridis,sf,maps,leaflet,osmdata,ggsn,skimr,ggmap,tidycensus,utils) 
installed.packages() # Confirmar las librerias o paquetes instalados en el momento
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8


# Punto 1 - Datos Espaciales (50%) -------------------------------------------------
print("1.1. Importar datos espaciales")
cat("1.1.1 De la carpeta data/outpu importe los shapefiles de VIAS (llame al 
    objeto via) y MGN_URB_TOPONIMIA (llame al objeto puntos). El primero
    contiene las vías del departamento de Norte de Santander y el segundo 
    la ubicación de algunos servicios públicos (hospitales, policía,. . . ) y 
    comerciales (restaurantes, tiendas,. . . ).)")

cat("1.1.2 Cree un nuevo objeto llamado c_medico, que contenga las observaciones del 
    objeto puntos en las que la variable CSIMBOL sea igual 
    a “021001”,“021002” o “021003”.")

cat("1.1.3 De la carpeta data/outpu importe los c poblado (2017).rds 
    (llame al objeto c_poblado), dp deptos (2017).rds (llame al objeto depto) 
    y \textit{victimas_map-muse.rds} (llame al objeto mapmuse). 
    Asegúrese de dejar únicamente los centro poblados con 
    código DANE >= 54001 & < 55000. Además, del objeto depto,
    deje únicamente el polígono del departamento de Norte de Santander.")

getwd()
list.files()
setwd("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102")

# Punto 1.1.1
# Leer shapefiles a partir de busqueda en carpeta input
list.files("task_3/data/input/")
via <- st_read("task_3/data/input/VIAS.shp")
class(via)

puntos <- st_read("task_3/data/input/MGN_URB_TOPONIMIA.shp")
class(puntos)
str(puntos)

# Punto 1.1.2
# Filtrar las bases de datos
puntos$CSIMBOL
c_medico <- filter(puntos, CSIMBOL == "021001" | CSIMBOL == "021002" | 
                       CSIMBOL == "021003")
c_medico

# Punto 1.1.3
# Importar y filtrar las bases de datos .rds
list.files("task_3/data/input/")
c_poblado <- import("task_3/data/input/c poblado (2017).rds")
depto <- import("task_3/data/input/dp deptos (2017).rds")
mapmuse <- import("task_3/data/input/victimas_map-muse.rds")

head(c_poblado)
c_poblado <- filter(c_poblado, cod_dane >= 54001 & cod_dane < 55000)
depto$name_dpto
depto <- filter(depto, name_dpto == "NORTE DE SANTANDER")
depto


# Punto 1.2
print("1.2. Atributos de los objetos")
cat("Aplique la función skim de la librería skimr para explorar todos los objetos 
    cargados en el punto anterior. Si considera necesario, selecciones algunas 
    variables y pinte sobre la consola la tabla de frecuencia estas.")

# Por busqueda encontre una pagina para hacer tablas de frecuencias y un paquete de R
browseURL("https://www.programmingr.com/statistics/frequency-table/")
install.packages('epiDisplay')
library(epiDisplay)
?tab1

ls() # List objects in the global environment
skim(ls())
skim(c_medico) # Funciona
    tab1(c_medico$DPTO_CCDGO, cum.percent = TRUE)
    tab1(c_medico$MPIO_CCDGO, cum.percent = TRUE)
skim(c_poblado) # Funciona
    tab1(c_poblado$cod_dane, cum.percent = TRUE)
skim(depto) # Funciona

skim(mapmuse) # R se demora un poquito
    tab1(mapmuse$tipo_accidente, cum.percent = TRUE)
    tab1(mapmuse$year, cum.percent = TRUE)
    tab1(mapmuse$month, cum.percent = TRUE)
    tab1(mapmuse$condicion, cum.percent = TRUE)
    tab1(mapmuse$genero, cum.percent = TRUE)
    tab1(mapmuse$estado, cum.percent = TRUE)
    tab1(mapmuse$actividad, cum.percent = TRUE)
    tab1(mapmuse$cod_mpio, cum.percent = TRUE)
skim(puntos) # R se demora tambien
    tab1(puntos$MPIO_CCDGO, cum.percent = TRUE)
skim(via) # R hace KABOOM

dev.off()

# Punto 1.3
print("1.3. Geometrías del objeto")

cat("1.3.1 Para todos los objetos del punto 1.1., pinte sobre la consola 
la caja de coordenadas (st_bbox) y el CRS de cada objeto.")

cat("1.3.2 Ahora va a re proyectar el CRS de todos los objetos. Asigne la 
siguiente CRS +proj=utm +zone=19+datum=WGS84 +units=m +no_defs a todos 
los objetos del punto 1.1..")

# Punto 1.3.1
?st_crs
?st_bbox
c_medico %>% st_crs() # get CRS
c_medico %>% st_bbox() # get bbox

c_poblado %>% st_crs()
c_poblado %>% st_bbox() 

depto %>% st_crs() 
depto %>% st_bbox() 

mapmuse %>% st_crs() 
mapmuse %>% st_bbox() 

puntos %>% st_crs() 
puntos %>% st_bbox() 

via %>% st_crs() 
via %>% st_bbox() 



# Punto 1.4
print("1.4. Operaciones Geometricas")


# Punto 1.5
print("1.5. Pintar mapas ")



# Punto 2 - Regresiones (30%) ----------------------------------------------

print("La Oficina del Alto Comisionado para la Paz (OACP) tiene el registro 
oficial de víctimas por minas antipersona (MAP) y municiones sin 
explosionar (MUSE). Estos registros pueden obtenerse en la página 
oficial de la OACP. Para este ejercicio usted cuenta con una base 
de datos que contiene los registros de las victimas de MAP-MUSE en 
el departamento de Norte de Santander. La variable fallecido toma el 
valor de 1 si la persona fallece en el accidente y 0 si resulta herida.")

# Punto 2.1
cat("Importe el archivo data/outpu/df_mapmuse.rds y estime un modelo de probabilidad 
    lineal en el que fallecido es la variable dependiente. Y use las demás variables 
    como variables explicativas. Almacene los resultados de la estimación en un 
    objeto llamado ols.")

# Punto 2.2
cat("Exporte a la carpeta views los gráficos con los coeficientes 
    (coef-plot) de las estimaciones.")

# Punto 2.3
cat("Ahora estime la ecuación del punto 2.1. usando un modelo logit 
    y un modelo probit, almacene los resultados de las estimaciones 
    en dos objetos llamados logit y probit respectivamente.")

# Punto 2.4
cat("Exporte los resultados de los tres modelos en una misma tabla 
    usando la función outreg.")

# Punto 2.5
cat("De los objetos logit y probit exporte a la carpeta views dos gráficos con 
    el efecto marginal de la distancia a un centro medico sobre la probabilidad 
    de fallecer.")




# Punto 3 - Web Scraping (10%) --------------------------------------------

# Punto 3.1
cat("Desde la consola de Rstudio lea la siguiente url 
    https://es.wikipedia.org/wiki/Departamentos_de_Colombia y cree un objeto 
    que contenga el HTML de la página como un objeto xml_document.")

# Punto 3.2
cat("Use el xpath para extraer el título de la página (Departamentos 
    de Colombia).")


# Punto 3.3
cat("Extraiga la tabla que contiene los departamentos de Colombia.")
