# Developer: Roger Ren (www.linkedin.com/in/xinyuren)
# Version: 2.0
    # Date: Jan 30, 2018
# Version: 1.0
    # Original Date: Jan 23 2018
# ##########################################

server = function(input, output, session) {

###################################################### MultiFunc Map Page ######################################################

# Initialize Lmap
    output$Lmap = renderLeaflet({
        leaflet() %>% 
        addTiles() %>% 
        #addProviderTiles("Stamen.Watercolor") %>%
        #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
        setView(lng = -73.9772, lat = 40.7527, zoom = 12)
    })
    #leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>% addTiles()
    
# Temperature Graph.
    # Get the range.
        starEndMonth = reactive({
          start = input$selectMonth[1]
          end = input$selectMonth[2]
          start = match(start,month.abb)
          end = match(end, month.abb)
          df = weatherRawData[((start-1)*30+1):((end-1)*30+30), ]
          print(paste(start, end, (start-1)*30+1, (end-1)*30))
          return (df)
        })
    # DEBUG STEP
        output$testEvent = renderPrint({
          df = starEndMonth()
          print ('working')
          print (class(df))
        })
    # Plot graph
        output$tempAvg = renderPlot({
            x = starEndMonth()$dateR
            y1 = starEndMonth()$averageLow
            y2 = starEndMonth()$averageHigh
            y3 = starEndMonth()$recordLow
            y4 = starEndMonth()$recordHigh
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
        }
        )
            # The following code was discarded due to better choice above.
            # output$tempAvg = renderGvis({
            # gvisLineChart(starEndMonth(), xvar = 'dateS', 
            # yvar = c("averageLow", "averageHigh", "recordHigh", "recordLow"),
            # options = list(
            # width=300, height= 400,
            # legend = {"position: 'bottom'"},
            # #titleTextStyle="{color:'red', fontName:'Courier', fontSize:16}",
            # #colors="['#cbb69d', '#603913', '#c69c6e']",
            # hAxis='{title: "Date"}',
            # hAxis="{format: 'MMM d, y'}",
            # #vAxis="{title:'Temperatures (F)'}",
            # vAxes="[{title:'Temperatures (F)',
            # format:'####',
            # titleTextStyle: {color: 'black'},
            # textStyle:{color: 'blue'},
            # textPosition: 'out'}]"
            # #vAxis="{title:'Temperature (F)'}",
            # #vAxis="{viewWindow.max: '100'}",
            # #vAxis="{minValue: '-20'}"
            # ))})
            # END of this back up choice section
    
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
    # Get the poly GEOJson
    observeEvent(input$generateTransitPolygon,{
        urlWalkScore = urlWalkScore(apiKeyWalkScore, LmapLat, LmapLng, input$chooseTransitMethod, input$sliderTransitTime)
        goodString = parseJsonToString(urlWalkScore)
        write(goodString, "./data/transitPoly.json")
        transitPolygon = geojson_read("./data/transitPoly.json", what = "sp")
    # Plot map with the above GEOJson
    output$Lmap = renderLeaflet({
        leaflet(transitPolygon) %>% 
        addProviderTiles("Stamen.Watercolor") %>%
        #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
        setView(lng = -73.9772, lat = 40.7527, zoom = 12) %>% 
        addCircles(lng=LmapLng, lat=LmapLat, group='circles',
        weight=1, radius=100, color='black', fillColor='orange',
        popup=address, fillOpacity=0.5, opacity=1,
        layerId = 'target') %>% 
        addPolygons(stroke = FALSE, smoothFactor = 0.5, fillOpacity = 0.8)
        })
    })
  


###################################################### Explore Map Page ######################################################
  
# Initialize Emap
    # Get NYC boros GEOJson.
        nyc_code = geojson_read("./data/neighbourhoods.geojson", what = "sp")
        pal = colorFactor("RdYlBu", nyc_code@data[["neighbourhood_group"]]) 
    # Plot Emap with GEOJson
        output$Emap = renderLeaflet({
            leaflet(nyc_code) %>% 
            addProviderTiles("Stamen.Watercolor", group = "Toner") %>%
            #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
            setView(lng = -73.9772, lat = 40.7527, zoom = 12) %>% 
            addPolygons(stroke = TRUE, weight = 1, smoothFactor = 1, color = "#000000",
                        label= ~stringr::str_c(neighbourhood, ', ', neighbourhood_group),
                        fillColor= ~pal(neighbourhood_group), fillOpacity = 1,
                        group = "Boros",
                        highlightOptions = highlightOptions(
                        color ='#ff0000', opacity = 0.3, weight = 2, fillOpacity = 0.3,
                        bringToFront = TRUE, sendToBack = TRUE))
        })
# Explore mode switch toggle. 
    observeEvent(input$EMapSwitch, {
        if (input$EMapSwitch) {
            leafletProxy('Emap') %>% hideGroup("Boros")
        } else {
            leafletProxy('Emap') %>% showGroup("Boros")
        }
    })
  
#################################
DT = data.table(type = c('Restaurant','Cafe','Entertainment','Business'),
          amount = c(25, 25, 25, 30))
  
  output$plotgraph1 = renderGvis({ 
  gvisPieChart(DT, options=list(
    #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
    title='City popularity',
    legend='type',
    pieSliceText='value',
    pieHole=0.2))
  #plot(Pie)
  })
  
  output$plotgraph2 = renderGvis({
  gvisColumnChart(DT, options=list(
    #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
    title='City popularity',
    legend='type',
    pieSliceText='value',
    pieHole=0.2))
   
  })
  
  DT2 = data.table(type = c('Walk Score','Bike','Transit'),
           amount = c(99, 80, 60))
  
  output$plotgraph3 = renderGvis({
  gvisGauge(DT2, 
        options=list(min=0, max=100, greenFrom=70,
               greenTo=100, yellowFrom=30, yellowTo=70,
               redFrom=0, redTo=30, width=400, height=300))
  })
####################################

  
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
      currCity = strsplit(address, "\\, ")[[1]][2]
      print(address)
      print(currCity)
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
      #############SMALL GRAPHS PART##################

    
      ######## Crime data add-on test, FAILED, too many points ######
      #%>% 
      #  addCircleMarkers(
      #    lat = crimeDT$Latitude,
      #    lng = crimeDT$Longitude,
      #    radius = 1,
      #    #color = ~pal(type),
      #    stroke = FALSE, fillOpacity = 0.5)
      ######## End of the test! ##########
    } else {
      return()
    }
  })
}