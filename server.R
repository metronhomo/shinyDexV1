library(shiny)
library(plotly)
library(rCharts)
library(dplyr)

shinyServer(function(input,output,session){
  
  
#observador para tener un filtro dinámico----------------------------------------------------------------------------------------------------  
  
  observe({
    if(input$edoFiltro!="Total"){
      datos1<-datosEstado %>%
        dplyr::select(one_of(input$edoFiltro))
      
      r_options<-c('Total',levels(datos1[,1]))
    }else{
      r_options<-"Total"
    }
    updateSelectInput(session,'edoFiltro2',choices=r_options)
  })
  
  
  
#mapa-----------------------------------------------------------------------------------------------------------  
  output$mapa<-renderLeaflet({
    
    eval(parse(text=paste(
      ' pal <- colorNumeric(
      palette = "YlGnBu",
      domain = mexico@data$',input$mapaVar,'
    )'
    ,sep='')))
    
    coso<-' millones'
    if(input$mapaVar=='edad')coso<-' años'
    if(input$mapaVar=='hora')coso<-''
    if(input$mapaVar=='montoPromedio')coso=' pesos'
    if(input$mapaVar=='enviosPromedioPorCliente')coso=' envíos por persona'
    if(input$mapaVar=='beneficiariosPromedioPorCliente')coso=' beneficiarios por persona'
    
    divisor<-1000000
    if(input$mapaVar=='edad')divisor<-1
    if(input$mapaVar=='hora')divisor<-1
    if(input$mapaVar=='montoPromedio')divisor<-1
    if(input$mapaVar=='enviosPromedioPorCliente')divisor<-1
    if(input$mapaVar=='beneficiariosPromedioPorCliente')divisor<-1
    
    eval(parse(text=paste(
    'state_popup <- paste0("<strong>Estado: </strong>", 
                          mexico$name, 
                          "<br><strong>',input$mapaVar,': </strong>", 
                          mexico$',input$mapaVar,')'  
    ,sep='')))
    
    eval(parse(text=paste(
      'mapa<-leaflet(data = mexico) %>%
        
        addProviderTiles("CartoDB.Positron") %>%
        addPolygons(color = ~pal(',input$mapaVar,'), 
                    fillOpacity = 0.8, 
                    weight = 1, 
                    popup = state_popup)%>%
      addPolylines(color="black",weight=1) %>%
      addLegend("bottomleft",pal=pal,values=~',input$mapaVar,',
      title="",labFormat=labelFormat(suffix="',coso,'",transform=function(x)x/',divisor,' ))'
    ,sep='')))
    
  })

  
#frecuencias y cruces--------------------------------------------------------------------------
  
  datosEstadoSub<-reactive({
    

    datosEstadoSub<-datosEstado
    
    if(input$edoEdo!='Total'){
      datosEstadoSub<-datosEstadoSub %>%
        dplyr::filter(estadoOrigen==input$edoEdo)
    }

   if(input$edoFiltro2!='Total'){
     eval(parse(text=paste(
     'datosEstadoSub<-datosEstadoSub %>%
       dplyr::filter(',input$edoFiltro,'=="',input$edoFiltro2,'")'  
     ,sep='')))
   }
   datosEstadoSub
  })
  
  datosSerieEstadoSub<-reactive({
    
    
    datosSerieEstadoSub<-datosEstado
    
    if(input$serieEdo!='Total'){
      datosSerieEstadoSub<-datosSerieEstadoSub %>%
        dplyr::filter(estadoOrigen==input$serieEdo)
    }
    
    
    datosSerieEstadoSub
  })
  
  
  
#frecuencias-----------------------------------------------------------------------------------------
  
  frecuencias<-reactive({
    funcionFrecuencias(datosEstadoSub(),input$edo2,input$edo1)
  })
  output$frecuencias<-renderChart2({
    frecuencias()
  })
  
  
#serie de tiempo-----------------------------------------------------------------------------------------------
  
  serie<-reactive({
    funcionSerie(datos=datosSerieEstadoSub(),variable=input$serieVar)
  })
  
  output$serie<-renderChart2({
    serie()
  })
  
  
#fin--------------------------------------------------------------------  
  
  
})