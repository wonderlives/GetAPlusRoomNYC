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
      # 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore)
      # 3. ExploreMap: Some visualization about the graph.
      # 4. TransitMap: Plan transit extra powered by Google + Weather
      # 5. About: Github + LinkedIn + Blog; Data Sources

##### Define website title and theme. #####
ui = navbarPage(title = "NYC Living Recommendation System",
                id    = "navPage",
                theme = shinytheme("cerulean")

      

##### 1. Homepage: A gif bakcground with some quotes. #####
      tabPanel(title = "Homepage",
        br(),
        br(),
        HTML('<center><img src="beauty.jpg", height = "100%", weight = "100%" ></center>'),
        verbatimTextOutput("default"),
        verbatimTextOutput("placeholder", placeholder = TRUE)
        helpText("Note: while the data view will show only",
         "the specified number of observations, the",
         "summary will be based on the full dataset.")
        ),

##### 2. MulFuncMap: AirBnb + WalkScore + NYCOpenData(Crime) + Yelp + RangePolygon(From WalkScore) #####
      tabPanel(title = "TransitMap"
        # Add div details
        div(class="outer", tags$head(includeCSS("styles.css")),
        leafletOutput(outputId = "Lmap",
                      width    = "100%", height   = "100%"),
        absolutePanel(id       = "controls", 
                      class    = "panel panel-default", fixed    = TRUE, draggable = TRUE, 
                      top = 80, left = "auto", right = 20, bottom = "auto",
                      width = 320, height = "auto",
        h2("MulFuncMap"),
        #checkboxGroupInput(inputId = "select_boro", label = h4("Borough"), 
        #                   choices = boro, selected = 'Manhattan'),
        #checkboxGroupInput(inputId = "select_room", label = h4("Room Type"), 
        #                   choices = room, selected = room),
        sliderInput(inputId = "slider_price", label = h4("Price"), min = 1, max = 300, step = 20,
                    pre = "$", sep = ",", value = c(30, 300)),
        sliderInput(inputId = "slider_rating", label = h4("Rating Score"), min = 20, max = 100, step = 10,
                    value = c(60, 100)),
        sliderInput(inputId = "slider_review", label = h4("Number of Reviews"), min = 10, max = 450, step = 50,
                    value = c(10, 450)),
        
        h6("The map information is based on May 02, 2017 dataset from"),
        h6(a("Inside Airbnb", href = "http://insideairbnb.com/get-the-data.html", target="_blank"))
        ),
        
        # Results: count_room, avgprice
        #absolutePanel(id = "controls", class = "panel panel-default", fixed = FALSE, draggable = TRUE, 
        #              top = 320, left = 20, right = "auto" , bottom = "auto",
        #              width = 320, height = "auto",
        #              plotlyOutput(outputId = "count_room",height = 150),
        #              plotlyOutput(outputId = "avgprice", height = 150))
      
          )
        ),

##### 3. ExploreMap: Some visualization about the graph. #####     
      tabPanel(title = "ExploreMap"),

##### 4. TransitMap: Plan transit extra powered by Google + Weather #####      
      tabPanel(title = "TransitMap"),

##### 5. About: Github + LinkedIn + Blog; Data Sources #####      
      tabPanel(title = "About",
        verbatimTextOutput("default"))


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




server = function(input, output, session) {
  #print (input$mytext)
  
  observeEvent(input$mytext,{
    input$myslider
    
    txt = paste(input$mytext, sample(1:10000, 1))
  
    updateTextInput(session, 'myresults', value = txt)
  })
  ####$$$
  #output$Crime <- renderLeaflet({
    #leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
    # addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
    #addTopoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)
    #crime_code <- geojson_read("./data/crime.geojson",
                                       # what = "sp")
   # leaflet() %>%
    #  addTiles() #%>%
      #addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
      #addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.3
                  #fillColor = ~pal(MOVEMENT_ID),
    #  )
    #addLegend(pal = pal, values = ~log10(pop), opacity = 1.0,
    #          labFormat = labelFormat(transform = function(x) round(10^x)))
  #})
  
  
  
  
  ##
  output$NYC <- renderLeaflet({
    #leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
    # addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
    #addTopoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)
    nyv_code <- geojsonio::geojson_read("./www/neighbourhoods.geojson",
                                           what = "sp")
    leaflet(nyv_code) %>%
      addTiles() %>%
      #addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
      addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.3
                  #fillColor = ~pal(MOVEMENT_ID),
                  )
    #addLegend(pal = pal, values = ~log10(pop), opacity = 1.0,
    #          labFormat = labelFormat(transform = function(x) round(10^x)))
  })
  #######$$$
  #topoData <- readLines("./www/boston_censustracts.json") %>% paste(collapse = "\n")
  boston_code <- geojsonio::geojson_read("./www/boston_censustracts.json",
                                        what = "sp")
  
  pal <- colorNumeric("viridis", NULL)
  
  pp = getURL("http://api2.walkscore.com/api/v1/traveltime_polygon/json?wsapikey=8412c70d89cbac3d039721166ed78575&origin=47.6062095%2C-122.3320708&mode=transit&time=20")
  write(pp, "./data/raw_region.json")
  doc = read_json("./data/raw_region.json")
  final = doc$response$geometry
  exportJson <- toJSON(final)
  write(exportJson, "./data/final.json")
  #style <- '{ "fillColor" : "green" , "strokeColor" : "black", "strokeWeight" : 1}'
  #topoData <- readLines("./www/Police_Precincts.geojson") %>% paste(collapse = "\n")
  #rr_code <- geojson_read("./data/test.geojson", what = "sp")
  #url = "http://api2.walkscore.com/api/v1/traveltime_polygon/json?wsapikey=8412c70d89cbac3d039721166ed78575&origin=47.6062095%2C-122.3320708&mode=drive&time=30"
  rr_code = geojson_read('./data/final.json', what = 'sp')
  output$Ren <- renderLeaflet({
    leaflet(rr_code) %>% 
      addTiles() %>% 
      addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.8)# %>% 
      #addTopoJSON(topoData, weight = 5, fill = TRUE)
      #setView( lng = -122.332, lat= 47.60620, zoom = 13) #%>% 
      
    #addTopoJSON(pp_code, weight = 1, fill = TRUE)
    #leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
    # addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
    #addTopoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)
    #leaflet() %>% 
    #  addTiles()
    #%>% 
    #setView(lng = 47.60620, lat = -122.332, zoom = 13) %>%
    #addTiles() %>%
    #addTopoJSON(pp_code, weight = 1, fill = FALSE)
    #addLegend(pal = pal, values = ~log10(pop), opacity = 1.0,
    #          labFormat = labelFormat(transform = function(x) round(10^x)))
  })
  
  
  
  output$map <- renderLeaflet({
    #leaflet() %>% addTiles() %>%  # Add default OpenStreetMap map tiles
     # addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
      #addTopoJSON(topoData, weight = 1, color = "#444444", fill = FALSE)
    leaflet(boston_code) %>%
      addTiles() %>%
      addMarkers(lng=-71.0589, lat=42.3601, popup="Boston")%>%
      addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.3,
                    #fillColor = ~pal(MOVEMENT_ID),
                   label = ~paste0(MOVEMENT_ID))
      #addLegend(pal = pal, values = ~log10(pop), opacity = 1.0,
      #          labFormat = labelFormat(transform = function(x) round(10^x)))
  })

  Gmap_key <- 'AIzaSyAg9ptDoLp46EUcAG1ZpRGT6a-PjYMKOzs'
  
  nyc_code <- geojsonio::geojson_read("./www/neighbourhoods.geojson", what = 'sp')
  
  
  
  
  
  output$Gmap <- renderGoogle_map({
    google_map(key = Gmap_key, search_box = T, location = c(47.6062095,-122.3320708), zoom =13) %>% 
      #add_traffic() %>% 
      add_geojson(data = pp, style = style)
  }
  )
  output$Gmap2 <- renderGoogle_map({
    google_map(key = Gmap_key, search_box = T, event_return_type = "list")
  })
  observeEvent(input$Gmap2_map_click, {
    #google_map_update(map_id = 'Gmap2') %>% 
    #add_markers(lat = input$Gmap2_map_click$lat, lon =input$Gmap2_map_click$lon, info_window = "Roger")
    lat <- input$Gmap2_map_click$lat
    lon <- input$Gmap2_map_click$lon
    
    print(paste(lat, lon))
    #print(lon)
    
    

    df = data.frame(lat, lon) 
    
    google_map_update(map_id = 'Gmap2') %>%
      #add_markers(data = df, lat = lat, lon ==lon, info_window = "Roger")
      add_markers(data = df, lat = 'lat', lon = 'lon', info_window = "Roger")
    

  })
  
# r <- GET("http://api.walkscore.com/score?format=json&lat=42.3601&lon=-71.0589&transit=1&bike=1&wsapikey=8412c70d89cbac3d039721166ed78575")

 
}

