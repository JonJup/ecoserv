# ------------------------------------ #
### --- Add barriers to flow map --- ### 
### --- fake data --- -------------- ###
# ------------------------------------ #

#date written: 25.09.20 
#date changes: 
#date used   : 25.09.20 
#Jonathan Jupke 
# Ecoserv 
# Passability Map 

#-- what? -- # 
# Add passability information to the single stream segments 


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

## -- check with plot -- ## 
# tm_shape(rivers) + tm_lines() + 
#         tm_shape(barrier) + tm_dots(col = "red")
# tm_shape(barrier) + tm_dots()

# nn analysis -------------------------------------------------------------
nn = st_nearest_feature(barrier,
                        rivers); beepr::beep()

rivers_resorted <- rivers[nn,]

distance_list <-
        map(.x = 1:nrow(barrier),
            .f = ~ as.numeric(st_distance(x = barrier[.x, ],
                                          y = rivers_resorted[.x, ])));beepr::beep()


distance_list  <- readRDS("003_processed_data/map_passability/2020-09-25_distance_list.RDS")
distance_list2 <- unlist(distance_list)
distance_table <- data.table("barrier_ID"  = barrier$ecoserv_barrier_id,
                             "nn_distance" = distance_list2,
                             "river_ID"    = rivers_resorted$ecoserv_id)

distance_table2 <- distance_table[nn_distance <= 50]
rm(nn, distance_list, distance_table, rivers_resorted);gc()
hist(distance_table2$nn_distance)

# OK, so now we have i) only barriers that are close to a river and ii) the
# connection between each river and its barriers. I can use the latter to determine
# "passability" of a river segment as the product of its barrier passabilities.

if (!length(unique(rivers$ecoserv_id)) == nrow(rivers)) {
        dup_id <- which(duplicated(rivers$ecoserv_id))
        rivers <- rivers[-dup_id,]
        #rivers[dup_id,]
}

# saveRDS(distance_table2, paste0("001_data/karte_durchl?ssigkeit/", Sys.Date(), "_Greb_2.RDS"))
# distance_table2 <- readRDS("001_data/karte_durchlaessigkeit/2020-07-01_Greb_2.RDS")

rivers2 <- rivers
setDT(rivers2)
setDT(barrier)

barrier$score_down2 <- purrr::map_dbl(.x = barrier$score_down, 
                                    .f= rnorm,
                                    n = 1,
                                    sd = 0.05)
barrier[score_down2>1, score_down2:=1]
barrier[score_down2<0, score_down2:=0]
barrier[,score_down := score_down2]
# # this loop gives the stream segments their scores 
for (i in 1:nrow(rivers2)) {
        loop_var  <- rivers2$ecoserv_id[i]
        loop_var2 <- distance_table2[river_ID == loop_var]
        if (nrow(loop_var2) == 0) next()
        loop_var3 <- barrier[ecoserv_barrier_id %in% loop_var2$barrier_ID]
        loop_score_up    <- prod(loop_var3$score_up  , na_rm = T)
        loop_score_down <-  prod(loop_var3$score_down, na_rm = T)
        rivers2[ecoserv_id == loop_var, c("score_up", "score_down") := .(loop_score_up, loop_score_down)]
        
        print(paste("Finished", i/nrow(rivers2)*100, "@", Sys.time()))
}
# 
rivers2[is.na(score_down), score_down := 1]
rivers2[is.na(score_up), score_up := 1]

# Save to file  -----------------------------------------------------------
saveRDS(rivers2           , paste0("003_processed_data/map_passability/fake map/", Sys.Date(), "_rivers_w_flow_and_fake_barriers.RDS"))

