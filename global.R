setwd('~/Shiny/rogerPro/')

library(leaflet)
library(googleway)
library(RCurl)
library(geojsonio)
library(jsonlite)
library(rgdal)
library(shinythemes)
library(shinyWidgets)


walkScoreLevel = c("Mars", "Car-Dependent", "Somewhat Walkable", "Very Walkable", "Walker's Paradise")
safetyScoreLevel = c("Real Gangster","Moderate","Pretty Safe","Very Safe","Like a Bank")
foodScoreLevel = c("Starving","Some Choices","Good Selections","Great Varieties","Food Kingdom")
regions = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
roomType = c("Entire home/apt", "Private room", "Shared room")

