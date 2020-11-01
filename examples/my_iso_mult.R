
library(tidyverse)
library(sf)


myLoc <- tibble(
  name = c("my test loc", "test 2"),
  lat = c(36.111545,36.0910462),
  long = c(-79.9093467,-79.7861952)
) 

myLoc_sf <-
  myLoc %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

loc_list <- list(c(-79.9093467, 36.111545), c(-79.7861952, 36.0910462))


library(osrm)
library(leaflet)


isoc_items <- lapply(loc_list, function(i) {
  iso <- osrmIsochrone(loc = i, breaks = seq(from = 0, to = 15, by = 3))
  iso@data$drive_times <- factor(paste(iso@data$min, "to", iso@data$max, "mins"))
  
  # NAMED LIST OF TWO ITEMS 
  list(iso = iso, factPal = colorFactor(rev(heat.colors(12)), iso@data$drive_times))
})


leaflet()%>%
  addProviderTiles("CartoDB.Positron", group="Greyscale")%>%
  addMarkers(data = spatialdf, lng = spatialdf$Longitude, 
             lat = spatialdf$Latitude, popup = htmlEscape(~`Locate`))%>%
  
  # ITERATE TO ADD POLYGONS
    addPolygons(fill = TRUE, stroke = TRUE, color = "black", 
                fillColor = ~item$factPal(item$iso@data$drive_times), 
                weight = 0.5, fillOpacity = 0.2, data = item$iso, 
                popup = item$iso@data$drive_times, group = "Drive Time")%>%

  addPolygons(fill = TRUE, stroke = TRUE, color = "black", 
              fillColor = ~item$factPal(item$iso@data$drive_times), 
              weight = 0.5, fillOpacity = 0.2, data = item$iso, 
              popup = item$iso@data$drive_times, group = "Drive Time")%>%

addLegend("bottomright", pal = isoc_items[[1]]$factPal, 
          values = isoc_items[[1]]$iso@data$drive_times, title = "Drive Time") 









library(osrm)
library(leaflet)


#Create Isochrone points
iso1 <- osrmIsochrone(loc = c(-79.9093467, 36.111545), breaks = seq(from = 0, to = 15, by = 3))
iso2 <- osrmIsochrone(loc = c(-79.7861952, 36.0910462), breaks = seq(from = 0, to = 15, by = 3)) 


iso <- rbind(iso1, iso2)

#Create Drive Time Interval descriptions
iso@data$drive_times <- factor(paste(iso@data$min, "to", iso@data$max, "mins"))

#Create Colour Palette for each time interval
factPal <- colorFactor(viridis::plasma(nrow(iso), direction = -1), iso@data$drive_times)


#Draw Map
leaflet()%>%
  addProviderTiles("CartoDB.Positron", group="Greyscale")%>%
  # addMarkers(data=spatialdf,lng=spatialdf$Longitude, lat=spatialdf$Latitude, popup = htmlEscape(~`Locate`))%>%
  addPolygons(fill = TRUE, stroke = TRUE, color = "black",fillColor = ~factPal(iso@data$drive_times), weight = 0.5, fillOpacity = 0.2, data=iso, popup = iso@data$drive_times, group = "Drive Time") %>%
  addLegend("bottomright", pal = factPal, values = iso@data$drive_times, title = "Drive Time")  


