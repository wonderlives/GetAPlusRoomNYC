# This part is to clean weather data.
weatherRawData = fread('./dataset/weather.csv')
colnames(weatherRawData)
colnames(weatherRawData) = c("date", "averageLow", "averageHigh", "recordLow", "recordHigh", "averagePrecip")

weatherRawData[, averageLow := as.numeric(substr(averageLow,0,2))]
weatherRawData[, averageHigh := as.numeric(substr(averageHigh,0,2))]
weatherRawData[, averagePrecip := as.numeric (substr(averagePrecip,0,4))]
weatherRawData[, recordHigh := as.numeric(sub(pattern = "\\D.+$", "", recordHigh))] 
weatherRawData[, recordLow := as.numeric(sub(pattern = "\\D.+$", "", recordLow))]
weatherRawData[, dateR := as.Date(date, "%d-%b")]
weatherRawData[, dateS := dates]
weatherRawData[, dateR := substr(dateR,6,10)]
weatherRawData[, date := format(as.Date(date, "%d-%b"), format = "%m-%d")]


save(weatherRawData,file='./data/finalWeather.Rda')
write(weatherRawData, './data/finalWeather.Rda')
dates <- seq(as.Date("01/01/2016", format = "%d/%m/%Y"),
             by = "days", length = weatherRawData[,.N])
matplot(dates, c(weatherRawData[, averageLow], weatherRawData[, averageHigh]), 'l')
weatherRawData
library(plotly)

p = plot_ly(weatherRawData, x = ~dateR, y = ~c("averageLow", "averageHigh", "recordHigh", "recordLow", "averagePrecip"),type = 'scatter', mode = 'lines')

ggplot(weatherRawData, aes(x=dateR,y=averageLow) + geom_point())
plot()
# Load library
library(googleVis)
graph = gvisLineChart(weatherRawData, xvar = 'dateS', 
                      yvar = c("averageLow", "averageHigh", "recordHigh", "recordLow"),
                      options = list(
                      width=1600, height= 1600,
                      legend = {"position: 'bottom'"},
                      #titleTextStyle="{color:'red', fontName:'Courier', fontSize:16}",
                      #colors="['#cbb69d', '#603913', '#c69c6e']",
                      hAxis='{title: "Date"}',
                      hAxis="{format: 'MMM d, y'}",
                      #vAxis="{title:'Temperatures (F)'}",
                      vAxes="[{title:'Temperatures (F)',
                             format:'####',
                      titleTextStyle: {color: 'black'},
                      textStyle:{color: 'blue'},
                      textPosition: 'out'}]", 
                      axisTitlesPosition = 'out',
                      #vAxis="{title:'Temperature (F)'}",
                      
                      #vAxis="{viewWindow.max: '100'}",
                      
                      #vAxis="{minValue: '-20'}"
                      )
                      )


plot(graph)


# PLotly
library(plotly)

x <- c(1:100)
random_y <- rnorm(100, mean = 0)
data <- data.frame(x, random_y)

p <- plot_ly(data, x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = plotly_POST(p, filename="line/basic")
chart_link
