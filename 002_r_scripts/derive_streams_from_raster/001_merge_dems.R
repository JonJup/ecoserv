### --- Merged --- ### 

pacman::p_load(raster)

setwd("~/01_Uni/Ecoserv/My work/001_data_raw/DEM_Europe/")

raster1 <- raster("032ab314564b9cb72c98fbeb093aeaf69720fbfd/eu_dem_v11_E30N20/eu_dem_v11_E30N20.TIF")
raster2 <- raster("6eb56e1310dfacaef22943d329e3e23f4665de04/eu_dem_v11_E30N30/eu_dem_v11_E30N30.TIF")
raster3 <- raster("97824c12f357f50638d665b5a58707cd82857d57/eu_dem_v11_E40N20/eu_dem_v11_E40N20.TIF")
raster4 <- raster("fdac92901442ed49bf899a997791c5a7faac0b87/eu_dem_v11_E40N30/eu_dem_v11_E40N30.TIF")

raster12 <- raster::merge(raster1, 
                          raster2)

raster34 <- raster::merge(raster3,
                          raster4)

raster1234 <- raster::merge(raster12, 
                            raster34)

plot(raster1234)
