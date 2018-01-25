setwd('~/Shiny/rogerPro/')
source('helperWalkScore.R')

library(leaflet)
library(googleway)
library(RCurl)
library(geojsonio)
library(jsonlite)
library(rgdal)
library(shinythemes)
library(shinyWidgets)
library(ggmap)


walkScoreLevel = c("Mars", "Car-Dependent", "Somewhat Walkable", "Very Walkable", "Walker's Paradise")
safetyScoreLevel = c("Real Gangster","Moderate","Pretty Safe","Very Safe","Like a Bank")
foodScoreLevel = c("Starving","Some Choices","Good Selections","Great Varieties","Food Kingdom")
regions = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
roomType = c("Entire home/apt", "Private room", "Shared room")
transitMethods = c("walk","bike","drive","transit")

clat = 40.754539
clng = -73.99669

apiKeyWalkScore = "8412c70d89cbac3d039721166ed78575"
apiKeyGoogleMap = "AIzaSyAg9ptDoLp46EUcAG1ZpRGT6a-PjYMKOzs"

