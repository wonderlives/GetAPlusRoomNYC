library(shiny)
library(plotly)
#setwd('~/Shiny/rogerPro/')
weatherRawData = fread('weather.csv')
colnames(weatherRawData)
colnames(weatherRawData) = c("date", "averageLow", "averageHigh", "recordLow", "recordHigh", "averagePrecip")

weatherRawData[, averageLow := as.numeric(substr(averageLow,0,2))]
weatherRawData[, averageHigh := as.numeric(substr(averageHigh,0,2))]
weatherRawData[, averagePrecip := as.numeric (substr(averagePrecip,0,4))]
weatherRawData[, recordHigh := as.numeric(sub(pattern = "\\D.+$", "", recordHigh))] 
weatherRawData[, recordLow := as.numeric(sub(pattern = "\\D.+$", "", recordLow))]
weatherRawData[, dateR := as.Date(date, "%d-%b")]
weatherRawData[, dateR := substr(dateR,6,10)]
weatherRawData[, date := format(as.Date(date, "%d-%b"), format = "%m-%d")]


dates <- seq(as.Date("01/01/2016", format = "%d/%m/%Y"),
             by = "days", length = weatherRawData[,.N])
ui <- fluidPage(
  plotlyOutput("plot"),
  verbatimTextOutput("event")
)

server <- function(input, output) {
  
  
  # renderPlotly() also understands ggplot2 objects!
  output$plot <- renderPlotly({
    plot_ly(weatherRawData, x = 'dateR', y = ~'averageLow')
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
}

shinyApp(ui, server)

