# ------------------------------------ #
### --- Add barriers to flow map --- ### 
### ----------- subsets ------------ ### 
# ------------------------------------ #

#date written: 25.09.20 
#date changes: 
#date used   : 25.09.20
#Jonathan Jupke 
# Ecoserv 
# Passability Map 

#-- what? -- # Add passability information to the single stream segments. This
#is for the meeting 30.09. and I remove some amounts of the barriers.

# setup -------------------------------------------------------------------
pacman::p_load(sf, dplyr, magrittr,
               here, purrr, data.table,
               tmap)
setwd(here())

# load data ---------------------------------------------------------------
rivers   <- readRDS("003_processed_data/map_passability/2020-08-25_all_w_flow.RDS")
barrier  <- st_read("003_processed_data/2020-08-22_all_barriers.gpkg")

# carpeting  -------------------------------------------------------------
rivers %<>% st_as_sf()

if (st_crs(barrier) != st_crs(rivers)) barrier %<>% st_transform(crs = st_crs(rivers))

# nearest neighbor analysis -------------------------------------------------------------

nn = st_nearest_feature(barrier, rivers); beepr::beep()

rivers_resorted <- rivers[nn,]

distance_list <-
        map(.x = 1:nrow(barrier),
            .f = ~ as.numeric(st_distance(x = barrier[.x, ],
                                          y = rivers_resorted[.x, ])));beepr::beep()

# quick save - computation of distance list is time intensive. 
saveRDS(distance_list, file = paste0("003_processed_data/map_passability/", Sys.Date(), "_distance_list.RDS"))

distance_list2 <- unlist(distance_list)
distance_table <- data.table("barrier_ID"  = barrier$ecoserv_barrier_id,
                             "nn_distance" = distance_list2,
                             "river_ID"    = rivers_resorted$ecoserv_id)

distance_table2 <- distance_table[nn_distance <= 50]
rm(nn, distance_list, distance_table, rivers_resorted, distance_list2);gc()

distance_table2_08_id <- sample(x = 1:nrow(distance_table2), size = nrow(distance_table2) * 0.8)
distance_table2_06_id <- sample(x = 1:nrow(distance_table2), size = nrow(distance_table2) * 0.6)
distance_table2_04_id <- sample(x = 1:nrow(distance_table2), size = nrow(distance_table2) * 0.4)
distance_table2_02_id <- sample(x = 1:nrow(distance_table2), size = nrow(distance_table2) * 0.2)

distance_table2_08 <- distance_table2[distance_table2_08_id, ]
distance_table2_06 <- distance_table2[distance_table2_06_id, ]
distance_table2_04 <- distance_table2[distance_table2_04_id, ]
distance_table2_02 <- distance_table2[distance_table2_02_id, ]

rm(distance_table2_08_id, distance_table2_06_id, distance_table2_04_id, distance_table2_02_id, distance_table2);gc()

if (!length(unique(rivers$ecoserv_id)) == nrow(rivers)) {
        dup_id <- which(duplicated(rivers$ecoserv_id))
        rivers <- rivers[-dup_id,]
}

rivers08 <- rivers06 <- rivers04 <- rivers02 <- rivers
rm(rivers);gc()

setDT(rivers08)
setDT(rivers06)
setDT(rivers04)
setDT(rivers02)

setDT(barrier)

river_subs <- c("rivers08", "rivers06", "rivers04", "rivers02")
vec_distance_tables <- c("distance_table2_08","distance_table2_06","distance_table2_04","distance_table2_02")
# # this loop gives the stream segments their scores 
for (k in seq_along(river_subs)){
        
        dt_k_loop     <- get(river_subs[k])
        dt_k_distance <- get(vec_distance_tables[k])
        
        
        
        for (i in 1:nrow(dt_k_loop)) {
                print(paste("Starting", i/nrow(dt_k_loop)*100, "in", k, "@", Sys.time()))
                # extract stream segment 
                chr_loop_i  <- dt_k_loop$ecoserv_id[i]
                # distances 
                dt_i_distance <- dt_k_distance[river_ID == chr_loop_i]
                # skip if dt_i_distance is empty, i.e. no barriers at stream segment
                if (nrow(dt_i_distance) == 0) {
                        print(paste("skipping"))
                        next()
                }
                # for debugging - finds the first i that is not skipped. 
                # if (nrow(dt_i_distance) != 0) {
                #         print(paste(i))
                #         break()
                # } 
                dt_i_barrier <- barrier[ecoserv_barrier_id %in% dt_i_distance$barrier_ID]
                
                loop_score_up   <- prod(dt_i_barrier$score_up  , na_rm = T)
                loop_score_down <- prod(dt_i_barrier$score_down, na_rm = T)
                dt_k_loop[ecoserv_id == chr_loop_i, c("score_up", "score_down") := .(loop_score_up, loop_score_down)]
                
                print(paste("Finished", i/nrow(dt_k_loop)*100, "@", Sys.time()))
        }
        assign(value = dt_k_loop, x = river_subs[k])
}

# 
rivers08[is.na(score_down), score_down := 1]
rivers08[is.na(score_up), score_up := 1]
rivers06[is.na(score_down), score_down := 1]
rivers06[is.na(score_up), score_up := 1]
rivers04[is.na(score_down), score_down := 1]
rivers04[is.na(score_up), score_up := 1]
rivers02[is.na(score_down), score_down := 1]
rivers02[is.na(score_up), score_up := 1]

# Save to file  -----------------------------------------------------------
saveRDS(rivers08 , paste0("003_processed_data/map_passability/", Sys.Date(), "_rivers_w_flow_and_08barriers.RDS"))
saveRDS(rivers06 , paste0("003_processed_data/map_passability/", Sys.Date(), "_rivers_w_flow_and_06barriers.RDS"))
saveRDS(rivers04 , paste0("003_processed_data/map_passability/", Sys.Date(), "_rivers_w_flow_and_04barriers.RDS"))
saveRDS(rivers02 , paste0("003_processed_data/map_passability/", Sys.Date(), "_rivers_w_flow_and_02barriers.RDS"))

if(readline("Remove all? ") == "yes") rm(list=ls())
