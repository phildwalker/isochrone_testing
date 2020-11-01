# read in x/y coordinates from sample locations
# Sun Nov 01 10:10:29 2020 ------------------------------
library(osrm)
library(sf)
library(tidyverse)

locations <- readxl::read_excel(here::here("data", "RTG_Locations.xlsx")) %>% 
  select(-FIPS) %>% 
  mutate(id = row_number())


myLoc_sf <-
  locations %>% 
  st_as_sf(coords = c("Long", "Lat"), crs = 4326)

# mapview::mapview(myLoc_sf, zcol = "name")

# id = 5
# iso <- osrmIsochrone(loc = myLoc_sf[id,], #c(-79.9093467,36.111545)
#                      returnclass="sf",
#                      breaks = seq(from = 0, to = 20, by = 5),
#                      res = 60)

LocLoop <- unique(myLoc_sf$id)

for (id in LocLoop){
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    print(glue::glue("Isochrones for location id: {id}"))
    iso <- osrmIsochrone(loc = myLoc_sf[id,], 
                         returnclass="sf",
                         breaks = seq(from = 0, to = 20, by = 5),
                         res = 60)
    iso$loc_id = id
    
    dataset<-rbind(dataset, iso)
    rm(iso)
  }
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    print(glue::glue("Isochrones for location id: {id}"))
    iso <- osrmIsochrone(loc = myLoc_sf[id,],
                         returnclass="sf",
                         breaks = seq(from = 0, to = 20, by = 5),
                         res = 60)
    iso$loc_id = id
    
    dataset <- iso
    rm(iso)
  }
}

iso_location <- dataset

save(iso_location, file = here::here("data", "iso_location.rda"))
 




loc_sf <-
  locations %>% 
  left_join(.,myLoc_sf) %>% 
  st_as_sf

save(loc_sf, file = here::here("data", "loc_sf.rda"))


# class(loc_sf)
# mapview::mapview(loc_sf)




