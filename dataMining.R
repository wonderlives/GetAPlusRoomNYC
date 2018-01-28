# Source Yelp and WalkScore


airbnbVis = fread('./dataset/airbnb_vis.csv')
airbnbVis = airbnbVis[complete.cases(airbnbVis)]

airbnbVis$Food = rep(-1,nrow(airbnbVis))
airbnbVis$walkScore = rep(-1,nrow(airbnbVis))
airbnbVis$bikeScore = rep(-1,nrow(airbnbVis))
airbnbVis$transitScore = rep(-1,nrow(airbnbVis))

i = 0
while (i < 2) {
  
  #Manhatan first
  
  if (airbnbVis[i, Food] != -1) {
    
    
  }
  
  print(airbnbVis[i, Food])
  
  
  i = i+1
}
