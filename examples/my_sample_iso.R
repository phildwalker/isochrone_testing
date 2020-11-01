
library(tidyverse)
library(sf)


myLoc <- tibble(
  name = c("my test loc"),
  lat = c(36.111545),
  long = c(-79.9093467)
) 

myLoc_sf <-
  myLoc %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

library(osrm)

iso <- osrmIsochrone(loc = myLoc_sf, #c(-79.9093467,36.111545)
                     returnclass="sf", 
                     breaks = seq(from = 0, to = 60, by = 10),
                     res = 30)

library(leaflet)

# isochrone <- 
#   iso %>% st_as_sf()
# 
# isocords <- apotheke.sf[87,] %>% 
#   st_transform( crs = st_crs(isochrone)) %>% 
  
  
steps <- sort(as.numeric(iso$max))

iso <- cbind(steps = steps[iso[['id']]], iso)
pal <- colorFactor(viridis::plasma(nrow(iso), direction = -1), 
                   iso$steps)

leaflet() %>% 
  addTiles() %>% 
  addPolygons(data = iso,
              weight = .5, 
              color = ~pal(steps)) %>% 
  addLegend(data = iso,
            pal = pal, 
            values = ~steps,
            title = 'Drive Time (min.)',
            opacity = 1) %>%
  addMarkers(myLoc$long, myLoc$lat) %>%
  setView(myLoc$long, myLoc$lat, zoom = 9)









