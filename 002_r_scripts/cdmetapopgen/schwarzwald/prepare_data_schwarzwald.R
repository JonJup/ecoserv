# -------------------------------------- #
### --- Subset data to Schwarzwald --- ###
# -------------------------------------- #

# date: 09.09.20 + 10. + 11. + 14. + 15. + 23
# Ecoserv CDMetaPOPGEN Schwarzwald 


# setup -------------------------------------------------------------------
pacman::p_load(data.table, gdistance, here, raster, sf, stars, tmap)
setwd(here())

# load data  --------------------------------------------------------------
sites <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")
river <- read_stars("001_raw_data/gewaessernetze/dem_abgeleited/river_network_whole_region.tif")
# river <- raster("001_data/Gewaessernetze/dem_abgeleited/river_network_whole_region.tif")
barri <- st_read("003_processed_data/2020-08-22_all_barriers.gpkg") 

# functions 
source("002_r_scripts/functions/001_function_snap_to_raster_centroid.R")
source("002_r_scripts/functions/002_function_create_barrier_raster.R")


# carpet ------------------------------------------------------------------
# subset sites to schwarwald 
sites <- sites[29:31,]
sites <- st_transform(x = sites, crs = st_crs(river))
barri <- st_transform(x = barri, crs = st_crs(river))
schwarzwald <- st_bbox(sites) * c(1,.998,1.002, 1.002)
schwarzwald <- matrix(nrow = 2, ncol = 2, schwarzwald[c(1,3,2,4)], byrow = T)
schwarzwald <- extent(schwarzwald)
river   <- crop(x = river, schwarzwald)
barri   <- st_crop(barri, schwarzwald)
# tm_shape(river) + tm_raster() +
#         tm_shape(sites) + tm_dots(shape = 21, size = 2) +
#         tm_shape(barri) + tm_dots(col = "score_down", size = 2, shape = 21, palette = "viridis")


# add barrier to raster  --------------------------------------------------
no_river_id <- which(values(river) == 0 | values(river) < 0)
values(river)[no_river_id] <- 0

## -- downstream raster -- ## 
barri_down <- barri
names(barri_down)[2] <- "conductance"

## -- upstream raster -- ## 
barri_up <- barri
names(barri_up)[3] <- "conductance"

raster_barrier_down <- create_barrier_raster(barriers = barri_down, stream_network =  river)
raster_barrier_up   <- create_barrier_raster(barriers = barri_up  , stream_network =  river)


# tm_shape(new_barrier) + tm_raster() +
#         tm_shape(sites) + tm_dots(shape = 21, size = 2) +
#         tm_shape(barri) + tm_dots(col = "conductance", size = 2, shape = 21, palette = "viridis")
# tmap_mode("view")
# tm_shape(raster(new_barrier_transition)) + tm_raster() + 
#         tm_shape(river) + tm_raster() + 
#         tm_shape(sites_sp) + tm_dots()

# gdistance ---------------------------------------------------------------

sites2    <- ptr(points = sites, raster = stars::st_as_stars(raster_barrier_down))
sites_sp  <- as_Spatial(sites2)

transition_up   <- transition(raster_barrier_up, transitionFunction=min, directions=8)
transition_down <- transition(raster_barrier_down, transitionFunction=min, directions=8)

cost_distance_matrix_up                     <- costDistance(x = transition_up,   fromCoords = sites_sp, toCoords = sites_sp)
cost_distance_matrix_down                   <- costDistance(x = transition_down, fromCoords = sites_sp, toCoords = sites_sp)

cost_distance_matrix_up <- cost_distance_matrix_up * 100

fwrite(x = cost_distance_matrix_up,
       file = "003_Programme/CDMetaPOP/ecoserv_data/Schwarzwald_test_run/schwarzwald_cd.csv",
       col.names = F)


# plot(raster(new_barrier_transition))
# plot(sites_sp, add =T )
# plot(sites, add =T )
# plot(new_barrier)
# plot(river)
# tm_shape(river) + tm_raster() + tm_shape(sites) + tm_dots(size = .5)
# tm_shape(raster(new_barrier_transition)) + tm_raster() + tm_shape(sites_sp) + tm_dots(size = .5)

# save raster in asc file format  --------------------------------------
# give new name 
# writeRaster(x = river,       filename = paste0("001_data/UNICOR/Schwarzwald/",Sys.Date(), "_river_network_schwarzwald.asc"))
# writeRaster(x = flowa,       filename = paste0("001_data/UNICOR/Schwarzwald/",Sys.Date(), "_flow_accumulation_schwarzwald.asc"))
# writeRaster(x = new_barrier, filename = paste0("001_data/UNICOR/Schwarzwald/",Sys.Date(), "_barriers_schwarwald.asc"))
# 
# # save sites in xy file format  -------------------------------------------
# out_file <- data.frame(
#         X = st_coordinates(sites)[,1],
#         Y = st_coordinates(sites)[,2])
# write.table(x = out_file, 
#             file = paste0("001_data/UNICOR/Schwarzwald/", Sys.Date(), "_SchwarzwaldSites.xy"),
#             sep = ",",
#             row.names = F)
if (readline ("Remove all? ") == "yes") rm(list = ls())
