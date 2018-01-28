setwd('~/Shiny/rogerPro/')
library(data.table)
library(plotly)

# Crime data
crimeDT = fread('./dataset/NYPD_Complaint_Data_Current_YTD.csv')
crimeDT = crimeDT[complete.cases(crimeDT)]
#crimeDT[is.finite(rowSums(crimeDT))]
crimeDT[, c("CMPLNT_FR_TM","CMPLNT_TO_DT","CMPLNT_TO_TM","RPT_DT",
            "CRM_ATPT_CPTD_CD", "JURIS_DESC", "ADDR_PCT_CD",
            "LOC_OF_OCCUR_DESC", "PREM_TYP_DESC", "PARKS_NM",
            "HADEVELOPT","Lat_Lon") := NULL]

# Airbnb VIS data
airbnbVis = fread('./dataset/airbnb_vis.csv')
airbnbVis = airbnbVis[complete.cases(airbnbVis)]


# Airbnb



# Get a map
#pal_here = colorFactor("RdYlBu", airbnbVis$room_type)
pal_here = colorFactor(c("red", "green", "blue"), airbnbVis$room_type)

leaflet() %>% 
  addProviderTiles("Stamen.Watercolor") %>%
  #addLegend(position = "bottomleft", pal = groupColors, values = room, opacity = 1, title = "Room Type") %>% 
  setView(lng = -73.9772, lat = 40.7527, zoom = 12) %>% 
  addCircleMarkers(lng = airbnbVis$longitude, lat = airbnbVis$latitude,
                   opacity = 0.5,color = pal_here(airbnbVis$room_type), radius = 1, group = "CIRCLE")

#Second approach
roomTypes = as.character(unique(airbnbVis$room_type))

visMap = leaflet(airbnbVis) %>% addProviderTiles("Stamen.Watercolor")

for (roomType in roomTypes) {
  data = airbnbVis[room_type == roomType,]
  visMap = visMap %>% addCircleMarkers(data = data, lng = ~longitude, lat = ~latitude,
                                       opacity = 1,color =  ~pal_here(room_type), radius = 2,
                                       group = roomType, stroke = FALSE)
}

visMap %>% addLayersControl(overlayGroups = roomTypes) %>% 
  addLegend("bottomright", pal = pal_here, values = ~room_type,
            title = "Room Type",
            #labFormat = labelFormat(prefix = "$"),
            opacity = 1)



