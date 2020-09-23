# --------------------------------- #
### ---------- Function---------- ###
### --- Create Barrier Raster --- ###
# --------------------------------- #

# date 02.05.20
# Jonathan Jupke 

#' Create a raster with barrier values
#' 
#' @param barriers an sf spatial point object holding locations of barriers and their resistance value 
#' @param stream_network a rasterized stream network of class 'RasterLayer' or 'stars' 
#' @return A new raster (of class 'RasterLayer') which has value 1 for cells with no barrier and lower values in cells with barriers. 


create_barrier_raster <- function(barriers,
                                  stream_network
                                  ) {
        
        # checking inputs 
                # classes 
                if (!"sf" %in% class(barriers))           stop("Points must be of class sf")
                if (!"RasterLayer" %in% class(stream_network) & !"stars" %in% class(stream_network))  stop("Raster must be of class RasterLayer")
                # points has a resistance column 
                if (!("resistance" %in% names(barriers) | "conductance" %in% names(barriers)))    stop("Points needs to have a column named resistance or conductance, that indicates the resistance value of barriers")
        
        # resistance or conductance barrier? 
        resistance_type <- ifelse("resistance" %in% names(barriers), "resistance", "conductance")
        
        # turn stream network to points. The column which holds the values is
        # named after the input file. To generalize the name we call it
        # "value".
        stream_points <- rasterToPoints(stream_network, spatial = T)
        stream_points <- st_as_sf(stream_points)
        #stream_points <- st_as_sf(stream_network, as_points = TRUE)
        names(stream_points)[1] <- "value"
        
        # Create a subset of point that only contains point that belong to the
        # stream. This is necessary for the snapping as we do not want our
        # barrier cells to be snapped to non-stream points.
        stream_id     <- which(stream_points$value == 1)
        stream_points2 <- stream_points[stream_id,]
        
        # debug: plot stream points 
        #tm_shape(stream_points) + tm_dots(col = "value", palette = "viridis", midpoint = NA) + tm_shape(points) + tm_dots(shape = 2, size = 3)
        
        # Row of nearest stream point to barrier point. 
        nn <- st_nearest_feature(barriers, 
                                 stream_points2)
        stream_points3 <- stream_points2[nn, ]
        # tm_shape(stream_points2) + tm_dots(col = "value", palette = "viridis", midpoint = NA) + tm_shape(points) + tm_dots(shape = 2, size = 3)
        # Check distance 
        distance_list <-
                purrr::map(.x = 1:nrow(barriers),
                    .f = ~ as.numeric(st_distance(x = barriers[.x, ],
                                                  y = stream_points3[.x, ])))
        
        distance_list  <- unlist(distance_list)
        near_id        <- which(distance_list < 100)
        barriers       <- barriers[near_id, ]
        nn             <- nn[near_id]
        
        # create a new spatial object with snapped barrier points 
        if (resistance_type == "resistance") {
                stream_points2$resistance <- 1
                stream_points2$resistance[nn] <-  barriers$resistance

                stream_points$resistance <- 1
        } else if (resistance_type == "conductance") {
                stream_points2$conductance <- 1
                stream_points2$conductance[nn] <-  barriers$conductance
        }

         #convert to SpatialPointsDataFrame - a class from the sp package which
         # work better together with the raster package.
         
        stream_points$conductance <- 0
        stream_points$conductance[stream_id] <- stream_points2$conductance
        
        stream_points_spdf <- as_Spatial(stream_points)
        test <- rasterize(x = stream_points_spdf,
                  y = stream_network,
                  filed = "conductance")
        
        tm_shape(test$conductance) + tm_raster()
        
        
         # create final barrier raster      
         if (resistance_type == "resistance") {
                 out <- rasterize(x = stream_points_spdf,
                                  y = stream_network,
                                  field = "resistance"
                                  )
         } else if (resistance_type == "conductance") {
                 out <- rasterize(x = stream_points_spdf,
                                  y = stream_network,
                                  field = "conductance"
                                  )   
         }
         return(out)         
}
