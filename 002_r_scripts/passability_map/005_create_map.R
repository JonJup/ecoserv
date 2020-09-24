# ---------------------------------- #
### --- Create passability map --- ### 
# ---------------------------------- #

#date written: 22.08.20 
#date changes: 
#date used   : 22.08.20 + 26 + 27
#Jonathan Jupke 
# Ecoserv 
# Passability Map 

#-- what? -- # 
# Create passability map for Ecoserv  


# setup -------------------------------------------------------------------
pacman::p_load(sf, dplyr, magrittr,
               here, purrr, data.table,
               tmap, lwgeom, stringr)
setwd(here())

source("002_r_scripts/functions/F_003_reverse_pasability_map.R")

# load data ---------------------------------------------------------------
rivers   <- readRDS("001_data/map_passability/2020-08-26_rivers_w_flow_and_barriers.RDS")
samples  <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")

# carpeting ---------------------------------------------------------------
rivers %<>% st_as_sf()
if (st_crs(samples) != st_crs(rivers)) samples %<>% st_transform(crs = st_crs(rivers))

setDT(rivers)
# last_id = start_segement 
# test_rivers[last_id, c("score_down_eval", "evaled") := .(score_down, 1)]

# fixes -------------------------------------------------------------------
rivers  <- rivers[!ecoserv_id %in% c("swd_32406", "swd_37658", "swd_37712",
                                     "swd_43986", "swd_67705", "swd_63726",
                                     "vdn_7861", "swd_67704", "swd_40883",
                                     "swd_19631", "swd_71703", "swd_64280",
                                     "swd_64279", "swd_48147","swd_71961", 
                                     "swd_71702", "swd_34009"
                                     
                                     # "vdn_4309",
                                     # "vdn_7732"
                                     )]
rivers[ecoserv_id == "rlp_54"   , FROM := "P52"]
rivers[ecoserv_id == "rlp_10143", FROM := "P2634"]
rivers[ecoserv_id == "rlp_10143", TO   := "P2638"]
rivers[ecoserv_id == "rlp_10391", FROM := "P3136"]
rivers[ecoserv_id == "rlp_10280", FROM := "P3136"]
rivers[ecoserv_id == "rlp_10399", FROM := "P3150"]
rivers[ecoserv_id == "rlp_10398", FROM := "P3150"]
rivers[ecoserv_id == "rlp_10398", TO   := "P3160"]
rivers[ecoserv_id == "rlp_10611", FROM := "P3414"]
rivers[ecoserv_id == "rlp_10509", FROM := "P3374"]
rivers[ecoserv_id == "rlp_10627", FROM := "P3598"]
rivers[ecoserv_id == "rlp_10627", TO   := "P3612"]
rivers[ecoserv_id == "rlp_10394", FROM := "P2917"]
rivers[ecoserv_id == "sar_4600",  FROM := "P10674"]
rivers[ecoserv_id == "sar_8158",  FROM := "P117261"]
rivers[ecoserv_id == "sar_8158",  TO   := "P114079"]
rivers[ecoserv_id == "rlp_10634", FROM := "P3422"]
rivers[ecoserv_id == "vdn_16960", FROM := "P10564"]
rivers[ecoserv_id == "rlp_14111", FROM := "P29614"]
rivers[ecoserv_id == "rlp_11198", TO   := "P404"]
rivers[ecoserv_id == "sar_8400",  FROM := "P122813"]
rivers[ecoserv_id == "sar_8400",  TO   := "P403"]
rivers[ecoserv_id == "rlp_14942", TO   := "P11990"]
rivers[ecoserv_id == "vdn_7362" , FROM := "P20200"]
rivers[ecoserv_id == "vdn_7362" , TO   := "P22508"]
rivers[ecoserv_id == "vdn_2342" , TO   := "P28346"]
rivers[ecoserv_id == "vdn_2342" , FROM := "P22684"]
rivers[ecoserv_id == "vdn_4399" , FROM := "P22684"]
rivers[ecoserv_id == "rlp_10112", FROM := "P19952"]
rivers[ecoserv_id == "rlp_10118", FROM := "P2590"]

# out 
rivers[ecoserv_id %in% c("vdn_6657", "vdn_6658", "vdn_6660"), c("FROM", "TO") := c(1,2,3)]


#tmap_mode("view")

# to_split <- rivers[ecoserv_id == "vdn_7861"]
# to_split %<>% st_as_sf()
# to_split %<>% st_cast("POINT")
# 
# st_nearest_feature(y = to_split, 
#                    x = st_as_sf(rivers[ecoserv_id == "rlp_16958"]))
# 


