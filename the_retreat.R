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
                     breaks = seq(from = 0, to = 30, by = 1), #c(0, 2,5,10,30),
                     res = 60)

iso_drive <- iso

save(iso_drive, file = here::here("data", "iso_drive.rda"))
st_write(iso_drive, here::here("data", "drive_richardson","isochrones_drive_richardson.shp"), delete_dsn = T) #, delete_dsn = T

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
  setView(loc$long, loc$lat, zoom = 9)