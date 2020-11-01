# Plotting some iso exampes
# Sun Nov 01 13:05:45 2020 ------------------------------

load(file = here::here("data", "iso_location.rda"))
load(file = here::here("data", "loc_sf.rda"))

library(sf)
library(leaflet)
library(tidyverse)

plotID <- 19



# iso_location[iso_location$loc_id %in% plotID, 'max']

steps <- sort(iso_location %>%
                st_drop_geometry() %>% 
                filter(loc_id %in% plotID) %>% 
                pull(max)
              )

iso_location <- cbind(steps = steps[iso_location[['id']]], iso_location)

pal <- colorFactor(viridis::plasma(nrow(iso_location[iso_location$loc_id %in% plotID, ]), direction = -1), 
                   iso_location$steps)


LocPoint <- 
  loc_sf %>% 
  st_drop_geometry() %>% 
  filter(id == plotID)


leaflet() %>% 
  addTiles() %>% 
  addPolygons(data = iso_location[iso_location$loc_id %in% plotID, ],
              weight = .5, 
              color = ~pal(steps)) %>% 
  addLegend(data = iso_location[iso_location$loc_id %in% plotID, ],
            pal = pal, 
            values = ~steps,
            title = 'Drive Time (min.)',
            opacity = 1) %>%
  addMarkers(LocPoint$Long, 
             LocPoint$Lat, 
             popup = LocPoint$Location
             ) %>%
  setView(LocPoint$Long, 
          LocPoint$Lat, 
          zoom = 11)





