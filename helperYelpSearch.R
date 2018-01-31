# Get Yelp URL address.
getUrlYelp = function(term, lat, lon, limit, radius) {
  yelp = "https://api.yelp.com"
  result = modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, latitude = lat, longitude = lon,
                                 limit = limit,
                                 radius = radius))
  return(result)
}

# Based on location URL
getUrlYelpLoc = function(term, location, limit, radius) {
  yelp = "https://api.yelp.com"
  result = modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, location = location,
                                 limit = limit,
                                 radius = radius))
  return(result)
}

# Return Yelp result.
yelpResult = function(url, apiKey) {
  result = GET(url, add_headers('Authorization' = paste("bearer", apiKey)))
  result = content(result)
  return (result)
  # result$total to get total count.
}

# Return Yelp Total Score based on Coords
getYelpCoords = function(term, lat, lon, limit, radius, apiKey) {
  url = getUrlYelp(term, lat, lon, limit, radius)
  result = result = GET(url, add_headers('Authorization' = paste("bearer", apiKey)))
  result = content(result)
  result = result$total
  return (result)
}

# Return Yelp Total Score based on Coords
getYelpLoc = function(term, location, limit, radius, apiKey) {
  url = getUrlYelpLoc(term, location, limit, radius)
  result = GET(url, add_headers('Authorization' = paste("bearer", apiKey)))
  result = content(result)
  result = result$total
  return (result)
}