# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version: 1.0
# Date: Jan 23 2018
# ##########################################

# @@## Move to global.R
# Import libraries
library(shinythemes)
library(leaflet)

# Define UI layout: navbarPage layout (5 tabs pages)
# Five tab pages:
      # 1. Homepage: A gif bakcground with some quotes.
      # 2. ToLive: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore)
      # 3. ToExplore: Some visualization about the graph.
      # 4. ToGo: Plan transit extra powered by Google + Weather
      # 5. About: Github + LinkedIn + Blog; Data Sources

##### Define website title and theme. #####
ui = navbarPage(title = "NYC Living Recommendation System",
                id    = "navPage",
                theme = shinytheme("cerulean")

      

##### 1. Homepage: A gif bakcground with some quotes. #####
      tabPanel(id = "Homepage",
        # Add div details
          div(class="outer", tags$head(includeCSS("styles.css")),
          


        ),



##### 2. ToLive: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore) #####
      tabPanel(id = ""
        ),

##### 3. ToExplore: Some visualization about the graph. #####     
      tabPanel(id = ""),

##### 4. ToGo: Plan transit extra powered by Google + Weather #####      
      tabPanel(id = ""),

##### 5. About: Github + LinkedIn + Blog; Data Sources #####      
      tabPanel(id = "")


  )

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
        
        # Placeholder tab
        tabPanel('Me',
                 'File Loaded'),
        tabPanel('Crime',
                 leafletOutput(outputId = "Crime")),
        tabPanel('NYC',
                 leafletOutput(outputId = "NYC")),
        
        tabPanel('RANGE',
                 leafletOutput(outputId = "Ren")),
        
        # Leaf tab
        tabPanel('You',
                 leafletOutput(outputId = "map")),
        
        # Google Map tab
        tabPanel('Google',
                 google_mapOutput(outputId = "Gmap"),
                 sliderInput(inputId = "opacity", label = "opacity", min = 0, max = 1, 
                             step = 0.01, value = 1)),
        # Gmap2
        tabPanel('ClickGMAP',
                 sliderInput(inputId = "opacity2", label = "opacity", min = 0, max = 1, 
                             step = 0.01, value = 1),
                 google_mapOutput('Gmap2') )
       
      )
    )
  )
)