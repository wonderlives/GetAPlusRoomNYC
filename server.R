server = function(input, output, session) {
  
 
  
###### MultiFunc Map Page ######
  
  # Initialize Lmap
	output$Lmap = renderLeaflet({
		leaflet() %>% 
      	addProviderTiles("Stamen.Watercolor") %>%
      	#addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
      	setView(lng = -73.9772, lat = 40.7527, zoom = 12)
  })
	
	
	# Add the temperature graph.
	output$tempAvg = renderPlot({
	  ## add in later
	})
  
	# Add the rainfall stats graph.
	output$rainFall = renderPlot({
	  ## add in later
	})
	
	# Set target marker
	observeEvent(input$Lmap_click, {
	  # Read click info
	  click = input$Lmap_click
	  LmapLat <<- click$lat
	  LmapLng <<- click$lng
	  print(paste(LmapLat,LmapLng))
	  # Get mode signal
	  nowSelectMode = input$targetSelectModeSwitch
	  # Update
	  if (nowSelectMode) {
	    # Get address
	    address <<- revgeocode(c(LmapLng,LmapLat))
	    print(address)
	    # use the proxy to save computation
	    leafletProxy('Lmap') %>% 
	      addCircles(lng=LmapLng, lat=LmapLat, group='circles',
	                 weight=1, radius=100, color='black', fillColor='orange',
	                 popup=address, fillOpacity=0.5, opacity=1,
	                 layerId = 'target')
	  } else {
	    return()
	  }
	})
	
	# Draw polygon of transit
  observeEvent(input$generateTransitPolygon,{
    urlWalkScore = urlWalkScore(apiKeyWalkScore, LmapLat, LmapLng, input$chooseTransitMethod, input$sliderTransitTime)
    #print(urlWalkScore)
    goodString = parseJsonToString(urlWalkScore)
    #print(class(getJsonWalkScore))
    write(goodString, "./data/transitPoly.json")
    transitPolygon = geojson_read("./data/transitPoly.json", what = "sp")
    #print('OK')
    output$Lmap = renderLeaflet({
      leaflet(transitPolygon) %>% 
        addProviderTiles("Stamen.Watercolor") %>%
        #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
        setView(lng = -73.9772, lat = 40.7527, zoom = 12) %>% 
        addCircles(lng=LmapLng, lat=LmapLat, group='circles',
                   weight=1, radius=100, color='black', fillColor='orange',
                   popup=address, fillOpacity=0.5, opacity=1,
                   layerId = 'target') %>% 
        addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.8)
    })
  })
  


###### Explore Map Page ######
  
  # Initialize Emap
  # Get color based on neighborhood group.
  nyc_code = geojsonio::geojson_read("./data/neighbourhoods.geojson",
                                     what = "sp")
  pal = colorFactor("RdYlBu", nyc_code@data[["neighbourhood_group"]])
  
  output$Emap = renderLeaflet({
    leaflet(nyc_code) %>% 
      addProviderTiles("Stamen.Watercolor", group = "Toner") %>%
      #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
      setView(lng = -73.9772, lat = 40.7527, zoom = 12) %>% 
      addPolygons(stroke = TRUE, weight = 1, smoothFactor = 1, color = "#000000",
                  label=~stringr::str_c(neighbourhood, ', ', neighbourhood_group),
                  fillColor= ~pal(neighbourhood_group), fillOpacity = 1,
                  group = "Boros",
                  highlightOptions = highlightOptions(
                    color='#ff0000', opacity = 0.3, weight = 2, fillOpacity = 0.3,
                    bringToFront = TRUE, sendToBack = TRUE))
  })
  
  # Enter explore mode. 
  observeEvent(input$EMapSwitch, {
    if (input$EMapSwitch) {
      leafletProxy('Emap') %>% hideGroup("Boros")
    } else {
      leafletProxy('Emap') %>% showGroup("Boros")
    }
  })
  
  # Get click information. 
  observeEvent(input$Emap_click, {
    # Read click info
    click = input$Emap_click
    print('working')
    EmapLat <<- click$lat
    EmapLng <<- click$lng
    print(paste(EmapLat,EmapLng))
    # Get mode signal
    nowSelectMode = input$EMapSwitch
    # Update
    if (nowSelectMode ) {
      # Get address
      address <<- revgeocode(c(EmapLng,EmapLat))
      print(address)
      # Get WalkScore
      url = urlWalkScoreCommon(apiKey = apiKeyWalkScore, lat = EmapLat, lon = EmapLng)
      walkScore = getWalkScoreJson(url)
      # Get Yelp business count
          # term
          # limit
          # radius
      url = getUrlYelp("Food", lat = EmapLat, lon = EmapLng, limit = 50, radius = 500)
      yelpResult = yelpResult(url, apiYelp)
      businessCount = yelpResult$total
      # GeneratePopUp
      popup = paste(address, 'has WalkScore of', walkScore, "and has food count of", businessCount)
      # use the proxy to save computation
      leafletProxy('Emap') %>% 
        addCircles(lng=EmapLng, lat=EmapLat, group='circles',
                   weight=1, radius=100, color='black', fillColor='orange',
                   popup=popup, fillOpacity=0.5, opacity=1,
                   layerId = 'target')
    } else {
      return()
    }
  })
  
  
}