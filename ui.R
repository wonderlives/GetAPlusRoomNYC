library(shinythemes)
library(leaflet)
ui = fluidPage(
  #theme = 'bootstrap.css',
  theme = shinytheme("cerulean"),
  titlePanel ('Roger\'s Shiny Projec'),
  sidebarLayout(
    sidebarPanel (
      #h3('What\'s going on'),
      actionButton('button', 'Click me'),
      sliderInput(inputId = "myslider", label = "Limit the ", min = 0, 
                  max = 100, value = c(40, 60)),
      # a text input box
      textInput(inputId = "mytext", label = "Text input", value = "Enter text..."),
      textInput(inputId = 'myresults', label = 'Results will be printed here', value = 'initial value')
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel('Me'),
        tabPanel('You',
                 leafletOutput(outputId = "map"))
      )
    )
  )
)