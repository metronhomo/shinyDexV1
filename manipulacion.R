#layer---------------------------------------------------------------------------------------

tmp<-tempdir()
url <- "http://personal.tcu.edu/kylewalker/data/mexico.zip"
file <- basename(url)
download.file(url, file)
unzip(file, exdir = tmp)
mexico <- readOGR(dsn = tmp, layer = "mexico", encoding = "UTF-8")
saveRDS(mexico,"mexico.rds")
names(datosMini)

mexico@data$name<-as.character(mexico@data$name)
mexico@data$state<-as.character(mexico@data$state)

mexico@data$name<-catalogo
mexico@data$state<-catalogo

mexico@data$name<-as.factor(mexico@data$name)
mexico@data$state<-as.factor(mexico@data$state)

#datosEstado------------------------------------------------------------------------------------------------------------------------




#datos que le pego a dicho layer para el mapa-------------------------------------------------------------------------------------

library(dplyr)
datos<-readRDS("7 base con cluster nacional.rds") %>%

resumenA<-datos %>%
  group_by(envioEstadoNombre) %>%
  summarise(
    envios=n(),
    montoTotal=sum(monto),
    montoPromedio=mean(monto),
    edad=mean(envioEdad),
    hora=mean(envioHora)
  ) %>%
  as.data.frame()

resumenB<-datos %>%
  group_by(envioEstadoNombre,envioCliente)%>%
  summarise(envios=n()) %>%
  group_by(envioEstadoNombre) %>%
  summarise(enviosPorCliente=mean(envios)) %>%
  as.data.frame()




resumenC<-datos %>%
  group_by(envioEstadoNombre,envioCliente,pagoCLiente)%>%
  summarise(envios=length(unique(pagoCliente))) %>%
  group_by(envioEstadoNombre) %>%
  summarise(enviosPorCliente=mean(envios)) %>%
  as.data.frame()

#uno los datos de resumen y la cosa geofráfica-----------------------------------

mexico@data$envios<-resumenA$envios
mexico@data$montoTotal<-resumenA$montoTotal
mexico@data$edad<-resumenA$edad
mexico@data$hora<-resumenA$hora
mexico@data$montoPromedio<-resumenA$montoPromedio

mexico@data$enviosPromedioPorCliente<-resumenB$enviosPorCliente
mexico@data$beneficiariosPromedio<-resumenC$enviosPorCliente


#guardo la cosa geográfica con los nuevos datos de resumen---------------------------


saveRDS(mexico,"data/mexico.rds")

