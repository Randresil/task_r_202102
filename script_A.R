# Elaborado por: Ricardo Andres Silva Torres
# Colaboradores: Ninguno (solo yo)
# Fecha de elaboracion: 15/09/2021
# Ultima modificacion: por definir/09/2021

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
if(!require(pacman)) install.packages("pacman") ; require(pacman) # Instalar la librería pacman
p_load(rio,readxl,haven,skimr,WriteXLS,tidyverse) # Llamar y/o instalar las librerías de la clase
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

#######################################
#             TALLER A                #
#######################################

# 1 - VECTORES #
cat("Cree un vector que contenga los números del 1 al 100, posteriormente cree otro vector que contenga los números impares de 1 a 99. Use el vector de números impares para crear un vector con los números pares de del primer vector.")
vector_1 = c(1:100)
