server = function(input, output, session) {

	output$Lmap = renderLeaflet({
		leaflet() %>% 
      	addProviderTiles("Stamen.Watercolor") %>%
      	#addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
      	setView(lng = -73.9772, lat = 40.7527, zoom = 12)
  })
	
	output$tempAvg = renderPlot({
	  ## add in later
	})
  
	output$rainFall = renderPlot({
	  ## add in later
	})

}