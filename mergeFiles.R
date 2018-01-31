load("./data/airbnbVis_FINALFINALDONE_29.Rda")
load("./data/airbnbVis_crime_DONE.Rda")
yelpWS = airbnbVis
airbnbVis[.N-4,]
airbnbVis[.N, crimeCount := 100]
crime = airbnbVis
yelpWS[(.N-4),]
crime[.N,]

yelpWS[, crimeCount :=crime[, crimeCount]]
yelpWS[, crimeDone :=crime[, crimeDone]]

finalDataJan30 = yelpWS

save(finalDataJan30,file='./data/finalDataJan30.Rda')

hist(finalDataJan30[, crimeCount])
hist(finalDataJan30[, Food])
hist(finalDataJan30[, walkScore])
hist(finalDataJan30[, transitScore])
hist(finalDataJan30[, bikeScore])
