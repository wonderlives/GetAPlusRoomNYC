# Source Yelp and WalkScore
source('helperWalkScore.R')
source('helperYelpSearch.R')
source('global.R')


# Initialize file !!!!!CAREFUL!!!!DO NOT REST!!!!!!!!
airbnbVis = fread('./dataset/airbnb_vis.csv')
airbnbVis = airbnbVis[complete.cases(airbnbVis)]
#
airbnbVis$Food = rep(-1,nrow(airbnbVis))
airbnbVis$walkScore = rep(-1,nrow(airbnbVis))
airbnbVis$bikeScore = rep(-1,nrow(airbnbVis))
airbnbVis$transitScore = rep(-1,nrow(airbnbVis))
airbnbVis$yelpDone = rep(-1,nrow(airbnbVis))
airbnbVis$walkDone = rep(-1,nrow(airbnbVis))
# !!!!!CAREFUL!!!!DO NOT REST!!!!!!!!
# Reload instead

# LOAD
load("./data/airbnbVis.Rda")


# Jan 28 
i = 1
while (i < 1000) {
  
  # Get lat and lon
  lat = airbnbVis[i, latitude]
  lon = airbnbVis[i, longitude]
  #print (lat)
  #print (lon)
  
  # Yelp
  if (airbnbVis[i, yelpDone] == -1) {
    url = getUrlYelp('Food',lat, lon, 10, 250)
    foodResult = yelpResult(url, apiYelp)
    airbnbVis[i, Food:=foodResult$total] 
    airbnbVis[i, yelpDone := 1] 
  }
  
  # Walk
  if (airbnbVis[i, walkDone] == -1) {
    url = urlWalkScoreCommon(apiKeyWalkScore, lat, lon)
    result = fromJSON(url)
    
    if (result$status != 1) {
      break
    }
    
    walk = ifelse(is_null(result$walkscore), -1, result$walkscore) 
    bike = ifelse(is_null(result$bike$score), -1, result$bike$score) 
    transit = ifelse(is_null(result$transit$score), -1, result$transit$score)
    
    airbnbVis[i, walkScore:= walk] 
    airbnbVis[i, bikeScore:= bike] 
    airbnbVis[i, transitScore:= transit] 
    airbnbVis[i, walkDone := 1] 
  }
    
  print(paste(i,'th','working has',airbnbVis[i, Food], 'Food',
        airbnbVis[i, walkScore],'Walk',
        airbnbVis[i, bikeScore],'Bike',
        airbnbVis[i, transitScore],'Transit'))
  
  i = i+1
  
}

save(airbnbVis,file="./data/airbnbVis_28.Rda")

