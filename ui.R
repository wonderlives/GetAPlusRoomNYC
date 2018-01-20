library(shinythemes)
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
      textInput(inputId = "mytext", label = "Text input", value = "Enter text...")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel('Me'),
        tabPanel('You')
      )
    )
  )
)