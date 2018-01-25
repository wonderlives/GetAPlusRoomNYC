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
	  clat <<- click$lat
	  clng <<- click$lng
	  print(paste(clat,clng))
	  # Get mode signal
	  nowSelectMode = input$targetSelectModeSwitch
	  # Update
	  if (nowSelectMode ) {
	    # Get address
	    address <<- revgeocode(c(clng,clat))
	    print(address)
	    # use the proxy to save computation
	    leafletProxy('Lmap') %>% 
	      addCircles(lng=clng, lat=clat, group='circles',
	                 weight=1, radius=100, color='black', fillColor='orange',
	                 popup=address, fillOpacity=0.5, opacity=1,
	                 layerId = 'target')
	  } else {
	    return()
	  }
	})
	
	# Draw polygon of transit
  observeEvent(input$generateTransitPolygon,{
    urlWalkScore = urlWalkScore(apiKeyWalkScore, clat, clng, input$chooseTransitMethod, input$sliderTransitTime)
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
        addCircles(lng=clng, lat=clat, group='circles',
                   weight=1, radius=100, color='black', fillColor='orange',
                   popup=address, fillOpacity=0.5, opacity=1,
                   layerId = 'target') %>% 
        addPolygons(stroke = TRUE, smoothFactor = 0.5, fillOpacity = 0.8)
    })
  })


###### Explore Map Page ######
  
  # Initialize Emap
  output$Emap = renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Stamen.Watercolor") %>%
      #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
      setView(lng = -73.9772, lat = 40.7527, zoom = 12)
  })
  
  # Get click information. 
  observeEvent(input$Emap_click, {
    # Read click info
    #clat = 1
    #clng = 2
    click = input$Emap_click
    clat <<- click$lat
    clng <<- click$lng
    print(paste(clat,clng))
    # Get mode signal
    nowSelectMode = input$EMapSwitch
    # Update
    if (nowSelectMode ) {
      # Get address
      address <<- revgeocode(c(clng,clat))
      print(address)
      # use the proxy to save computation
      leafletProxy('Emap') %>% 
        addCircles(lng=clng, lat=clat, group='circles',
                   weight=1, radius=100, color='black', fillColor='orange',
                   popup=address, fillOpacity=0.5, opacity=1,
                   layerId = 'target')
    } else {
      return()
    }
  })
  # Set target marker
  
}