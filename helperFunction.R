#shinyWidgets::shinyWidgetsGallery()

urlWalkScore = function(apiKey, lat, lon, mode, time) {
  baseDomain = "http://api2.walkscore.com/api/v1/traveltime_polygon/json?wsapikey="
  result = paste0(baseDomain,apiKey,"&origin=",lat,"%2C",lon,"8&mode=",mode,"&time=",time)
  return (result)
}

parseJsonToString = function(url) {
  rawString = getURL(url) 
  # Parse
  head = regexpr('metry\":', rawString)
  startIndex = head[1] + attr(head,"match.length")
  toe = regexpr(',\"mode\"', rawString)
  endIndex = toe[1] - 1
  goodString = substr(rawString, startIndex, endIndex)
  return (goodString)
}


