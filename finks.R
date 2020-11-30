# building out isochrone for old Finks location
# 1951 Battleground Ave

# Mon Nov 30 08:32:45 2020 ------------------------------


library(osrm)
library(sf)
library(tidyverse)

loc <- tibble(
  name = c("finks"),
  lat = c(36.096871),
  long = c(-79.818173)
)

myLoc_sf <-
  loc %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

# id = 5

# options(osrm.profile = "walk") 

iso <- osrmIsochrone(loc = c(-79.818173,36.096871),
                     returnclass="sf",
                     breaks = seq(from = 0, to = 30, by = 3), #c(0, 2,5,10,30),
                     res = 70)

iso_finks <- iso

save(iso_finks, file = here::here("data", "iso_finks.rda"))
st_write(iso_finks, here::here("data", "finks","isochrones_drive_finks.shp"), delete_dsn = T) #, delete_dsn = T