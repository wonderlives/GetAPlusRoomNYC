dropPinUI = function(id) {
	ns = NS(id)

	list(
		switchInput(inputId = ns("switchToggle"), 
                    onStatus = "success", 
                    offStatus = "danger")
	)
}

dropPin = function(input, output, session, mapName) {

	currStatus = reactive({input$switchToggle})
	mapClickName = paste0(mapName,"_click")
	print(mapClickName)

	observeEvent(input$switchToggle, {
		print('Module is working.')
		})

	observeEvent(input$mapClickName, {
		click = input$mapClickName
		lat = click$lat
		lng = click$lng
		#print(paste(lat, lng))
		print('Module is working.')
		if (currStatus) {
			address = revgeocode(c(lng, lat))
			print (address)
			leafletProxy(mapName) %>%
				addCircles(	lng, lat, group = 'circle',
							weight = 1, radius = 100, color = 'black', fillColor = 'orange',
							popup = address, fillOpacity = 0.5, opacity = 0.8,
							layerId = 'dropPin')

		} else {
			return ()
		}

	})

}

output$Lmap = renderLeaflet({
		leaflet() %>% 
      	addProviderTiles("Stamen.Watercolor") %>%
      	#addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
      	setView(lng = -73.9772, lat = 40.7527, zoom = 12)
  })