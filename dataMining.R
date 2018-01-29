# Source Yelp and WalkScore
source('helperWalkScore.R')
source('helperYelpSearch.R')
source('global.R')

# Bug test
#airbnbVis[11903:11907, .(Food,yelpDone, walkScore, walkDone)]

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
airbnbVis$crimeCount = rep(-1,nrow(airbnbVis))
airbnbVis$crimeDone = rep(-1,nrow(airbnbVis))
# !!!!!CAREFUL!!!!DO NOT REST!!!!!!!!
# Reload instead

# LOAD
load("./data/airbnbVis_29930.Rda")
load("finalWeather.Rda")

# Jan 28 

apiKeyWalkScore = "a168759358c4ce208525bd3f93add3ba"
apiYelp = "IheKUwPOJ4ZcTTPMokNsIIdGttM2fzskq8hLqyzzNbRsxyOwCOhjULFJrDrfVsjX_tqkz6Ba1sjwIDxnz4Mdp2HyAtPFr9X9cQUoXMkevnVI2Fv-1EQVF1SBf4BvWnYx"
# rr 851d97883c01a58520a845f201b3c328
# gmail 8412c70d89cbac3d039721166ed78575
# rochester walk backup 851d97883c01a58520a845f201b3c328
# mcgill walk backup d524cd1f8d2cd5ec99b2379ce7463301
# sherry mcgill walk backup d524cd1f8d2cd5ec99b2379ce7463301
# andrew cornell 

####Now end at 6854
#i =29931
while (i < 34844) {
  
  # Get lat and lon
  lat = airbnbVis[i, latitude]
  lon = airbnbVis[i, longitude]
  #print (lat)
  #print (lon)
  
  # Yelp
  if (airbnbVis[i, yelpDone] == -1) {
    url1 = getUrlYelp('Food',lat, lon, 10, 250)
    foodResult = yelpResult(url1, apiYelp)
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

save(airbnbVis,file="./data/airbnbVis_yelp_ws_done.Rda")