# j = 1
reverse(c(29, 
          1259, 1286, 1287, 1288, 1295, 1316, 1317, 1324, 1512, 1517, 1579, 1649, 1657, 1685, 1736, 1737,
          1741, 1763, 1771, 1772, 1811, 1818, 1820, 1824, 1852, 1585, 1904, 1905, 1948,
          2356, 2378, 2399, 2452, 2477, 2488, 2494, 2510, 2580, 2627, 2897, 2937, 3461, 
          3462,  
          5068, 5088, 5091, 5095, 5106, 5140, 5153, 5156, 5216, 5224, 5279, 5325, 5335,
          6102, 6111, 6113, 
          8308,
          9580, 
          10816, 
          11344, 11360 ,11578,
          12365, 12834, 
          13065, 
          14412, 14413, 14314, 14336, 14341, 14351, 14355, 14356, 14369, 14379, 14628, 14632, 14641, 14643, 14905, 14906, 14907, 14908, 14909, 14989, 
          15045, 15046,
          29568, 29571, 
          37418, 37417, 37416, 37419, 37415, 37414, 37413, 37412, 37411, 37410, 37409, 37387, 37385, 35860, 
          43338,
          57058, 57069, 57078,
          58962,  
          62084, 62093, 62836, 62833, 62837, 62855, 62864, 62686, 
          63704, 63705, 63706, 63707 , 63709, 63711,  63713, 63716, 63717
          
          
          # Fakies: Sind richtig aber aus praktischen Gründen umgedreht 
          # 16 ist schon Rhein 
          
          ))



new_row <- data.table(ecoserv_id = paste0("rlp_x_00", 1:2), 
                      FROM       = c("P42","P52"   ),
                      TO         = c("P44", "P2183"), 
                      score_up   = 1,
                      score_down = 1,
                      geom       = c(rivers[TO == "P42", geom], 
                                     rivers[TO == "P52", geom])
)

rivers <- rbindlist(list(rivers, new_row))

rivers[, c("score_up_eval", "score_down_eval", "evaled") := .(1,1,0)]


# test_rivers[TO == "P10554"]
test_rivers <- copy(rivers)
test_rivers[, row_id := 1:nrow(test_rivers)]
for (j in c(1:31)) {
        test_rivers %<>% st_as_sf()
        start_segement <- st_nearest_feature(x = samples[j,], 
                                             y = test_rivers)
        setDT(test_rivers)
        last_id = start_segement
        test_rivers[start_segement, c("score_up_eval", "score_down_eval", "evaled") := .(score_up, score_down,1)]
        counter = 1 
        while (1 != 2) {
                
                # Which Point did the last segement flow into   
                # This object can be read as: 
                # The object in row names(going_to)[i] end in point going_to[[i]]
                        last_id_ul <- unlist(last_id)
                        pre_going_to <- test_rivers[last_id_ul, TO]
                        going_to <- list()
                        for (i in seq_along(pre_going_to)) {
                                going_to[[i]] <- pre_going_to[i]     
                                names(going_to)[i] <- as.character(unlist(last_id))[i]
                        }
                        
                        # What is the updated score of the last segement? 
                        # This object can be read as: 
                        # The object in row names(last_score_down)[i] has an updated score of last_score_down[[i]]
                        pre_last_score_down <- test_rivers[last_id_ul, score_down_eval]
                        last_score_down <- list()
                        for (i in seq_along(pre_last_score_down)) {
                                last_score_down[[i]] <- pre_last_score_down[i]     
                                names(last_score_down)[i] <- as.character(unlist(last_id))[i]
                        } 
                        if (sum(duplicated(going_to)) != 0) {
                                dup_id <- which(duplicated(going_to))      
                                # note 27.08: I removed two brackets around dup_id and added the unlists
                                dup_id <- which(unlist(going_to) %in% unlist(going_to[dup_id]))
                                dup_score_down <- last_score_down[dup_id]
                                max_id <- which(dup_score_down == max(unlist(dup_score_down)))
                                last_score_down[dup_id] <-  last_score_down[max_id]
                        } 
                        
                        
                        
                        # What rivers start from the last end point
                        # The object pre_nxt_stop is a vector with object row numbers 
                        # The object nxt_stop is a list with 
                        (pre_nxt_stop <- which(test_rivers$FROM %in% going_to))
                        nxt_stop <- list()
                        for (i in seq_along(pre_nxt_stop)) {
                                # id of a row that is the next river segment 
                                nxt_stop[[i]] <-  pre_nxt_stop[i]
                                # Name = name of the point from which this one starts
                                # where does this one come from 
                                loop_from <- test_rivers[pre_nxt_stop[i], FROM]
                                loop_name <- test_rivers[row_id %in% as.character(unlist(last_id)) & TO == loop_from, row_id]
                                #if (length(loop_name) > 1) loop_name <- names(last_score_down)
                                names(nxt_stop)[i] <- loop_name
                        }
                        
                        if (length(nxt_stop) == 0) break()
                        for (i in seq_along(nxt_stop)) {
                                loop_var <- names(nxt_stop)[i]
                                test_rivers[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]), 1)]
                                # test_rivers[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]), 1)]
                        }
                        #test_rivers[nxt_stop, c("score_down_eval", "evaled") := .(score_down * last_score_down,1)]
                        last_id <- nxt_stop
                        print(paste0("round ", counter,": ", names(going_to)))
                        counter <- counter + 1
        }
}

