# Load data
load("./data/finalWeather.Rda")


# Load library
library(shinythemes)	# Select theme
library(emo)			# Emojis
library(leaflet)		# Main map driver
library(shinyWidgets)	# Cool buttons
library(googleVis)		# Graphs
library(ggmap)			# GeoCode
library(RCurl)			# getURL: helperWalkScore.R
library(geojsonio) 		# geojson_read: plot polygon

# Source help functions
source('helperWalkScore.R')


# Preset values
walkScoreLevel = c("Mars", "Car-Dependent", "Somewhat Walkable", "Very Walkable", "Walker's Paradise")
safetyScoreLevel = c("Real Gangster","Moderate","Pretty Safe","Very Safe","Like a Bank")
foodScoreLevel = c("Starving","Some Choices","Good Selections","Great Varieties","Food Kingdom")
regions = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
roomType = c("Entire home/apt", "Private room", "Shared room")
transitMethods = c("walk","bike","drive","transit")
timeRange = c(1:60)

# Global variabls initial values
LmapLat = 40.754539
LmapLng = -73.99669
EmapLat = 40.754539
EmapLng = -73.99669
zoneLat = 40.754539
zoneLon = -73.99669
address = "NYC Data Science Academy"

# Load API keys
apiKeyWalkScore = "c711cb8b9941e688080c11c3bd677d78"
# backup #1 	8412c70d89cbac3d039721166ed78575
# backup #2 	851d97883c01a58520a845f201b3c328
# backup #3 	d524cd1f8d2cd5ec99b2379ce7463301
# backup #4	 	c711cb8b9941e688080c11c3bd677d78
# backup #5		a168759358c4ce208525bd3f93add3ba
