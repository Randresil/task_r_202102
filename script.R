# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo)
# Fecha de elaboracion: 15/09/2021
# Ultima modificacion: por definir/09/2021

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) # Instalar la librería pacman
p_load(rio,readxl,haven,skimr,WriteXLS,tidyverse) # Llamar y/o instalar las librerías de la clase
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8