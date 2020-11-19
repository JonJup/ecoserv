# ----------------------------------------- #
### --- Add new line to river network --- ### 
### -------------- FUNCTION ------------- ### 
# ----------------------------------------- #

# date written: 23.10.20

# Jonathan Jupke 
# Ecoserv 
# Pass Probability 

add_river = function( 
                     dt_data = dt_rivers,
                     from_line, 
                     to_line, 
                     from_point, 
                     to_point
                     # cast_p1, 
                     # cast_p2
                     ) {
        
        options(warn = -1)
        st_data     = st_as_sf(dt_data)
        st_data_sub =
                st_data %>%
                filter(ecoserv_id %in% c(from_line, to_line))
        st_data_sub_points =
                st_data_sub %>%
                st_cast(to = "POINT") %>%
                mutate(p_id = row_number())
        st_line_to = 
                st_data_sub %>%
                filter(ecoserv_id == to_line)
        st_line_from = 
                st_data_sub %>%
                filter(ecoserv_id == from_line)
        st_points_from = 
                st_data_sub_points %>%
                filter(ecoserv_id == from_line)
        st_points_to = 
                st_data_sub_points %>%
                filter(ecoserv_id == to_line)
        st_points_from = st_points_from[c(1, nrow(st_points_from)),]
        st_points_to   = st_points_to[c(1, nrow(st_points_to)),]
        p_id1          = st_nearest_feature(x = st_line_to,
                                            y = st_points_from)
        p_id2          = st_nearest_feature(x = st_line_from,
                                            y = st_points_to)
        p_id1          = st_points_from$p_id[p_id1]
        p_id2          = st_points_to$p_id[p_id2]
                
        st_data_sub_points %>%
                filter(p_id %in% c(p_id1, p_id2)) %>%
                st_coordinates(st_data_sub_points) %>%
                .[,-3] %>%
                list() %>%
                st_multilinestring() %>%
                st_sfc() ->
                st_new_line
        st_crs(st_new_line)=st_crs(st_data)
        df_attributes = data.frame(
                "ecoserv_id" = paste0("add_",
                                      max(dt_data$ecoserv_number) + 1),
                "FROM" = from_point,
                "TO"   = to_point,
                score_up=1,
                score_down=1,
                ecoserv_number=max(dt_data$ecoserv_number) + 1
        )
        st_new_line = st_sf(df_attributes, geom = st_new_line)   
        st_crs(st_new_line)=st_crs(st_data)
        st_data %<>% rbind(st_new_line)
        setDT(st_data)
        
        return(st_data)
        options(warn = 1)
}