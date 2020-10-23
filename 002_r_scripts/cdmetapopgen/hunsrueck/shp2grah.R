# --------------------- #
### --- shp2graph --- ###
# --------------------- #

#date written:20.10.20

# setup -------------------------------------------------------------------
pacman::p_load(igraph,
               data.table,
               dplyr,
               magrittr,
               riverdist,
               shp2graph,
               sf,
               sp,
               tmap)

#tmap_mode("view")
save.dir = "003_processed_data/network/"
pd.dir.mp="003_processed_data/map_passability/"
rd.dir.ps="001_raw_data/probestellen/"
# load data ---------------------------------------------------------------
dt_rivers = readRDS(
        file.path(pd.dir.mp, "fixed_rivers.RDS")
)
st_sampling_sites = readRDS(
        file.path(rd.dir.ps, "2020-09-23_all_sites.RDS")
)

# carpet ------------------------------------------------------------------
st_rivers=st_as_sf(dt_rivers)
edge_length = st_length(st_rivers) %>% 
        as.numeric()

st_rivers %<>% as_Spatial()

li_pre_net = readshpnw(ntdata = st_rivers)
saveRDS(object = li_pre_net,
        file = file.path(save.dir, paste0(Sys.Date(), "_list_pre_network.RDS")))
igraph_river = nel2igraph(nodelist = li_pre_net[[2]],
                          edgelist = li_pre_net[[3]],
                          weight = edge_length)
saveRDS(object = igraph_river,
        file = file.path(save.dir, paste0(Sys.Date(), "_igraph_river.RDS")))

rglplot(
        igraph_river,
        vertex.size = .5,
        vertex.size2 = 2,
        mark.col = "green",
        main = "The converted igraph graph"
)

