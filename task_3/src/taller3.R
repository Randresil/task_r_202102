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
p_load(tidyverse,viridis,sf,maps,leaflet,osmdata,ggsn,skimr,ggmap,tidycensus) 
installed.packages() # Confirmar las librerias o paquetes instalados en el momento
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8


# Punto 1 - Datos Espaciales (50%) -------------------------------------------------
print("1.1. Importar datos espaciales")
cat("1.1.1 De la carpeta data/outpu importe los shapefiles de VIAS (llame al objeto via) 
    y MGN_URB_TOPONIMIA (llame al objeto puntos). El primero contiene las vías 
    del departamento de Norte de Santander y el segundo la ubicación de algunos 
    servicios públicos (hospitales, policía,. . . ) y 
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
puntos$CSIMBOL
c_medico <- filter(puntos, CSIMBOL == "021001" | CSIMBOL == "021002" | CSIMBOL == "021003")
c_medico


