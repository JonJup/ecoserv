### --- gdistance playground --- ### 

#date written: 08.10.20 

library(raster)
library(gdistance)
library(tmap)
library(magrittr)
library(ggplot2)
library(reshape2)
source("002_r_scripts/functions/001_function_snap_to_raster_centroid.R")
tmap_mode("view")

## -- very basic matrix -- ## 
ma_pre_raster <- matrix(rep(c(0,1,0), 3),
                        byrow = TRUE,
                        ncol=3)
ra_test = raster(ncol=3,nrow=3)
ra_test[] = ma_pre_raster 
tr_test = transition(ra_test, transitionFunction = min, directions = 8)
tr_test[1:9, 1:9]
image(transitionMatrix(tr_test))

## -- very basic with barrier -- ## 
ma_pre_raster <- matrix(c(0,1,0,0,0.5,0,0,1,0),
                        byrow = TRUE,
                        ncol=3)
ra_test = raster(ncol=3,nrow=3)
ra_test[] = ma_pre_raster 
tr_test = transition(ra_test, transitionFunction = min, directions = 8)
tr_test[1:9, 1:9]
image(transitionMatrix(tr_test))

## -- spatial data -- ## 
ra_river <- raster("001_raw_data/gewaessernetze/dem_abgeleited/river_network_whole_region.tif")
sf_sites <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")

sf_sites_mod <- 
        sf_sites[24:25,] %>% 
        st_transform(crs = st_crs(ra_river)) %>% 
        ptr(raster = stars::st_as_stars(ra_river)) %>% 
        as_Spatial()

vec_sub <- st_bbox(sf_sites_mod) * c(.9999,.9999,1.0001,1.0001)
mat_szb <- matrix(nrow = 2, ncol = 2, vec_sub[c(1,3,2,4)], byrow = T)
ext_sub <- extent(mat_szb) 
ra_river_cropped        <- raster::crop(x = ra_river, ext_sub)

tm_shape(ra_river_cropped) + tm_raster() + tm_shape(sf_sites_mod) + tm_dots()
# transition matrix 
tr_test = transition(ra_river_cropped, transitionFunction = min, directions = 8)
image(transitionMatrix(tr_test))
plot(raster(tr_test))
ma_cd <- costDistance(x=tr_test, fromCoords = sf_sites_mod, toCoords = sf_sites_mod)
# if the barrier value = 1 then the number in the cost distance matrix is the number of cells.
# The values in the transition matrix are conductance values and effective distance = distance/conductance
ma_cod <- commuteDistance(x=tr_test,coords=sf_sites_mod)

# -- add one barriers with 0.5 -- # 
ra_river_mod = ra_river_cropped 
non_zero_id = which(values(ra_river_mod) == 1)
change_id   = non_zero_id[sample(x=1:length(non_zero_id), size=2)]
values(ra_river_mod)[change_id]=0.5
plot(ra_river_mod)
tr_test = transition(ra_river_mod, transitionFunction = custom_trasition_function, directions = 8, symm=FALSE)
plot(raster(tr_test))
ma_cd <- costDistance(x=tr_test, fromCoords = sf_sites_mod, toCoords = sf_sites_mod)

custom_trasition_function <- function(x){
        if(any(x==0)){
                out <- 0
        }else{
                out <- min(x)
        }
}
ra_write = raster(tr_test)
values(ra_write)[which(values(ra_write)==0)] <- 0.1
writeRaster(ra_write, "003_processed_data/cdmetapop/hunsrueck/test.tif", overwrite=TRUE)
