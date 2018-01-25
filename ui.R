# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version: 1.0
# Date: Jan 23 2018
# ##########################################

# @@## Move to global.R
# Import libraries


# Define UI layout: navbarPage layout (5 tabs pages)
# Five tab pages:
      # 1. Homepage: A gif bakcground with some quotes.
      # 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore)
      # 3. ExploreMap: Some visualization about the graph.
      # 4. TransitMap: Plan transit extra powered by Google + Weather
      # 5. About: Github + LinkedIn + Blog; Data Sources

##### Define website title and theme. #####
ui = navbarPage(title = "NYC Living Recommendation System",
                id    = "navPage",
                theme = shinytheme("cerulean"),

      

##### 1. Homepage: A gif bakcground with some quotes. #####
      tabPanel(title = "Homepage",
        br(),
        br(),
        h1("default"),
        h1("placeholder", placeholder = TRUE),
        HTML('<center><img src="beauty.jpg", height = 400, weight = 800 ></center>'),
        helpText("Note: while the data view will show only",
         "the specified number of observations, the",
         "summary will be based on the full dataset.")
        ),

##### 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore) #####
      tabPanel(title = "MulFuncMap",
        
        div(
          
          # Set CSS for full screen map
          class="outer",
          tags$head(includeCSS("./www/styles.css")),
                 
                 
          # Add Map       
          leafletOutput(outputId = "Lmap", width = "100%", height = "100%"),
          
          # Add Control Panel
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                      top = 80, bottom = "auto", left = 20, right = "auto",
                      width =400, height = "auto",
          h2("Place in NYC"),
          
          # Time to stay
          sliderTextInput(inputId = "selectMonth", 
                          label = "Please select when you will visit NYC:", 
                          choices = month.abb, selected = month.abb[c(1,4)]),
          
          # Safety Level
          sliderTextInput(inputId = "selectSafety", 
                          label = "Safety level:", 
                          choices = safetyScoreLevel,
                          selected = safetyScoreLevel[3]),
          # Food Level
          sliderTextInput(inputId = "selectFood", 
                          label = "Food level:", 
                          choices = foodScoreLevel,
                          selected = foodScoreLevel[3]),
          # Walk Level
          sliderTextInput(inputId = "selectWalk", 
                          label = "Walk-friendly level:", 
                          choices = walkScoreLevel,
                          selected = walkScoreLevel[3]),
          # Price Level
          sliderInput(inputId = "sliderPrice", 
                      label = "Price", 
                      min = 1, max = 300, step = 20,
                      pre = "$", sep = ",", value = c(80, 200)),
          
          # Plot Tempearture for the selected dates
          plotOutput("tempAvg", height = 200),
          
          # Plot Precipitation for the selected dates
          plotOutput("rainFall", height = 200)
          
          )
         ) 
        ),

##### 3. ExploreMap: Some visualization about the graph. #####     
      tabPanel(title = "ExploreMap"),

##### 4. TransitMap: Plan transit extra powered by Google + Weather #####      
      tabPanel(title = "TransitMap"),

##### 5. About: Github + LinkedIn + Blog; Data Sources #####      
      tabPanel(title = "About",
               h1("default")
               
               )


  )