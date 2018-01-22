
library(leaflet)
server = function(input, output, session) {
  #print (input$mytext)
  
  observeEvent(input$mytext,{
    input$myslider
    
    txt = paste(input$mytext, sample(1:10000, 1))
  
    updateTextInput(session, 'myresults', value = txt)
  })
  
  #topoData <- readLines("./www/boston_censustracts.json") %>% paste(collapse = "\n")
  boston_code <- geojsonio::geojson_read("./www/boston_censustracts.json",
                                        what = "sp")
  
  pal <- colorNumeric("viridis", NULL)
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

  
  
  
}