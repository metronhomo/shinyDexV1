library(rgdal)
library(leaflet)

mexico<-readRDS('data/mexico.rds')
datosEstado<-readRDS('data/datosEstado.rds')
datosEstado$estadoDestino<-droplevels(datosEstado$estadoDestino)


source('helpers.R')
