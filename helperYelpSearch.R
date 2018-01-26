# Get Yelp URL address.
getUrlYelp = function(term, lat, lon, limit, radius) {
  yelp = "https://api.yelp.com"
  result = modify_url(yelp, path = c("v3", "businesses", "search"),
                    query = list(term = term, latitude = lat, longitude = lon,
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
