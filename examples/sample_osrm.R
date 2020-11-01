# playing with osrm
# Sun Nov 01 10:20:48 2020 ------------------------------


# install.packages("osrm")
# remotes::install_github("rCarto/osrm")
# install.packages("cartography")

library(osrm)
library(sf)
library(cartography)
data("berlin")

# options(osrm.server = "http://router.project-osrm.org/", osrm.profile = "driving")

iso <- osrmIsochrone(loc = apotheke.sf[87,], returnclass="sf",
                     breaks = seq(from = 0, to = 14, by = 2), res = 50)
osm3 <- getTiles(x = iso, crop = FALSE, type = "osm", zoom = 12)
tilesLayer(x = osm3)
bks <- sort(c(unique(iso$min), max(iso$max)))
cols <- paste0(carto.pal("turquoise.pal", n1 = length(bks)-1), 80)
choroLayer(x = iso, var = "center", breaks = bks,
           border = NA, col = cols,
           legend.pos = "topleft",legend.frame = TRUE,
           legend.title.txt = "Isochrones\n(min)",
           add = TRUE)
plot(st_geometry(apotheke.sf[87,]), pch = 21, bg = "red", 
     cex = 1.5, add=TRUE)



library(leaflet)

isochrone <- 
  iso %>% st_as_sf()

isocords <- apotheke.sf[87,] %>% 
  st_transform( crs = st_crs(isochrone)) %>% 
  

steps <- sort(as.numeric(isochrone$max))
isochrone <- cbind(steps = steps[isochrone[['id']]], isochrone)
pal <- colorFactor(viridis::plasma(nrow(isochrone), direction = -1), 
                   isochrone$steps)

leaflet() %>% 
  addTiles() %>% 
  addPolygons(data = isochrone,
              weight = .5, 
              color = ~pal(steps)) %>% 
  addLegend(data = isochrone,
            pal = pal, 
            values = ~steps,
            title = 'Drive Time (min.)',
            opacity = 1) %>%
  # addMarkers(lng = input$lon, input$lat) %>%
  setView(isocords, zoom = 9)


#------------------


library(osrm)
#> Data: (c) OpenStreetMap contributors, ODbL 1.0 - http://www.openstreetmap.org/copyright
#> Routing: OSRM - http://project-osrm.org/
library(sp)
x <- osrmIsochrone(loc = c(-95.9345,41.2565), breaks = c(10,20))
#> Linking to GEOS 3.7.1, GDAL 2.4.0, PROJ 5.2.0
plot(x)