old_temp <- dir("001_data/map_passability/", pattern = "_temp.gpkg", full.names = T)
file.remove(old_temp)
st_write(test_rivers, paste0("001_data/map_passability/",Sys.Date(),"_temp.gpkg"))
#st_write(samples, paste0("001_data/map_passability/",Sys.Date(), "_sites_for_plot.gpkg"))
rm(list = ls())

# Manual Fixes to stream direction ----------------------------------------
# 
# # For Pfaelzerwald site 1
# reverse(c(112,140,144,146,147,156))
# # For Pfaelzerwlad site 2 
# reverse(c(418, 424, 345, 355, 356, 488, 495))
# rivers[346, FROM := "P958"]
# rivers[487, FROM := "P970"]
# # For Pfaelzerwlad site 3 
# reverse(c(616, 665, 669, 692, 694, 704, 705, 746, 748, 751, 758, 764, 666, 760))
# rivers[618,   TO := "P1218"]
# rivers[689, c("FROM", "TO") := .("P1336","P1382")]
# rivers[691, FROM := "P1276"]
# rivers[701, FROM := "P1372"]
# rivers[733, FROM := "P1276"]
# rivers[747, FROM := "P1486"]
# rivers[753, FROM := "P1332"]
# rivers[754, FROM := "P1284"]
# 
# # For Pfaelzerwlad site 4 
# reverse(c(576, 584))
# # For Pfaelzerwlad site 5 
# reverse(c(799, 822, 861, 908))
# # this one is an middle segment 
# rivers[820, FROM := "P1624"]
# # For Pfaelzerwlad site 6 
# reverse(c(4480, 4483, 4487, 4503, 4508, 4549, 4552, 4617, 4625))
# # For Pfaelzerwlad site 7 
# reverse(c(4536))
# # For Pfaelzerwlad site 8 
# reverse(c(4685))

# helping plots  ----------------------------------------------------------
# these can show the qbw at a certian river segement 
# qbw <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/2020-06-18_qbw_rlp_hr_final.gpkg")
# rivers <- readRDS("001_data/karte_durchlaessigkeit/2020-07-01_pfalz_w_ft.gpkg") %>% st_as_sf()
# st_crs(rivers) == st_crs(qbw)
# st_crs(rivers) == st_crs(samples)
# qbw %<>% st_transform(crs = st_crs(rivers))
# soi <-  filter(rivers, ABSCHNITT == 2391483990) 
# tm_shape(soi) + tm_lines() + tm_shape(qbw) + tm_dots(col = "score_down", size = 4)





# # now we need to let the river flow 
# rivers2 <- rivers 
# temp <- table(rivers2$TO)
# receiving <- data.table(table(rivers2$TO))
# names(receiving) <- c("Point_ID", "N_receive")
# temp <- left_join(x = rivers2, 
#           y = receiving, 
#           by = c("TO" = "Point_ID"))
# unique(temp$N_receive)
# 
# unique_points <- sort(unique(append(rivers2$FROM, rivers$TO)))
# 
# for (i in seq_along(unique_points)) {
#         loop_var <- unique_points[i]
#         rivers2[FROM == loop_var, receiving := nrow(rivers2[TO   == loop_var])]
#         rivers2[TO   == loop_var, giving    := nrow(rivers2[FROM == loop_var])]
#         
# };beepr::beep()
# 
# 
# 
# 
# saveRDS(rivers2, "001_data/karte_durchlässigkeit/temp_rivers.RDS")
# rivers2 <- readRDS("001_data/karte_durchlässigkeit/temp_rivers.RDS")
# rivers2[,passed_down_score := NULL]
# rivers2[, c("has_received", "has_given", "passed_down_score") := .(0,0,1)]
# rivers2[receiving == 0, passed_down_score := score_down]
# setorderv(rivers2, "receiving")
# finished_rivers <- 0
# while (finished_rivers != nrow(rivers2)) {
#         for (i in 1:nrow(rivers2)) {
#                 if (rivers2$has_received[i] != rivers2$receiving[i])
#                         next()
#                 if (rivers2$has_given[i] == rivers2$giving[i])
#                         next()
#                 giving_to <- rivers2$TO[i]
#                 rivers2[FROM == giving_to, c("has_received", "passed_down_score") := .(has_received + 1,
#                                                                                        rivers2$passed_down_score[i] * score_down)]
#                 rivers2$has_given[i] <- rivers2$has_given[i] + 1
#                 if (rivers2$has_given[i] == rivers2$giving[i]) {
#                         finished_rivers <- finished_rivers + 1
#                         print(paste("Finished rivers is", finished_rivers))
#                 }
#                 
#         }
# }
# rivers2[has_given != giving | has_received != receiving, finished := FALSE]
# rivers2[is.na(finished), finished := TRUE]
# 
# river3 <- st_as_sf(rivers2)
# st_write(river3, "001_data/karte_durchlässigkeit/map_maybe.gpkg")
