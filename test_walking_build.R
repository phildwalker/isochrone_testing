library(osrm)
library(sf)
library(tidyverse)

loc <- tibble(
  name = c("old richardson hosp"),
  lat = c(36.06832000),
  long = c(-79.77018000)
)

myLoc_sf <-
  loc %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

# id = 5

options(osrm.profile = "walk") 

iso <- osrmIsochrone(loc = c(-79.77018000,36.06832000),
                     returnclass="sf",
                     breaks = c(2,5,10,30),
                     res = 60)


