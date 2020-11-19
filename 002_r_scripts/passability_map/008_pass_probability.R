# ------------------------------------- #
### --- Passability Probabilities --- ### 
# ------------------------------------- #

# date written: 22.10.20 

pacman::p_load(igraph,
               data.table,
               dplyr,
               here,
               magrittr,
               shp2graph,
               sf,
               sp,
               tmap)



## DIRECTORIES
dir_pm = here("002_r_scripts/passability_map/")

# load data 
source(file.path(dir_pm, "007_fix_flow_direction.R"))

# DIRECTORIES -- sourcing messes with  
dir_pd = here("003_processed_data/")
dir_rd = here("001_raw_data/")

## OPTIONS 
save = TRUE


# read files --------------------------------------------------------------
li_nodes  = readRDS(file.path(dir_pd, "network","2020-11-02_list_pre_network.RDS"))
nw_rivers = readRDS(file.path(dir_pd, "network", "2020-11-02_igraph_river.RDS"))


# carpet ------------------------------------------------------------------
st_rivers = st_as_sf(dt_rivers)
st_sites %<>% st_transform (crs = st_crs(st_rivers))


tb_edge = tibble(EdgeID = li_nodes[[3]][, 1],
                 Node1 = li_nodes[[3]][, 2],
                 Node2 = li_nodes[[3]][, 3])

tb_edge = left_join(x = tb_edge,
                    y = li_nodes[[5]],
                    by = "EdgeID")

dt_edge <- setDT(tb_edge)
rm(tb_edge);gc()

# update with current river network 
dt_edge=dt_edge[ecoserv_id %in% dt_rivers$ecoserv_id]
dt_edge[,c("FROM", "TO") := NULL]
dt_rivers_join = dt_rivers[, c("ecoserv_id", "FROM", "TO")]
dt_edge=dt_rivers_join[dt_edge, on = "ecoserv_id"]
rm(dt_rivers_join);gc()

vc_sites = unique(st_sites$site)
 
li_sp = list()

ma_distance = matrix(data = NA, nrow=30, ncol=30)
ma_spatial = ma_spatial_p_cg = ma_distance
diag(ma_distance) = 1
diag(ma_spatial_p_cg) = 1
diag(ma_spatial) = 0

