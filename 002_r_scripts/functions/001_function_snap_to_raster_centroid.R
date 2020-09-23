# -------------------------- #
### --- Snap to raster --- ###
# -------------------------- #

ptr <- function(points, 
                raster) {
        
        # turn rasters to points 
        stream_points <- st_as_sf(raster, as_points = TRUE)
        # remove all non_stream points 
        names(stream_points)[1] <- "value"
        stream_id <- which(stream_points$value == 1)
        stream_points <- stream_points[stream_id,]
        
        nn <- st_nearest_feature(points, 
                          stream_points)
        new_points  <- data.frame(site = points$site,
                                  geom = stream_points[nn, "geometry"])
                        
        new_points <- st_as_sf(new_points)        
        new_points        
}
