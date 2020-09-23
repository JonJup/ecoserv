### ---------------------------------- ###
### --- split at junction function --- ###
### ---------------------------------- ###

#date: 31.07.20, 10.08.20

# take groundwork layed in split at junction playground and bundle in function 


# work on function  -------------------------------------------------------
# comment this section out when finished. 

# library(tmap)
# tm_shape(river_subset) + tm_lines() + tm_shape(loop_var) + tm_lines(col = "red") + tm_shape(sub_loop_var) + tm_lines(col = "green") 
# tm_shape(river_subset) + tm_lines() + tm_shape(loop_var) + tm_lines(col = "red") + tm_shape(sub_loop_var) + tm_lines(col = "green") + tm_shape(loop_var2) + tm_dots(size = 1, col = "pink")
# tm_shape(river_subset) + tm_lines() + tm_shape(loop_var) + tm_lines(col = "red") + tm_shape(sub_loop_var) + tm_lines(col = "green") + tm_shape(loop_var_point) + tm_dots(size = .1, col = "pink")
# tm_shape(river_subset) + tm_lines() + tm_shape(loop_var) + tm_lines(col = "red") + tm_shape(sub_loop_var) + tm_lines(col = "green") + tm_shape(start_end) + tm_dots(size = 1, col = "pink")
# tm_shape(river_subset) + tm_lines() + tm_shape(loop_var) + tm_lines(col = "red") + tm_shape(sub_loop_var) + tm_lines(col = "green") + tm_shape(split_lines) + tm_lines(col = "ecoserv_id")


# function body -----------------------------------------------------------

split_at_junction <- function(data){
        
        # new id 
        prefix <- str_remove(data$ecoserv_id[1], "_[0-9]*")
        number <- str_remove_all(data$ecoserv_id, "[a-z]*_") %>% 
                as.numeric() %>% 
                max + 1
        i <- 1
        while (i != nrow(data)) {
                print(paste("beginning with", i, "@", Sys.time()))
                restart <- FALSE
                # select river segment [giving]
                loop_var <- data[i, ]
                # buffer of interest. Only stream segments within the buffer are checked for intersections.
                loop_buffer <-
                        st_buffer(loop_var, dist = 5000)
                # subset to segments in buffer.
                river_subset <-
                        st_intersection(data, loop_buffer)
                # loop over segments in buffer
                for (k in 1:nrow(river_subset)) {
                        print(paste(i, "-", k))
                        if (nrow(river_subset) != 0) {
                                sub_loop_var <- river_subset[k,]
                                if (sub_loop_var$ecoserv_id != loop_var$ecoserv_id) {
                                        loop_var2 <-
                                                st_intersection(loop_var, sub_loop_var)
                                        point_id <-
                                                which(st_is(loop_var2, "POINT"))
                                        if (length(point_id) != 0) {
                                                loop_var2 <- loop_var2[point_id, ]
                                                loop_var_point <-
                                                        st_cast(sub_loop_var,
                                                                "POINT")
                                                start_end <-
                                                        loop_var_point[c(1,
                                                                         nrow(loop_var_point)),]
                                                if (!any(
                                                        st_distance(
                                                                x = loop_var2,
                                                                y = start_end
                                                        ) < units::as_units(20, "m")
                                                )) {
                                                    
                                                        split_lines <-
                                                                st_split(x = sub_loop_var,
                                                                         y =  loop_var)
                                                        split_lines %<>% st_collection_extract(type = "LINESTRING")   
                                                        for (add_lines in 2:nrow(split_lines)) {
                                                                split_lines$ecoserv_id[add_lines] <- paste0(prefix, "_", number)
                                                                number <- number + 1
                                                        }
                                                        k_id <-
                                                                which(data$ecoserv_id == split_lines$ecoserv_id[1])
                                                        split_lines %<>% select("ecoserv_id")
                                                        data[k_id,] <- split_lines[1,]
                                                        data %<>% rbind(split_lines[2:nrow(split_lines),])
                                                        restart <- TRUE
                                                }
                                        }
                                }
                                
                                
                                
                        }
                        

                }
                if (restart) {i  <- 1}
                else i <- i + 1
                print(paste("next run:", i))
                
        }
        return(data)
}