for (site1 in 16:18) {
        for (site2 in 16:18) {
                
                # skip if site 1 and site 2 are the same 
                if (site1 == site2) next()
                print(paste("START from", vc_sites[site1], "to", vc_sites[site2]))

                int_start = st_nearest_feature(x = st_sites[site1,],
                                               y = st_rivers)
                int_end   = st_nearest_feature(x = st_sites[site2,],
                                               y = st_rivers)
                
                int_start = st_rivers[int_start, ]$ecoserv_id
                int_end   = st_rivers[int_end,   ]$ecoserv_id
                from      = dt_edge[ecoserv_id ==  int_start, Node2]
                to        = dt_edge[ecoserv_id ==  int_end,   Node1]
                
                li_sp = shortest_paths(graph = nw_rivers,
                                       from  = from,
                                       to    = to)
                
                
                v_path = unlist(li_sp[[1]])
                
                tb_edge_id_sub = dt_edge[(Node2 %in% v_path & Node1 %in% v_path)|ecoserv_id==int_start|ecoserv_id==int_end]
                tb_edge_id_sub[, flow_direction := factor(levels=c("up","down"))]
                tb_edge_id_sub[, segment_number := numeric()]
                tb_edge_id_sub[ecoserv_id==int_start, c("flow_direction", "segment_number") := .("down",1) ]
                
                st_loop_length = filter(st_rivers, ecoserv_id %in% tb_edge_id_sub$ecoserv_id)
                st_loop_length$segment_length = st_length(st_loop_length)
                st_loop_length %<>% select(ecoserv_id, segment_length) %>% 
                        st_drop_geometry() %>% 
                        setDT
                st_loop_length[, segment_length := as.numeric(segment_length)]
                tb_edge_id_sub = st_loop_length[tb_edge_id_sub, on = "ecoserv_id"]
                
                for (i in seq_along(v_path)) {
                #for (i in 1:6){
                        
                        loop_var = tb_edge_id_sub[is.na(flow_direction) &
                                                          (Node1 == v_path[i] | Node2 == v_path[i])]
                        
                        if (nrow(loop_var) == 1){
                                
                                tb_edge_id_sub[is.na(flow_direction) &
                                              (Node1 == v_path[i] | Node2 == v_path[i]), 
                                               segment_number := i+1]
                                loop_bool = ifelse(any(loop_var$FROM == tb_edge_id_sub[segment_number == (i), TO]),1,
                                                   ifelse(any(loop_var$TO == tb_edge_id_sub[segment_number == (i), TO]),2,
                                                          ifelse(any(loop_var$TO == tb_edge_id_sub[segment_number == (i), FROM]),3,0))
                                )
                                
                                if(loop_bool == 1) {
                                        # check for length 
                                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "down"]  
                                } else if (loop_bool == 2){
                                        # check for length 
                                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "up"]
                                } else if (loop_bool == 3) {
                                        # check for length
                                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "up"]
                                }
                                
                                
                        } else if (nrow(loop_var) > 1) {
                                
                                # we have more than one stream that flows from our endpoint 
                                # loop over them
                                # note to self: the loop could be the norm! 
                                for (j in 1:nrow(loop_var)) {
                                        
                                        loop_segment = loop_var[j,]
                                        
                                        tb_edge_id_sub[ecoserv_id == loop_segment$ecoserv_id, 
                                                       segment_number := i+1]  
                                        
                                        if (loop_segment$FROM == tb_edge_id_sub[segment_number == i, TO]) {
                                                tb_edge_id_sub[ecoserv_id == loop_segment$ecoserv_id, flow_direction := "down"]
                                        } else if (loop_segment$TO == tb_edge_id_sub[segment_number == i, TO]) {
                                                tb_edge_id_sub[ecoserv_id == loop_segment$ecoserv_id, flow_direction := "up"]
                                        } else if (loop_segment$TO == tb_edge_id_sub[segment_number == i, FROM]) {
                                                tb_edge_id_sub[ecoserv_id == loop_segment$ecoserv_id, flow_direction := "up"]
                                        }
                                        
                                }
                                
                        } else if (nrow(loop_var) == 0) {
                                print(paste("no sites at iteration", i))
                                break()
                        }
                        # any segments with this node at all?
                        if (tb_edge_id_sub[is.na(flow_direction) &
                                           (Node1 == v_path[i] | Node2 == v_path[i]), .N] == 0) {
                                print(paste("No segments with Node", i, "left"))
                                next()
                        }
                        
                }
                
                # CALCULATE PROBABILITES
                p_down  = prod(dt_rivers[ecoserv_id %in% tb_edge_id_sub[flow_direction=="down", ecoserv_id], score_down])
                p_up    = prod(dt_rivers[ecoserv_id %in% tb_edge_id_sub[flow_direction=="up", ecoserv_id], score_down])
                p_total = p_up*p_down
                
 
                
                in_most_segments = tb_edge_id_sub[segment_number != min(segment_number) & segment_number != max(segment_number), 
                                                  sum(segment_length)]
                
                
                # which is the second stream? 
                in_d1 = st_distance(x = st_sites[site1, ],
                                    y = filter(st_rivers, ecoserv_id == tb_edge_id_sub[segment_number == 2, ecoserv_id])) %>%
                        as.numeric()
                in_d2 = st_distance(x = st_sites[site2,],
                                    y = filter(st_rivers, ecoserv_id == tb_edge_id_sub[segment_number == max(segment_number)-1, ecoserv_id])) %>% 
                        as.numeric()
                # FILL OUTPUT MATRICES
                ma_distance[site1,site2] = p_total
                ma_spatial[site1, site2] = in_most_segments + in_d2 + in_d1
                ma_spatial_p_cg[site1,site2] = dnorm(x = ma_spatial[site1, site2], mean = 51, sd = 9.2) # data: Knaepkens et al (2005) Table 1 
                ## PRINT LOOP END 
                print(paste("FINISHED from", vc_sites[site1], "to", vc_sites[site2]))
                # REMOVE LOOP OBJECTS
                rm(int_start, int_end, from, to, v_path, tb_edge_id_sub, p_down,p_up,p_total, in_most_segments, in_d2, in_d1, st_loop_length);gc()
        }
}

ma_final_probability = ma_distance * ma_spatial_p_cg

ma_final_probability = ma_final_probability[16:18, 16:18] 

if (save) {
    
    fwrite(x = ma_final_probability, 
            file = file.path(dir_pd, "migration_probability.csv"),
           col.names = FALSE)
        
}
