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

here() %>% setwd

# directories 
dir_pd = "003_processed_data/"
dir_rd = "001_raw_data/"

# load data 
dt_rivers = readRDS(file.path(dir_pd, "map_passability", "fixed_rivers.RDS"))
st_sites  = readRDS(file.path(dir_rd, "probestellen", "2020-09-23_all_sites.RDS"))
li_nodes  = readRDS(file.path(dir_pd, "network","2020-10-22_list_pre_network.RDS"))
nw_rivers = readRDS(file.path(dir_pd, "network", "2020-10-22_igraph_river.RDS"))
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
   
for (site1 in seq_along(vc_sites[1:2])) {
        for (site2 in seq_along(vc_sites[1:2])) {
                
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
                                       from = from,
                                       to = to)
                print(paste("FINISHED from", vc_sites[site1], "to", vc_sites[site2]))
        }
}

# compute shortest path 

# extract nodes on path as vector 
v_path=as.vector(li_sp$vpath[[1]])

# create a subset of tb_edge_id that contains only segments with nodes in the
# path + start and end segement. This tibble will be used in the subsequent
# assignment of upstream and downstream movemen.
tb_edge_id_sub = tb_edge_id[(Node2 %in% v_path & Node1 %in% v_path)|ecoserv_id==int_start|ecoserv_id==int_end]
tb_edge_id_sub[, flow_direction := factor(levels=c("up","down"))]
tb_edge_id_sub[, segement_number := numeric()]

tb_edge_id_sub[ecoserv_id==int_start, c("flow_direction", "segement_number") := .("down",1) ]
# 
for (i in seq_along(v_path)) {
        # for (i in 1:9){
        #   i = 10
        loop_var = tb_edge_id_sub[is.na(flow_direction) &
                                          (Node1 == v_path[i] | Node2 == v_path[i])]
        
        if (nrow(loop_var) == 1){
                tb_edge_id_sub[is.na(flow_direction) &
                                       (Node1 == v_path[i] | Node2 == v_path[i]), segement_number := i]
                
                if (loop_var$FROM == tb_edge_id_sub[segement_number == (i -1), TO]) {
                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "down"]
                } else if (loop_var$TO == tb_edge_id_sub[segement_number == (i - 1), TO]) {
                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "up"]
                } else if (loop_var$TO == tb_edge_id_sub[segement_number == (i - 1), FROM]) {
                        tb_edge_id_sub[ecoserv_id == loop_var$ecoserv_id, flow_direction := "up"]
                }
        }
        # any segments with this node at all?
        if (tb_edge_id_sub[is.na(flow_direction) &
                           (Node1 == v_path[i] | Node2 == v_path[i]), .N] == 0) {
                print(paste("No segments with Node", i, "left"))
                next()
        }
        
}

p_down = prod(dt_rivers[ecoserv_id %in% tb_edge_id_sub[flow_direction=="down", ecoserv_id], score_down])
p_up = prod(dt_rivers[ecoserv_id %in% tb_edge_id_sub[flow_direction=="up", ecoserv_id], score_down])
p_total = p_up*p_down