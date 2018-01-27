#shinyWidgets::shinyWidgetsGallery()

setwd('~/Shiny/rogerPro/')
source('helperWalkScore.R')
source('helperYelpSearch.R')
source('serverFunction.R')

library(leaflet)
library(googleway)
library(RCurl)
library(geojsonio)
library(jsonlite)
library(rgdal)
library(shinythemes)
library(shinyWidgets)
library(ggmap)
library(tidyverse)
library(httr)
library(emo)

walkScoreLevel = c("Mars", "Car-Dependent", "Somewhat Walkable", "Very Walkable", "Walker's Paradise")
safetyScoreLevel = c("Real Gangster","Moderate","Pretty Safe","Very Safe","Like a Bank")
foodScoreLevel = c("Starving","Some Choices","Good Selections","Great Varieties","Food Kingdom")
regions = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
roomType = c("Entire home/apt", "Private room", "Shared room")
transitMethods = c("walk","bike","drive","transit")

LmapLat = 40.754539
LmapLng = -73.99669

EmapLat = 40.754539
EmapLng = -73.99669

apiKeyWalkScore = "8412c70d89cbac3d039721166ed78575"
apiKeyGoogleMap = "AIzaSyAg9ptDoLp46EUcAG1ZpRGT6a-PjYMKOzs"
apiYelp = "M_z7AxjPGd3AXpUM6oBMni2eDekv7ILwtDGUpPXVrpvDhjGoAjTOUiHHg2Qk4sBFCuz6W9lwVYBDHV9UFgs-LVk7tbV0C45mYSu6VVXZ-N_bGWJTBNdFEMREHUdoWnYx"

