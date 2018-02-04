getClickLatLng = function(click) {

    # Return a vector of lat, lng
        lat <<- click$lat
        lng <<- click$lng
        res = c(lat, lng)
    return (res)
}