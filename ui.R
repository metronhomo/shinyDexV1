library(shiny)
library(ggplot2)
library(plotly)
library(rCharts)

shinyUI(fluidPage(
  navbarPage(
    "UpaxResearch",
    id="nav",
    tabPanel(
      "Mapa general",
      fluidRow(
        column(
          3,
          wellPanel(
            h4("Elige la variable para colorear el mapa"),
            selectInput('mapaVar','',names(mexico@data[10:16]))
          )
        ),
        column(
          8,
          leafletOutput("mapa")
        )
      )
    ),
    tabPanel(
      "Resumen por estado",
      fluidRow(
        column(
          2,
          wellPanel(
            style = "background-color: #ffffff;",
            h6("estado"),
            selectInput('edoEdo','',c('Total',levels(datosEstado$estadoOrigen)))
          )
        ),
        column(
          2,
          wellPanel(
            h6("variable 1"),
            selectInput('edo1','',names(datosEstado)[-c(1,2,4,5)],selected=3)
          )
        ),
        column(
          2,
          wellPanel(
            h6("variable 2"),
            selectInput('edo2','',names(datosEstado)[-c(1,2,4,5)],selected='estadoDestino')
          )
        ),
        column(
          2,
          wellPanel(
            h6("variable filtro"),
            selectInput('edoFiltro','',c('Total',names(datosEstado)[-c(2,4,5)]))
          )
        ),
        column(
          2,
          wellPanel(
            h6("categoría filtro"),
            selectInput('edoFiltro2','','Total')
          )
        )
      ),
      fluidRow(
        column(
          12,
          showOutput('frecuencias','nvd3')
        )
      )
    ),
    tabPanel(
      "series de tiempo",
      column(
        3,
        wellPanel(
          
          
          
          h6('Variable'),
          selectInput('serieVar','',names(datosEstado[13:18])),
          h6("estado"),
          selectInput('serieEdo','',c('Total',levels(datosEstado$estadoOrigen)))
        )
      ),
      column(
        9,
        showOutput('serie','nvd3')
      )
    )
  )
))






