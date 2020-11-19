### --- Ecoserv 
### --- Downstream colonization with CDMetaPOP
### --- 19.11.20 
### --- Call script -- create pseudo sites 

# TODO REMOVE rlp_10390

options(warn = -1)
dt_edge_id_sub = tb_edge_id_sub
setDT(dt_edge_id_sub)
ls_points = list()
for (i in 1:nrow(tb_edge_id_sub)) {
#for (i in 1:5) {
        # Pick river segment. First is selected directly via start id. Further ones are chosen by 
        # making the next segment, identified in the run before, to the current one. 
        # For i == 1 the position of the sampling location is also extracted.
        if (i == 1){
                st_l_river = filter(st_rivers, 
                                    ecoserv_id == int_start)
                st_start_point = st_sites[int_start_site,] 
        } else {
                st_l_river = st_nxt_segment
        }
        
        # Pick the next river segment. Skip if you are in the last round. 
        if (i != nrow(tb_edge_id_sub)) {
                st_nxt_segment = filter(st_rivers, ecoserv_id == dt_edge_id_sub[Node2 == v_path[i+1], ecoserv_id])
                if (st_nxt_segment$FROM != st_l_river$TO) {
                        st_nxt_segment = filter(st_rivers, ecoserv_id == dt_edge_id_sub[Node1 == v_path[i+1], ecoserv_id])
                        if (st_nxt_segment$FROM != st_l_river$TO) {
                                break("flow error")
                        }
                }
        } 
        
        # Shorten sement if i == 1 
        if (i == 1){
                st_nxt_segment %<>% st_cast("POINT")
                st_l_points = st_cast(st_l_river, "POINT")
                st_end_point = which(st_l_points$geom %in% st_nxt_segment$geom)
                st_end_point = st_l_points[st_end_point, ]  
                d_vec_points = as.numeric(st_distance(st_l_points, st_end_point))
                d_vec_start = st_distance(st_start_point, st_end_point) %>%
                        as.numeric()
                d_vec_start = d_vec_points < d_vec_start
                st_l_points$down_from_sample = d_vec_start
                # remove all points "above" sampling location
                st_l_points %<>% filter(down_from_sample == TRUE)
                sp_l_points = as_Spatial(st_l_points)
                sp_l_river  = spLines(sp_l_points,
                                      crs = crs(sp_l_points))
        } else {
                sp_l_river = as_Spatial(st_l_river)  
        }
        
        # place points along river segment
        numOfPoints = round(gLength(sp_l_river) / 50, 0)
        st_points   = spsample(sp_l_river,
                               n = numOfPoints,
                               type = "regular") %>%
                st_as_sf()
        ls_points[[i]] <- st_points


}


options(warn = 1)
tm_shape(st_l_river) + tm_lines(scale=5) 
tm_shape(st_nxt_segment) + tm_lines()
tm_shape(st_l_river2) + tm_lines(col = "red")  
tm_shape(ls_points[[1]]) + tm_dots()  +
tm_shape(ls_points[[2]]) + tm_dots()  + 
tm_shape(ls_points[[3]]) + tm_dots()  + 
tm_shape(ls_points[[4]]) + tm_dots()  + 
tm_shape(ls_points[[5]]) + tm_dots()  



        tm_shape(st_start_point) + tm_dots()

tm_shape(st_points) + tm_dots()  
        tm_shape(st_loop_segment_point) + tm_dots(col = "down_from_sample") + 
        tm_shape(st_start_point) + tm_dots(col = "red") + 
        tm_shape(st_nxt_segment_point) + tm_dots(col="green")

        
        
st_crs(st_rivers)
      st_rivers %>% 
              filter(ecoserv_id %in% c("rlp_10389", "rlp_10280")) %>% 
              tm_shape() + tm_lines(col = "ecoserv_id")
      