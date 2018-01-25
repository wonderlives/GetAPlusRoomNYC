require(tidyverse)
require(httr)

client_id <- "vVeTqC9hHEHclhag6gHlLw"
client_secret <- "duaQ2KnrmguBZ7qXNVGzQT7n5tdpDBQiNhwVcuVj9SkvDpXik2bpp3Q64I5EPyTT"

res <- POST("https://api.yelp.com/oauth2/token",
            body = list(grant_type = "client_credentials",
                        client_id = client_id,
                        client_secret = client_secret))

token <- content(res)$access_token


yelp <- "https://api.yelp.com"
term <- "sports"
location <- "Philadelphia, PA"
categories <- NULL
limit <- 50
radius <- 8000
url <- modify_url(yelp, path = c("v3", "businesses", "search"),
                  query = list(term = term, location = location, 
                               limit = limit,
                               radius = radius))
res <- GET(url, add_headers('Authorization' = paste("bearer", token)))

results <- content(res)