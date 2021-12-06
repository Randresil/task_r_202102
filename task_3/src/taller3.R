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
p_load(rio,tidyverse,viridis,sf,maps,leaflet,osmdata,ggsn, margins,
       skimr,ggmap,tidycensus,utils,ggplot2,broom,modelsummary,GGally, outreg,
       htmltools, stargazer, rvest) 

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

# skim(puntos) # R se demora
head(puntos)
str(puntos)
tab1(puntos$MPIO_CCDGO, cum.percent = TRUE)

# skim(via) # R hace KABOOM
head(via)
str(via)

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
?st_as_sf
?st_transform

class(c_medico)
c_medico %>% st_crs() # Obtener el CRS
c_medico %>% st_bbox() # Obtener el bbox

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

# Tambien se habria podido hacer con una funcion de lapply.
# Muy a lo tipo de hacer un objeto con todos los del task y aplicarles funcion

c_medico <- st_as_sf(x = c_medico, crs = "+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs")
depto <- st_as_sf(x = depto, crs = "+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs")
mapmuse <- st_as_sf(x = mapmuse, crs = "+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs")
puntos <- st_as_sf(x = puntos, crs = "+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs")
via <- st_as_sf(x = via, crs = "+proj=utm +zone=19 +datum=WGS84 +units=m +no_defs")

leaflet() %>% addTiles() %>% addCircleMarkers(data = puntos)

# Punto 1.4
print("1.4. Operaciones Geometricas")

