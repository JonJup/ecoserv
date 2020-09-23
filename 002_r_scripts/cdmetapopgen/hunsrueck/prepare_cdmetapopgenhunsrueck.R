# --------------------------------- #
### -------- CDMetaPOPGEN ------- ###
### --- Prepare Hunrueck data --- ###
# --------------------------------- #


# date written: 23.09.20 
# date changed:
# date used   :   
# Project: Ecoserv 
# Jonathan Jupke 
# Prepare data for CDMetaPopGen modelling of Hunsrueck sites. 


# setup -------------------------------------------------------------------
pacman::p_load(data.table, gdistance, here, raster, sf, stars, tmap)
setwd(here())


# load data ---------------------------------------------------------------
sites <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")
barri <- st_read("003_processed_data/2020-08-22_all_barriers.gpkg") 
river <- raster("001_raw_data/gewaessernetze/dem_abgeleited/river_network_whole_region.tif")

# functions 
source("002_r_scripts/functions/001_function_snap_to_raster_centroid.R")
source("002_r_scripts/functions/002_function_create_barrier_raster.R")


# carpet ------------------------------------------------------------------
# subset sites to Hunsrueck
sites <- sites[9:15,]
sites <- st_transform(x = sites, crs = st_crs(river))
barri <- st_transform(x = barri, crs = st_crs(river))
hunsrueck <- st_bbox(sites) * c(.5,.5,2,2)
hunsrueck <- matrix(nrow = 2, ncol = 2, hunsrueck[c(1,3,2,4)], byrow = T)
hunsrueck <- extent(hunsrueck)
river   <- raster::crop(x = river, hunsrueck)
barri   <- st_crop(barri, hunsrueck)
tmap_mode("view")
tm_shape(river) + tm_raster() +
        tm_shape(sites) + tm_dots(shape = 21, size = 2) +
        tm_shape(barri) + tm_dots(col = "score_down", size = 2, shape = 21, palette = "viridis")
