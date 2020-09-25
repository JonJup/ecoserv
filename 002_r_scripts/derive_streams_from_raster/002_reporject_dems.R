## -- Reproject raster -- ## 


dem <- raster("My work/001_data_raw/DEM_Europe/eu_dem_merged.tif")
dem2 <- projectRaster(from = dem, 
                      crs = "+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