cat("1.4.1 Use el objeto depto para hacer cliping y dejar los puntos de 
    mapmuse que están debajo del polígono de Norte de Santander.")

?st_intersection

class(depto)
depto

# La funcion de intersection permite juntar los objetos espaciales por lo que entiendo
mapmuse_depto_int=st_intersection(mapmuse, depto)

cat("1.4.2 Del objeto c_poblado, seleccione cualquier municipio, use 
    este polígono y el objeto via, para calcular el largo de las vías 
    en el centro poblado que seleccionó.")

?geom_sf

# Seleccion cod_mpio = 54001
cpob =c_poblado%>%subset(codmpio==54001) # Subset, toma observaciones con cod seleccionado
ggplot() + 
    geom_sf(data = cpob , col = "blue") + 
    geom_sf(data = via, col = "red")

# Toma la interseccion entre objetos y saca distancia o largo de vias al centro poblado
st_length(st_intersection(via, cpob)) %>% sum 
# 1172272 [m]


# Punto 1.5
print("1.5. Pintar mapas ")

cat("1.5.1 Use la función leaflet para visualizar en un mismo mapa: los 
    polígonos de los centros poblados, el polígono del departamento de 
    Norte de Santander y los hospitales y puestos de salud del 
    objeto c_medicos.")

?leaflet # The function creates a map widget.
?addTiles # Add graphics elements and layers to the map widget
?addPolygons # Add graphics elements and layers to the map widget.
?addCircleMarkers

# Primero se tiene que utilizar el depto, luego colocar poligonos de c_medicos y c_pob.
mapa_medico = leaflet(depto) %>% addTiles() %>% addPolygons(fillColor="gray",weight=1) %>% 
    addCircleMarkers(data=c_medico, radius = 1, color = "blue")
mapa_medico

# Segundo mapa con el poligono de los centros poblados
mapa_pob = mapa_medico %>% addPolygons(data=c_poblado, color="red")
mapa_pob


cat("1.5.2 Use las librerías ggplot, ggsn y las demás que considere 
    necesarias para visualizar en un mismo mapa: los polígonos de 
    los centros poblados, el polígono del departamento de Norte de 
    Santander y los hospitales y puestos de salud del objeto c_medicos. 
    Asegúrese de poner la barra de escalas, la estrella del norte y las
    etiquetas que permitan diferencias cada uno de los objetos. 
    Exporte el mapa en formato .pdf a la carpeta views.")



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

getwd()
list.files("task_3/data/output/")
df_mapmuse <- import("task_3/data/output/f_mapmuse.rds")
summary(df_mapmuse)

# Modelo de probabilidad lineal (tomando TODAS las variables)
?lm
ols <- lm(formula = fallecido ~ dist_hospi + dist_cpoblado + 
              dist_vias + as.factor(genero) + year + month + as.factor(actividad) + 
              condicion + tipo_accidente + as.factor(cod_mpio)
          , data = df_mapmuse)

# Otro OLS prob pero sin muchas variables
ols2 <- lm(formula = fallecido ~ dist_hospi + dist_cpoblado + 
               dist_vias + as.factor(genero) + as.factor(actividad) + 
               condicion, data = df_mapmuse) 

ols %>% summary() 
ols2 %>% summary() 
ols$coefficients # Obtener los coefficients

# Punto 2.2
cat("Exporte a la carpeta views los gráficos con los coeficientes 
    (coef-plot) de las estimaciones.")

coef1 <- tidy(ols, conf.int = TRUE)
coef1

# Para poder exportar en codigo un archivo
browseURL(url = "https://r-coder.com/save-plot-r/#Export_plot_with_the_menu_in_RStudio_and_R_GUI")

?png
setwd("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_3/Views")
png(filename = "coefplot1.png", width = 560, height = 480)
modelplot(ols)
# ggcoef(ols) # Otra forma (funcion) para sacar grafico. Paquete GGally.
dev.off()
setwd("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_3")

# Punto 2.3
cat("Ahora estime la ecuación del punto 2.1. usando un modelo logit 
    y un modelo probit, almacene los resultados de las estimaciones 
    en dos objetos llamados logit y probit respectivamente.")

logit <- glm(formula = fallecido ~ dist_hospi + dist_cpoblado + 
                 dist_vias + as.factor(genero) + year + month + as.factor(actividad) + 
                 condicion + tipo_accidente + as.factor(cod_mpio), 
             data = df_mapmuse, family = binomial(link = "logit")) 

probit <- glm(formula = fallecido ~ dist_hospi + dist_cpoblado + 
                  dist_vias + as.factor(genero) + year + month + as.factor(actividad) + 
                  condicion + tipo_accidente + as.factor(cod_mpio), 
              data = df_mapmuse, family = binomial(link = "probit")) 

# Punto 2.4
cat("Exporte los resultados de los tres modelos en una misma tabla 
    usando la función outreg.")

?outreg
?colnames
getwd()
setwd("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_3/data/output")

model_table <- outreg(list(ols, logit, probit))
model_table
colnames(model_table) <- c("Variable", "Stat", "OLS", "Logit", "Probit")

# Exportado a la carpeta de output por si algo en modo texto
write.table(x = model_table, file = "tabla_modelos.txt", sep = ",")

# Punto 2.5
cat("De los objetos logit y probit exporte a la carpeta views dos gráficos con 
    el efecto marginal de la distancia a un centro medico sobre la probabilidad 
    de fallecer.")

?modelplot

setwd("~/OneDrive - Universidad de los Andes/TallerR - 2021-2/task_r_202102/task_3/Views")

logit_margins = margins(logit)
logit_margins
probit_margins = margins(probit)
probit_margins

graph_logit = modelplot(logit_margins, coef_map = "dist_hospi") + labs(title = "Efecto marginal logit en probabilidad")
graph_logit
ggsave("graph_coeflogit.jpeg", graph_logit)

graph_probit = modelplot(probit_margins, coef_map = "dist_hospi") + labs(title = "Efecto marginal probit en probabilidad")
graph_probit
ggsave("graph_coefprobit.jpeg", graph_probit)


# Punto 3 - Web Scraping (10%) --------------------------------------------

# Punto 3.1
cat("Desde la consola de Rstudio lea la siguiente url 
    https://es.wikipedia.org/wiki/Departamentos_de_Colombia y cree un objeto 
    que contenga el HTML de la página como un objeto xml_document.")

# Abrir en la web la pagina de los departamentos de Colombia
browseURL(url = "https://es.wikipedia.org/wiki/Departamentos_de_Colombia")

pag_html <- "https://es.wikipedia.org/wiki/Departamentos_de_Colombia"
pag_html <- read_html(pag_html)

# Verificar el tipo de clase que es el objeto creado
class(pag_html) # xml_document

# Punto 3.2
cat("Use el xpath para extraer el título de la página (Departamentos 
    de Colombia).")

# Para obtener el xpath de la pagina, inspeccionar elemento y copiar
# //*[@id="firstHeading"]

?html_nodes
?html_text # Funcion que ayuda a obtener el texto de un elemento

titulo_pag <- html_nodes(pag_html, xpath = '//*[@id="firstHeading"]') %>% html_text() 
titulo_pag

# Punto 3.3
cat("Extraiga la tabla que contiene los departamentos de Colombia.")

# Xpath de la tabla de los departamentos
# //*[@id="mw-content-text"]/div[1]/table[3]
?html_table

# Extraccion de la tabla en objeto de tipo lista
tabla_depa <- html_nodes(pag_html, xpath = '//*[@id="mw-content-text"]/div[1]/table[3]') %>% html_table()
tabla_depa 
