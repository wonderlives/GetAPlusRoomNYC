

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

