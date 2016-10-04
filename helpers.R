funcionFrecuencias <- function(datos,var1=NULL,var2=NULL){
  require(rCharts)
  require(dplyr)
  
  if(length(var1) == 0){  var1 <- names(datos)[1] }
  if(length(var2) == 0){  var2 <- names(datos)[2] }
  
  eval(parse(text=paste(
    'resultado<-datos %>%
    group_by(',var1,',',var2,') %>%
    summarize(Freq=n()) %>%
    as.data.frame'
    ,sep='')))
  resultado <- 
    resultado[intersect(which(!is.na(resultado[,2])),which(!is.na(resultado[,1]))),]
  eval(parse(text=paste(
    'n1 <- nPlot(Freq ~ ',var2,', group = "',var1,'", data = resultado, type = "multiBarChart")'
    ,sep='')))
  
  n1$set(width = 1200)
  n1$set(height = 600)
  
  return(n1)
}

funcionSerie<-function(datos,grupo=envioMes,variable){
  
  eval(parse(text=paste(
    'resultado<-datos %>%
    group_by(envioMes,',variable,') %>%
    summarise(res=n()) %>%
    as.data.frame()'
  ,sep='')))
  
  resultado2<-datos %>%
    group_by(envioMes) %>%
    summarise(t=n()) %>%
    as.data.frame()
  
  resultado<-left_join(resultado,resultado2,id="envioMes")
  resultado$pro<-resultado$res/resultado$t
  
  eval(parse(text=paste(
    'r<-nPlot(pro~envioMes,group="',variable,'",data=resultado,type="lineChart")'
  ,sep='')))
  r$yAxis(tickFormat = "#! function(d) {return Math.round(d*100*100)/100 + '%'} !#")
  r$chart(useInteractiveGuideline=TRUE)
    r$show('inline', include_assets = TRUE, cdn = TRUE)
    r$set(width = 1100)
    r$set(height = 600)

    return(r)

    
}