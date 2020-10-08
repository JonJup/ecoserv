# --------------------------------- #
### -------- CDMetaPOPGEN ------- ###
### --- Prepare Hunrueck data --- ###
### --- null model -------------- ### 
# --------------------------------- #


# date written:  08.10 
# date changed: 
# date used   : 
# Project: Ecoserv 
# Jonathan Jupke 
# Prepare data for CDMetaPopGen modeling of Hunsrueck sites. This script create
# a null-model in which all barriers have a passability of 1. This will help me
# understand how the barrier values influence the effective distance.

# setup -------------------------------------------------------------------
pacman::p_load(
        data.table, 
        gdistance, 
        here, 
        raster, 
        sf, 
        stars, 
        tmap
        )
setwd(here())

# load data ---------------------------------------------------------------
sf_sites <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")
sf_barri <- st_read("003_processed_data/2020-08-22_all_barriers.gpkg") 
ra_river <- raster("001_raw_data/gewaessernetze/dem_abgeleited/river_network_whole_region.tif")

# functions 
source("002_r_scripts/functions/001_function_snap_to_raster_centroid.R")
source("002_r_scripts/functions/002_function_create_barrier_raster.R")

# inspect files 
# tmap_mode("view")
# tm_shape(ra_river) + tm_raster() + 
#         tm_shape(sf_sites) + tm_dots(col = "green") + 
#         tm_shape(sf_barri) + tm_dots(col = "grey")

# carpet ------------------------------------------------------------------
# set all passabilities to 1 
sf_barri$score_down <- 1 
sf_barri$score_up <- 1 
# subset sites to Hunsrueck
sf_sub_sites       <- sf_sites[9:15,]
sf_sub_sites_trans <- st_transform(x = sf_sub_sites, crs = st_crs(ra_river))
sf_barri_trans     <- st_transform(x = sf_barri    , crs = st_crs(ra_river))

rm(sf_sub_sites, sf_sites, sf_barri);gc()

vec_hunsrueck <- st_bbox(sf_sub_sites_trans) * c(.99,.99,1.01,1.01)
mat_hunsrueck <- matrix(nrow = 2, ncol = 2, vec_hunsrueck[c(1,3,2,4)], byrow = T)
ext_hunsrueck <- extent(mat_hunsrueck) 
rm(vec_hunsrueck, mat_hunsrueck);gc()

ra_river_cropped        <- raster::crop(x = ra_river, ext_hunsrueck)
sf_barri_trans_cropped  <- st_crop(sf_barri_trans, ext_hunsrueck)

rm(ra_river, ext_hunsrueck, sf_barri_trans);gc()

#tm_shape(ra_river_cropped) + tm_raster() +
#        tm_shape(sf_sub_sites_trans) + tm_dots(shape = 21, size = 2) +
#        tm_shape(sf_barri_trans_cropped) + tm_dots(col = "score_down", size = 2, shape = 21, palette = "viridis", alpha = 0.3)

# add barrier to raster 
no_river_id <- which(values(ra_river_cropped) == 0 | values(ra_river_cropped) < 0)
values(ra_river_cropped)[no_river_id] <- 0

## -- downstream raster -- ## 
sf_barri_down <- sf_barri_trans_cropped
names(sf_barri_down)[2] <- "conductance"
## -- downstream raster -- ## 
sf_barri_up <- sf_barri_trans_cropped
names(sf_barri_up)[3] <- "conductance"

rm(sf_barri_trans_cropped);gc()

ra_barrier_down <- create_barrier_raster(barriers = sf_barri_down, stream_network =  ra_river_cropped)
ra_barrier_up   <- create_barrier_raster(barriers = sf_barri_up  , stream_network =  ra_river_cropped)
rm(create_barrier_raster)
## -- save to file -- ## 
#saveRDS(ra_barrier_down, paste0("003_processed_data/cdmetapop/hunsrueck/001_", Sys.Date(), "_raster_w_barriers_down.RDS"))# saveRDS(ra_barrier_down, paste0("003_processed_data/cdmetapop/hunsrueck/001_", Sys.Date(), "_raster_w_barriers_down.RDS"))
#saveRDS(ra_barrier_up  , paste0("003_processed_data/cdmetapop/hunsrueck/001_", Sys.Date(), "_raster_w_barriers_up.RDS"))# saveRDS(ra_barrier_up  , paste0("003_processed_data/cdmetapop/hunsrueck/001_", Sys.Date(), "_raster_w_barriers_up.RDS"))

# gdistance ---------------------------------------------------------------

sites2    <- ptr(points = sf_sub_sites_trans, 
                 raster = stars::st_as_stars(ra_barrier_down))
sites_sp  <- as_Spatial(sites2)
rm(sf_sub_sites_trans, sites2); gc()

cost_distance_matrix_up   <- costDistance(x = transition(ra_barrier_up, transitionFunction=min, directions=8),   
                                          fromCoords = sites_sp, 
                                          toCoords = sites_sp) * 100
cost_distance_matrix_down <- costDistance(x = transition(ra_barrier_down, transitionFunction=min, directions=8), 
                                          fromCoords = sites_sp, 
                                          toCoords = sites_sp) * 100

fwrite(x = cost_distance_matrix_up,
       file = "003_processed_data/cdmetapop/hunsrueck/002_cd_matrix_up_null.csv",
       col.names = F)
fwrite(x = cost_distance_matrix_down,
       file = "003_processed_data/cdmetapop/hunsrueck/002_cd_matrix_down_null.csv",
       col.names = F)