# The Retreat --------
# Tue Nov 10 17:21:07 2020 ------------------------------


library(osrm)
library(sf)
library(tidyverse)

loc <- tibble(
  name = c("the retreat"),
  lat = c(36.140114),
  long = c(-79.97304)
)

myLoc_sf <-
  loc %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

# id = 5

# options(osrm.profile = "walk") 

iso <- osrmIsochrone(loc = c(-79.97304,36.140114),
                     returnclass="sf",
                     breaks = seq(from = 0, to = 45, by = 3), #c(0, 2,5,10,30),
                     res = 50)

iso_the_retreat <- iso

save(iso_the_retreat, file = here::here("data", "iso_the_retreat.rda"))
st_write(iso_the_retreat, here::here("data", "the_retreat","isochrones_drive_the_retreat.shp"), delete_dsn = T) #, delete_dsn = T


library(leaflet)
steps <- sort(as.numeric(iso$max))

iso <- cbind(steps = steps[iso[['id']]], iso)
pal <- colorFactor(viridis::plasma(nrow(iso), direction = -1), 
                   iso$steps)

leaflet() %>% 
  addTiles() %>% 
  addPolygons(data = iso,
              weight = 2, 
              color = ~pal(steps)) %>% 
  addLegend(data = iso,
            pal = pal, 
            values = ~steps,
            title = 'Drive Time (min.)',
            opacity = 1) %>%
  addMarkers(loc$long, loc$lat) %>%
  setView(loc$long, loc$lat, zoom = 10)
