# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version: 4.0 # Date: Jan 30, 2018
# Version: 2.0 # Date: Jan 28, 2018
# Version: 1.0 # Original Date: Jan 23 2018
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
    
    tabPanel(icon = icon("table"), title = "MulFuncMap",

    div(    
        # Set CSS for full screen map
        class="outer",
        tags$head(includeCSS("./www/styles.css")),
        # Add LMap       
        leafletOutput(outputId = "Lmap", width = "100%", height = "100%"),
        # Add Main Control Panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                    top = 80, bottom = "auto", left = 20, right = "auto",
                    width = 340, height = "auto",
            # Title of the panel
            h2("Place in NYC"),
            # Address to GeoCode
                div(style="display: inline-block;vertical-align:top; width: 250px;",
                    textInput(inputId = "textInputAddress",
                                         label = NULL,
                                         placeholder = "NYC Data Science Academy...")),
                div(style="display: inline-block;vertical-align:top; width: 10px;",
                    actionButton("buttonSearchAddress", emo::ji("magnifying"))),

            # Time to stay
            sliderTextInput(inputId = "sliderMonth", 
                            label = "Please select when you will visit NYC:", 
                            choices = month.abb, selected = month.abb[c(3,10)]),
            # Safety Level
            sliderTextInput(inputId = "sliderSafety", 
                            label = "Safety level:", 
                            choices = safetyScoreLevel,
                            selected = safetyScoreLevel[3]),
            # Food Level
            sliderTextInput(inputId = "sliderFood", 
                            label = "Food level:", 
                            choices = foodScoreLevel,
                            selected = foodScoreLevel[3]),
            # Walk Level
            sliderTextInput(inputId = "sliderWalk", 
                            label = "Walk-friendly level:", 
                            choices = walkScoreLevel,
                            selected = walkScoreLevel[3]),
            # Price Level
            sliderInput(inputId = "sliderPrice", 
                        label = "Price", 
                        min = 1, max = 300, step = 20,
                        pre = "$", sep = ",", value = c(80, 200)),
            # DEBUG TEXTBOX
            verbatimTextOutput("debugText"),
            # Plot Tempearture for the selected dates
            plotOutput("graphTemp", height = 400)
            
            
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
                    width = "340", height = "auto",
            # Add CSS
                class="outer",
                tags$head(includeCSS("./www/styles.css")),
            # Title of the panel
                h2("How far can I get?"),
            # Select transit method
                prettyRadioButtons(inputId = "checkboxTransit", 
                                label = "Choose method and time span:", 
                                choices = transitMethods, 
                                selected = transitMethods[4],
                                icon = icon("check"),
                                inline = TRUE,
                                bigger = TRUE, status = "info", 
                                animation = "jelly"),
            # Select time
                sliderInput(inputId = "sliderTransitTime", 
                        label = NULL, width = "100%",
                        min = 0, max = 60, step = 1,
                        post = " min", value = 20),

            # Travel map explore
                fluidRow(
                splitLayout(cellWidths = c("5","55%","20%", "20%"), 
                            " ",
                            switchInput(inputId = "switchLmapMarker", label ="Drop Pin",
                                        onStatus = "success", offStatus = "danger"), 
                            actionButton("buttonClearZone", "Clear"), 
                            actionButton("buttonGenZone", "GO!"))
                )
        ), # END of transit zone panel
      
        # Add style change panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                    top = 80, bottom = "auto", left = "auto", right = 20,
                    width =400, height = "auto",
            # Title of the panel
                h2("Choose a style"),

            # Choose between 3
            # @@##$$%% change later for different styles
                prettyRadioButtons(inputId = "checkboxStyleLmap", 
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
        # Add Control Panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE, 
                    top = "auto", bottom = 10, left = 0, right = "auto",
                    width ="50%", height = "auto",
            # Title of the panel
            h6("Drop a pin and choose radius"),
            # Travel map explore
                fluidRow(
                splitLayout(cellWidths = c("5","15%","70%", "3%", "7%"), 
                            " ",
                            switchInput(inputId = "switchEmapMarker", 
                                        label = "Explore!",
                                        onStatus = "success", offStatus = "danger"), 
                            sliderInput(inputId = "sliderRadius", 
                                        label = NULL, width = "100%",
                                        min = 0, max = 1000, step = 50,
                                        post = " m", value = 250), 
                            "",
                            actionButton("buttonEmapGenData", "GO!"))
                )
                
        ), # END of the Control Panel

        # Add Showing Panel
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE, 
                    top = 55, bottom = "auto", left = "auto", right = 0,
                    width ="50%", height = "auto",
            # Title of the panel
                div(style="text-align:center",
                    h1("Your Pin Information")),
            # Information Panel
                # Address
                h3('Here is the Address:'),
                div(style="text-align:center",
                    textOutput("textEAddress")),
                # Gauge
                h3('The Walk, Bike, Transit Indices:'),
                fluidRow(
                splitLayout(cellWidths = c("33%","33%", "33%"), 
                            htmlOutput("gaugeWalkScores"), 
                            htmlOutput("gaugeBikeScores"), 
                            htmlOutput("gaugeTransitScores"))
                ),

                # Business break down
                h3('Here is the Business Breakdown:'),
                fluidRow(
                splitLayout(cellWidths = c("33%","33%", "33%"), 
                            htmlOutput("pieBreakPoint"),
                            htmlOutput("pieBreakCity"), 
                            htmlOutput("pieBreakNYC"))
                ),
                # Price Prediction
                h3('The Predicted Price is:'),
                fluidRow(
                div(style="text-align:center",
                    textOutput("textPricePrediction"))
                )

        ) # END of Showing panel

        ) # END of this div<>

    ), # END of the ExploreMap

##### 4. TransitMap: Plan transit extra powered by Google + Weather #####      
    # Future Features.
    # tabPanel(title = "TransitMap"),

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
)# END of NAVI page.##-RR