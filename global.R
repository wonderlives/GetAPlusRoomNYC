#shinyWidgets::shinyWidgetsGallery()

setwd('~/Shiny/rogerPro/')
source('helperWalkScore.R')
source('helperYelpSearch.R')
source('serverFunction.R')
#source('dataPreparation.R')

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
library(data.table)
library(dplyr)

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

address = "dd"

apiKeyWalkScore = "8412c70d89cbac3d039721166ed78575"
# above gmail
# rochester walk backup 851d97883c01a58520a845f201b3c328
# mcgill walk backup d524cd1f8d2cd5ec99b2379ce7463301
# sherry mcgill walk backup d524cd1f8d2cd5ec99b2379ce7463301
apiKeyGoogleMap = "AIzaSyAg9ptDoLp46EUcAG1ZpRGT6a-PjYMKOzs"
apiYelp = "M_z7AxjPGd3AXpUM6oBMni2eDekv7ILwtDGUpPXVrpvDhjGoAjTOUiHHg2Qk4sBFCuz6W9lwVYBDHV9UFgs-LVk7tbV0C45mYSu6VVXZ-N_bGWJTBNdFEMREHUdoWnYx"

