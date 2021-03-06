library(ggplot2)

# MODULE UI
scatterUI <- function(id) {
  ns <- NS(id)
  
  list(
    div(sliderInput(ns("slider1"), label = "Limit points", min = 0, max = 32, value = 15)),
    div(style="display: inline-block; height:220px;", plotOutput(ns("plot1"))),
    div(style="display: inline-block; height:220px;", plotOutput(ns("plot2")))
  )
}

# MODULE Server
scatter <- function(input, output, session, datname, var1, var2, ptshape, col1, col2) {
  
  dat <- eval(as.name(datname))
  dat <- dat[order(dat[[var1]]),]
  
  
  
  observeEvent(input$test,{
    print ('ttt')
  })
  
  resultdata <- reactive({
    dat[1:input$slider1,]
  })
  
  output$plot1 <- renderPlot({
    plot(1:10)
    ggplot(resultdata(), aes_string(var1, var2)) + geom_point(color=col1, shape=ptshape, size=3)+
      ggtitle(paste("Using the", datname, "data.frame"))
  }, width=200, height=200)
  
  output$plot2 <- renderPlot({
    plot(1:10)
    ggplot(resultdata(), aes_string(var1, var2)) + geom_point(color=col2, shape=ptshape, size=3) +
      ggtitle(paste("Using the", datname, "data.frame"))
  }, width=200, height=200)
}


# App ui
ui <- fluidPage(
  h3("The module creates two plots and a slider and is called twice below"),
  sliderInput(inputId = 'test', label = 'haha',min = 0, max = 10, value = 5),
  scatterUI("prefix"),
  scatterUI("prefix2")
)

# App server
server <- function(input, output,session){
  
  callModule(scatter, "prefix", "cars", "speed", "dist",  1, "red", "blue")
  callModule(scatter, "prefix2", "mtcars", "mpg", "hp", 17, "forestgreen", "purple")
}

shinyApp(ui, server)