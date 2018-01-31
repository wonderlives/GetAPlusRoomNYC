# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version: 2.0
    # Date: Jan 30, 2018
# Version: 1.0
    # Original Date: Jan 23 2018
# ##########################################

# Define UI layout: navbarPage layout (5 tabs pages)
# Five tab pages:
    # 1. Homepage: A gif bakcground with some quotes.
    # 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore)
    # 3. ExploreMap: Some visualization about the graph.
    # 4. TransitMap: Plan transit extra powered by Google + Weather
    # 5. About: Github + LinkedIn + Blog; Data Sources

##### Define website title and theme. #####
ui = navbarPage(title = paste("Get A+ Room NYC",emo::ji("poop")),
                id    = "navPage",
                theme = shinytheme("cerulean"),

##### 1. Homepage: A gif bakcground with some quotes. #####
    tabPanel(title = "Homepage",
             leafletOutput(outputId = "Tmap", width = "100%", height = "100%"),
                br(),
                br(),
                h1("default"),
                h1("placeholder", placeholder = TRUE),
                HTML('<center><img src="darkNYC.jpg", height = 1920, weight = 1080 ></center>'),
                helpText("Note: while the data view will show only",
                        "the specified number of observations, the",
                        "summary will be based on the full dataset.")
),

##### 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore) #####
    
    tabPanel( icon = icon("table"),title = "MulFuncMap",
    
    div(    
        # Set CSS for full screen map
        class="outer",
        tags$head(includeCSS("./www/styles.css")),
        # Add Map       
        leafletOutput(outputId = "Lmap", width = "100%", height = "100%"),
        # Add Main Control Panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                    top = 80, bottom = "auto", left = 20, right = "auto",
                    width =320, height = "auto",
            # Title of the panel
            h2("Place in NYC"),
            # Time to stay
            sliderTextInput(inputId = "selectMonth", 
                            label = "Please select when you will visit NYC:", 
                            choices = month.abb, selected = month.abb[c(1,12)]),
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
            plotOutput("tempAvg", height = 400),
            # DEBUG TEXTBOX
            verbatimTextOutput("testEvent")
            
            #### The following code was discarded due to lack of X-axis support and lack of viriance of rain data.
            # Plot Precipitation for the selected dates
            #   plotOutput("rainFall", height = 200)
            # Plot Tempearture for the selected dates
            #   htmlOutput("tempAvg", height = 400), 
            #### END of the test codes.€
        ), # END of main control panel
      
        # Add transit zone panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                    top = "auto", bottom = 80, left = "auto", right = 20,
                    width =400, height = "auto",
            # Title of the panel
                h2("How far can I get?"),
            # Activate target select mode.
                switchInput(inputId = "targetSelectModeSwitch", 
                onStatus = "success", offStatus = "danger"),
            # Select transit method
                prettyRadioButtons(inputId = "chooseTransitMethod", 
                                label = "Choose:", 
                                choices = transitMethods, 
                                selected = transitMethods[4],
                                icon = icon("check"),
                                inline = TRUE,
                                bigger = TRUE, status = "info", 
                                animation = "jelly"),
            # Select time
                sliderInput(inputId = "sliderTransitTime", 
                        label = "Time", 
                        min = 0, max = 60, step = 5,
                        post = "min", sep = ",", value = 20),
            # Call api and draw polygon
                actionButton("generateTransitPolygon", "Go!")
        ), # END of transit zone panel
      
        # Add style change panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                    top = 80, bottom = "auto", left = "auto", right = 20,
                    width =400, height = "auto",
            # Title of the panel
                h2("Choose a style"),

            # Choose between 3
            # @@##$$%% change later for different styles
                prettyRadioButtons(inputId = "chooseMapStyle", 
                                label = "Choose:", 
                                choices = c("Click me !","Me !", "Or me !"), 
                                icon = icon("check"), 
                                inline = TRUE,
                                bigger = TRUE, status = "info", 
                                animation = "jelly")
        ) # END of style change panel
        ) # END of this div<>
    ), # END of the MultiFun Tab

##### 3. ExploreMap: Some visualization about the graph. #####     
    tabPanel(title = "ExploreMap",
    div(
        # Set CSS for full screen map
        class="outer",
        tags$head(includeCSS("./www/styles.css")),
        # Add Explore Map       
        leafletOutput(outputId = "Emap", width = "50%", height = "100%"),
        # Add Explore Control Panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE, 
                    top = 55, bottom = "auto", left = "auto", right = 0,
                    width ="50%", height = "auto",
            # Title of the panel
                h2("Choose a style"),

            # Style chang
            # Choose between 3
            # @@##$$%% change later for different styles
                prettyRadioButtons(inputId = "exploreMapControl", 
                                label = "Choose:", 
                                choices = c("Click me !","Me !", "Or me !"), 
                                icon = icon("check"), 
                                inline = TRUE,
                                bigger = TRUE, status = "info", 
                                animation = "jelly"),

            # Select switch
                switchInput(inputId = "EMapSwitch", 
                    onStatus = "success", offStatus = "danger"),
            # Information Panel
                # Address
                fluidRow(
                verbatimTextOutput("pricePrediction")
                ),
                # Walk + Bike + Transit
                fluidRow(
                htmlOutput("walkBikeTransitScore")
                ),
                # Business break down
                fluidRow(
                splitLayout(cellWidths = c("33%","33%", "33%"), htmlOutput("buzBreakPoint"), htmlOutput("buzBreakCity"), htmlOutput("buzBreakNYC"))
                ),
                # Price prediction
                fluidRow(
                verbatimTextOutput("pricePrediction")
                )
        ) # END of this panel
        ) # END of this div<>
    ), # END of the ExploreMap

##### 4. TransitMap: Plan transit extra powered by Google + Weather #####      
      tabPanel(title = "TransitMap"),

##### 5. About: Github + LinkedIn + Blog; Data Sources #####      
      tabPanel(title = "About",
               h1("90–100   Walker's Paradise
                    Daily errands do not require a car.
                    70–89   Very Walkable
                    Most errands can be accomplished on foot.
                    50–69   Somewhat Walkable
                    Some errands can be accomplished on foot.
                    25–49   Car-Dependent
                    Most errands require a car.
                    0–24    Car-Dependent
                    Almost all errands require a car.")
               )


) # END of NAVI page.##-RR
