

client_id <- "HmUBycKgID4PiWHAM3Cb7A"
# choice1 vVeTqC9hHEHclhag6gHlLw
# choice2 HmUBycKgID4PiWHAM3Cb7A
client_secret <- "Xl5eB9Hb7fS9TZL4Ndma9WkVyI1osIIp3yXkKpRYxGLgG6Bt0aj3PW1wpc39G5nG"
# choice1 duaQ2KnrmguBZ7qXNVGzQT7n5tdpDBQiNhwVcuVj9SkvDpXik2bpp3Q64I5EPyTT
# choice2 Xl5eB9Hb7fS9TZL4Ndma9WkVyI1osIIp3yXkKpRYxGLgG6Bt0aj3PW1wpc39G5nG

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
