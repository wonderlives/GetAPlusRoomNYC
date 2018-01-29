# Just to update crime data

# load library
library(data.table)
library(geosphere)

# load airbnbVis data
load("./data/airbnbVis_crime.Rda")

# load crime data
load("./data/finalCrime.Rda")
load("./data/crimeLonLat.Rda")

# Main
j = 1
range = 500
while (j < 34843) {
  
  if (j == 5000 | j == 10000 | j == 15000 | j == 20000 | j == 25000 | j == 30000) {
    name = paste0("./data/airbnbVis_crime_", j, ".Rda")
    save(airbnbVis, file=name)
  }
  
  if (airbnbVis[j, crimeDone] == 1) {
    j = j + 1
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
  j = j + 1
  
}