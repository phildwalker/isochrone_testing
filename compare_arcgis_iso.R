# comparing Bill's arcgis version vs the one I created with OSM (demo server)
# Fri Nov 06 13:38:09 2020 ------------------------------

library(sf)
library(leaflet)
library(tidyverse)


iso_arcgis <- 
  st_read(here::here("data", "driving_old_richardson","drive_time_2_5_10_30_120_mins.shp")) %>% 
  st_transform( crs = 4326)


iso_osrm <- 
  st_read(here::here("data", "drive_richardson","isochrones_drive_richardson.shp")) %>% 
  st_transform( crs = 4326)


