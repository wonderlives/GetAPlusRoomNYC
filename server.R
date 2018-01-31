# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version info please check the UI.R file. 
# ##########################################

server = function(input, output, session) {

###################################################### MultiFunc Map Page ######################################################

# DEBUG TEXT BOX 
    output$debugText = renderPrint({
        print(paste(LmapLat,LmapLng))
        print(input$textInputAddress)
    })

# Initialize Lmap
    output$Lmap = renderLeaflet({
        leaflet() %>% 
        #addTiles() %>% 
        addProviderTiles("Stamen.Watercolor") %>%
        #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
        setView(lng = LmapLng, lat = LmapLat, zoom = 12)
    })

# Address search and update TARGET marker
    # Update global address
    address = reactive({
        result <<- input$textInputAddress
        return (result)
    })

    # Update global LmapLat and LmapLng
    observeEvent(input$buttonSearchAddress, {
        if (address() != "") {
            print(address())
            LmapLat <<- geocode(address())$lat
            LmapLng <<- geocode(address())$lon
            print(paste(LmapLat,LmapLng))
        } else {
            print('Empty address')
            return()
        }
    })

    # TODO:: add target marker
   
# Temperature Graph
    # Get the range.
        weatherDF = reactive({
          start = input$sliderMonth[1]
          end = input$sliderMonth[2]
          start = match(start, month.abb)
          end = match(end, month.abb)
          df = weatherRawData[((start-1)*30+1):((end-1)*30+30), ]
          return (df)
        })
    # Plot graph
        output$graphTemp = renderPlot({
            x = weatherDF()$dateR
            y1 = weatherDF()$averageLow
            y2 = weatherDF()$averageHigh
            y3 = weatherDF()$recordLow
            y4 = weatherDF()$recordHigh
            plot(x, y1, 'l', ylim = range((c(y3,y4))), axes = FALSE, 
                xlab = "" , ylab = "",  col = 'cornflowerblue', xaxt = "n")
            par(new = TRUE)
            plot(x, y2, 'l', ylim = range((c(y3,y4))), axes = FALSE, 
                xlab = "" , ylab = "", col = 'indianred1')
            par(new = TRUE)
            plot(x, y3, 'l', ylim = range((c(y3,y4))), axes = FALSE, 
                xlab = "" , ylab = "", col = 'blue4')
            par(new = TRUE)
            plot(x, y4, 'l', ylim = range((c(y3,y4))), axes = TRUE, 
                xlab = "", ylab = "", col = 'firebrick3')
        })

# Set target marker
    # # Read click info BAD due to conflicts
    # zoneLat = reactive({
    #     click = input$Lmap_click
    #     zoneLat = click$lat
    #     return (zoneLat)
    #     })
    # zoneLon = reactive({
    #     click = input$Lmap_click
    #     zoneLon = click$lng
    #     return (zoneLon)
    #     })
    observeEvent(input$Lmap_click, {
    # Read click info
        #print("working")
        click = input$Lmap_click
        zoneLat <<- click$lat
        zoneLon <<- click$lng
        print(paste(zoneLat,zoneLon))
    # Get mode signal
        nowSelectMode = input$switchLmapMarker
        # Update if mode is ON
            if (nowSelectMode) {
                # Get address
                    address <<- revgeocode(c(zoneLon,zoneLat))
                    print(address)
                # use the proxy to save computation
                    leafletProxy("Lmap") %>% 
                    addCircles(lng=zoneLon, lat=zoneLat, group='circles',
                                weight=1, radius=100, color='black', fillColor='orange',
                                popup=address, fillOpacity=0.5, opacity=1,
                                layerId = 'dropPin') 
            } else {
            return()
            }
    })

# Draw polygon of transit
    # Get the poly GEOJson
    observeEvent(input$buttonGenZone,{
        transitPolyJson = getWSPolyJson(apiKeyWalkScore, 
                                        zoneLat, zoneLon, 
                                        input$checkboxTransit, 
                                        input$sliderTransitTime)
        write(transitPolyJson, "./data/transitPoly.json")
        transitPolygon = geojson_read("./data/transitPoly.json", what = "sp")
    # Plot map with the above GEOJson
        output$Lmap = renderLeaflet({
            leaflet(transitPolygon) %>% 
            addProviderTiles("Stamen.Watercolor") %>%
            #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
            setView(lng = zoneLon, lat = zoneLat, zoom = 12) %>% 
            addCircles(lng = zoneLon, lat = zoneLat, group='circles',
            weight=1, radius=100, color='black', fillColor='orange',
            popup=address, fillOpacity=0.5, opacity=1,
            layerId = 'transitZone') %>% 
            addPolygons(stroke = FALSE, smoothFactor = 0.5, 
                        fillOpacity = 0.8, group = "ployGroup")
            })
        })
    # Clear the plot for new plot
    observeEvent(input$buttonClearZone, {
        leafletProxy('Lmap') %>% hideGroup("ployGroup")
        })

###################################################### Explore Map Page ######################################################
  
# Initialize Emap
    # Get NYC boros GEOJson.
        nycBoroPoly = geojson_read("./data/neighbourhoods.geojson", what = "sp")
        pal = colorFactor("RdYlBu", nycBoroPoly@data[["neighbourhood_group"]]) 
    # Plot Emap with GEOJson
        output$Emap = renderLeaflet({
            leaflet(nycBoroPoly) %>% 
            addProviderTiles("Stamen.Watercolor", group = "Toner") %>%
            #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
            setView(lng = EmapLng, lat = EmapLat, zoom = 10) %>% 
            addPolygons(stroke = TRUE, weight = 1, smoothFactor = 1, color = "#000000",
                        label= ~stringr::str_c(neighbourhood, ', ', neighbourhood_group),
                        fillColor= ~pal(neighbourhood_group), fillOpacity = 1,
                        group = "Boros",
                        highlightOptions = highlightOptions(
                        color ='#ff0000', opacity = 0.3, weight = 2, fillOpacity = 0.3,
                        bringToFront = TRUE, sendToBack = TRUE))
        })

# Explore mode switch toggle 
    observeEvent(input$switchEmapMarker, {
        if (input$switchEmapMarker) {
            leafletProxy('Emap') %>% hideGroup("Boros")
        } else {
            leafletProxy('Emap') %>% showGroup("Boros")
        }
    })

# Drop pin and get coords
    observeEvent(input$Emap_click, {
        # Read click info
            #print("working")
            click = input$Emap_click
            EmapLat <<- click$lat
            EmapLng <<- click$lng
            print(paste(EmapLat,EmapLng))
        # Get mode signal
            nowEMode = input$switchEmapMarker
            # Update if mode is ON
                if (nowEMode) {
                    # Get address
                        Eaddress <<- revgeocode(c(EmapLng,EmapLat))
                        print(Eaddress)
                    # Update address output
                        output$textEAddress = renderText({ Eaddress })
                    # use the proxy to save computation
                        leafletProxy("Emap") %>% 
                        addCircles(lng=EmapLng, lat=EmapLat, group='circles',
                                    weight=1, radius=100, color='black', fillColor='orange',
                                    popup=Eaddress, fillOpacity=0.5, opacity=1,
                                    layerId = 'dropPin') 
                } else {
                    return()
                }
    })

# Plot graphs upon request 
    observeEvent(input$buttonEmapGenData,{
        # Update address
            output$textEAddress = renderText({ Eaddress })
        # Generate Gauges
            # Get Info
            resultWS = getObjectWS(apiKeyWalkScore, EmapLat, EmapLng)
            # For easier process
            walk = ifelse(is.null(resultWS$walkscore), -1, resultWS$walkscore) 
            bike = ifelse(is.null(resultWS$bike$score), -1, resultWS$bike$score) 
            transit = ifelse(is.null(resultWS$transit$score), 85, resultWS$transit$score)
            # Create DT to store WS
                #tableWS = data.table(type = c('Walk Score','Bike','Transit'),
                #                        amount = c(walk, bike, transit))
            walkWS = data.table(type = c('Walk Score'), amount = c(walk))
            bikeWS = data.table(type = c('Bike Score'), amount = c(bike))
            transit = data.table(type = c('Transit Score'), amount = c(transit))

            # Plot all three Gauges
            output$gaugeWalkScores = renderGvis({
                                    gvisGauge(walkWS, 
                                    options=list(min=0, max=100, greenFrom=70,
                                    greenTo=100, yellowFrom=30, yellowTo=70,
                                    redFrom=0, redTo=30, width=300, height=200))
            })
            output$gaugeBikeScores = renderGvis({
                                    gvisGauge(bikeWS, 
                                    options=list(min=0, max=100, greenFrom=70,
                                    greenTo=100, yellowFrom=30, yellowTo=70,
                                    redFrom=0, redTo=30, width=300, height=200))
            })
            output$gaugeTransitScores = renderGvis({
                                    gvisGauge(transit, 
                                    options=list(min=0, max=100, greenFrom=70,
                                    greenTo=100, yellowFrom=30, yellowTo=70,
                                    redFrom=0, redTo=30, width=300, height=200))
            })

        # Generate PieBreak Down
            # Toulan
            lat = EmapLat
            lon = EmapLng
            limit = 10
            radius = input$sliderRadius
            radius2 = radius + 2500
            apiKey = apiYelp
            # Call API
            pointYelpRestaurant = getYelpCoords("Restaurant", lat, lon, limit, radius, apiKey)
            pointYelpRetail = getYelpCoords("Retail", lat, lon, limit, radius, apiKey)
            pointYelpArts = getYelpCoords("Arts", lat, lon, limit, radius, apiKey)
            pointYelpEducation = getYelpCoords("Education", lat, lon, limit, radius, apiKey)

            cityYelpRestaurant = getYelpCoords("Restaurant", lat, lon, limit, radius2, apiKey)
            cityYelpRetail = getYelpCoords("Retail", lat, lon, limit, radius2, apiKey)
            cityYelpArts = getYelpCoords("Arts", lat, lon, limit, radius2, apiKey)
            cityYelpEducation = getYelpCoords("Education", lat, lon, limit, radius2, apiKey)
            # Store 
            NYCYelp = data.table(type = c('Restaurant','Retail','Arts','Education'),
                            amount = c(24000, 15400, 16300, 18900))
            cityYelp = data.table(type = c('Restaurant','Retail','Arts','Education'),
                            amount = c(cityYelpRestaurant, cityYelpRetail, cityYelpArts, cityYelpEducation))
            pointYelp = data.table(type = c('Restaurant','Retail','Arts','Education'),
                            amount = c(pointYelpRestaurant, pointYelpRetail, pointYelpArts, pointYelpEducation))
            # Plot
            output$pieBreakNYC = renderGvis({ 
                                    gvisPieChart(NYCYelp, options=list(
                                    #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
                                    title='NYC',
                                    legend='none',
                                    pieSliceText='value',
                                    pieHole=0.2))
                                    })
            output$pieBreakCity = renderGvis({ 
                                    gvisPieChart(cityYelp, options=list(
                                    #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
                                    title='Boroughs',
                                    legend='none',
                                    pieSliceText='value',
                                    pieHole=0.2))
                                    })
            output$pieBreakPoint = renderGvis({ 
                                    gvisPieChart(pointYelp, options=list(
                                    #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
                                    title='Pin selected',
                                    legend='none',
                                    pieSliceText='value',
                                    pieHole=0.2))
                                    })

        # Predicted Price
            output$textPricePrediction = renderText({ paste('$',sample(100:300,1))})
    })

} #END OF SERVER -RR