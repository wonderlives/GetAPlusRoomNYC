# Load data
#setwd("~/Shiny/rogerPro/")
load("data/finalWeather.Rda")
load("data/finalAirBnBdata.Rda")

# Load library
library(shinythemes)	# Select theme
library(emo)			# Emojis
library(leaflet)		# Main map driver
library(shinyWidgets)	# Cool buttons
library(googleVis)		# Graphs
library(ggmap)			# GeoCode
library(RCurl)			# getURL: helperWalkScore.R
library(geojsonio) 		# geojson_read: plot polygon
library(jsonlite)		# readJSON in gauge
library(data.table)		# Main data framework
library(httr)			# Yelp helper
library(leaflet.extras) # cool effects
library(dplyr) 			# Process AirBnB data
library(googleway)		# Decode GoogleWay


# Source help functions
source('helperWalkScore.R')
source('helperYelpSearch.R')


# Preset values
walkScoreLevel = c("Mars", "Car-Dependent", "Somewhat Walkable", "Very Walkable", "Walker's Paradise")
safetyScoreLevel = c("Real Gangster","Moderate","Pretty Safe","Very Safe","Like a Bank")
foodScoreLevel = c("Starving","Some Choices","Good Selections","Great Varieties","Food Kingdom")
regions = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
roomType = c("Entire home/apt", "Private room", "Shared room")
transitMethods = c("walk","bike","drive","transit")
timeRange = c(1:60)
#foodPercentile = c(0,29,57,112,502)
foodPercentile = c(0,20,57,110,300)
#crimePercentile = c(1.0,801.0,1213.0,1867.5,6485.0 )
crimePercentile = c(6485,2500,1300,900,400)

# Global variabls initial values
originLat = 40.754539
originLng = -73.99669
LmapLat = 40.754539
LmapLng = -73.99669
EmapLat = 40.754539
EmapLng = -73.99669
zoneLat = 40.754539
zoneLon = -73.99669
address = "500 8th Ave #905, New York, NY 10018"
Eaddress = "500 8th Ave #905, New York, NY 10018"

# Load API keys
apiKeyWalkScore = "c711cb8b9941e688080c11c3bd677d78"
# backup #1 	8412c70d89cbac3d039721166ed78575
# backup #2 	851d97883c01a58520a845f201b3c328
# backup #3 	d524cd1f8d2cd5ec99b2379ce7463301
# backup #4	 	c711cb8b9941e688080c11c3bd677d78
# backup #5		a168759358c4ce208525bd3f93add3ba
apiKeyGoogleMap = "AIzaSyAg9ptDoLp46EUcAG1ZpRGT6a-PjYMKOzs"
#apiYelp = "M_z7AxjPGd3AXpUM6oBMni2eDekv7ILwtDGUpPXVrpvDhjGoAjTOUiHHg2Qk4sBFCuz6W9lwVYBDHV9UFgs-LVk7tbV0C45mYSu6VVXZ-N_bGWJTBNdFEMREHUdoWnYx"
apiYelp = "IheKUwPOJ4ZcTTPMokNsIIdGttM2fzskq8hLqyzzNbRsxyOwCOhjULFJrDrfVsjX_tqkz6Ba1sjwIDxnz4Mdp2HyAtPFr9X9cQUoXMkevnVI2Fv-1EQVF1SBf4BvWnYx"
