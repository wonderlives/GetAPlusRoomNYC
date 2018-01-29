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
crimeLonLat = matrix(data = c(crimeDT$Longitude, crimeDT$Latitude), ncol = 2)

# Too many data points, 30s to run a test

crimeDT_Reduce = crimeDT
crimeDT_Reduce[,Longitude:= round(Longitude, 3)]
crimeDT_Reduce[,Latitude:= round(Latitude, 3)]
finalCrime = crimeDT_Reduce[,.N,by = .(Longitude,Latitude)] #from 401K to 40K
crimeLonLat = matrix(data = c(finalCrime$Longitude, finalCrime$Latitude), ncol = 2)

save(finalCrime,file="./data/finalCrime.Rda")
save(crimeLonLat,file="./data/crimeLonLat.Rda")


save(airbnbVis,file="./data/airbnbVis_28.Rda")

#######
#airbnbVis$crimeCount = rep(-1,nrow(airbnbVis))
#airbnbVis$crimeDone = rep(-1,nrow(airbnbVis))
########
# test 

j = 1
range = 500
while (j < 10000) {
  j = j + 1
  if (airbnbVis[j, crimeDone] == 1) {
    next
  }
  target = c(airbnbVis[j, longitude], airbnbVis[j, latitude])
  dist = distm(x = crimeLonLat, y = target, fun = distVincentySphere)
  dist = c(dist)
  filerCrimeInRange =finalCrime[(dist <= range), ]
  result =  sum(filerCrimeInRange$N)
  
  airbnbVis[j, crimeCount:=result]
  airbnbVis[j, crimeDone:=1]
  
  print(paste(j,'th','working has',result, 'crimes around'))
  
  
}
########
address_latlon <- geocode('nyc data science academy')
apt_reactive <- reactive({ 
  address_latlon <- geocode(input$userlocation)
  dist <- distm(x = matrix(data = c(df.apt$lon, df.apt$lat), ncol = 2), 
                y = c(lon = address_latlon$lon, lat = address_latlon$lat), 
                fun = distVincentySphere)
  apt.df[dist < input$distancia,]
})
########

# Airbnb VIS data
airbnbVis = fread('./dataset/airbnb_vis.csv')
airbnbVis = airbnbVis[complete.cases(airbnbVis)]


# Airbnb



# Map for airbnb
#pal_here = colorFactor("RdYlBu", airbnbVis$room_type)
pal_here = colorFactor(c("red", "green", "blue"), airbnbVis$room_type)

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



