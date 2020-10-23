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
                     to_point, 
                     cast_p1, 
                     cast_p2) {
        
        
        st_data = st_as_sf(dt_data)
        
        st_data %>% 
                filter(ecoserv_id %in% c(from_line, to_line)) %>%  
                st_cast(to="POINT") %>% 
                mutate(p_id = row_number()) %>% 
                filter(p_id %in% c(cast_p1, cast_p2)) %>%
                st_coordinates(st_new_line) %>%
                .[, -3] %>%
                st_linestring() %>% 
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
}