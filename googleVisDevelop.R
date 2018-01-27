library(googleVis)


# Data
DT = data.table(type = c('Restaurant','Cafe','Entertainment','Business'),
                amount = c(25, 25, 25, 30))

# Template for Emap Section 1 - Business count
Pie <- gvisPieChart(DT, options=list(
  #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
  title='City popularity',
  legend='type',
  pieSliceText='value',
  pieHole=0.2))
plot(Pie)

# Template for Emap Section 2 - Crime type
Col <- gvisColumnChart(DT, options=list(
  #slices="{4: {offset: 0.2}, 0: {offset: 0.3}}",
  title='City popularity',
  legend='type',
  pieSliceText='value',
  pieHole=0.2))
plot(Col)

#  Template for Emap Section 3 - Walk Score
DT2 = data.table(type = c('Walk Score','Bike','Transit'),
                amount = c(99, 80, 60))
Gauge <-  gvisGauge(DT2, 
                    options=list(min=0, max=100, greenFrom=70,
                                 greenTo=100, yellowFrom=30, yellowTo=70,
                                 redFrom=0, redTo=30, width=400, height=300))
plot(Gauge)


# Remove JS footer
#M <- gvisColumnChart(data, xvar = "", yvar = "", options = list(), chartid)
#M$html$footer <- NULL
#M$html$jsFooter <- NULL
#M$html$caption <- NULL
#print(M,tag = "html" ,file = "M.html") 
#plot(M)