# ---------------------------------- #
### --- Create passability map --- ###
# ---------------------------------- #

#date written: 25.09
#date changes:
#date used   : 25.09
#Jonathan Jupke
# Ecoserv
# Passability Map

#-- what? -- #
# Create passability map for Ecoserv. With subsets of barriers only


# setup -------------------------------------------------------------------
pacman::p_load(sf,
               dplyr,
               magrittr,
               here,
               purrr,
               data.table,
               tmap,
               lwgeom,
               stringr)
setwd(here())


samples  <-
        readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")
source("002_r_scripts/functions/F_003_reverse_pasability_map.R")


# Here the loop over the different barrier subsets starts
for (num_loo in c("02", "04", "06", "08")) {
        file_name <-
                paste0("2020-09-25_rivers_w_flow_and_", num_loo, "barriers.RDS")
        rivers <-
                readRDS(
                        paste0(
                                "003_processed_data/map_passability/maps_w_removed_barriers/",
                                file_name
                        )
                )
        rm(file_name)
        rivers %<>% st_as_sf()
        if (st_crs(samples) != st_crs(rivers))
                samples %<>% st_transform(crs = st_crs(rivers))
        setDT(rivers)
        
        # fixes -------------------------------------------------------------------
        rivers  <-
                rivers[!ecoserv_id %in% c(
                        "swd_32406",
                        "swd_37658",
                        "swd_37712",
                        "swd_43986",
                        "swd_67705",
                        "swd_63726",
                        "vdn_7861",
                        "swd_67704",
                        "swd_40883",
                        "swd_19631",
                        "swd_71703",
                        "swd_64280",
                        "swd_64279",
                        "swd_48147",
                        "swd_71961",
                        "swd_71702",
                        "swd_34009"
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
        rivers[ecoserv_id %in% c("vdn_6657", "vdn_6658", "vdn_6660"), c("FROM", "TO") := c(1, 2, 3)]
        
        reverse(
                c(
                        29,
                        1259,
                        1286,
                        1287,
                        1288,
                        1295,
                        1316,
                        1317,
                        1324,
                        1512,
                        1517,
                        1579,
                        1649,
                        1657,
                        1685,
                        1736,
                        1737,
                        1741,
                        1763,
                        1771,
                        1772,
                        1811,
                        1818,
                        1820,
                        1824,
                        1852,
                        1585,
                        1904,
                        1905,
                        1948,
                        2356,
                        2378,
                        2399,
                        2452,
                        2477,
                        2488,
                        2494,
                        2510,
                        2580,
                        2627,
                        2897,
                        2937,
                        3461,
                        3462,
                        5068,
                        5088,
                        5091,
                        5095,
                        5106,
                        5140,
                        5153,
                        5156,
                        5216,
                        5224,
                        5279,
                        5325,
                        5335,
                        6102,
                        6111,
                        6113,
                        8308,
                        9580,
                        10816,
                        11344,
                        11360 ,
                        11578,
                        12365,
                        12834,
                        13065,
                        14412,
                        14413,
                        14314,
                        14336,
                        14341,
                        14351,
                        14355,
                        14356,
                        14369,
                        14379,
                        14628,
                        14632,
                        14641,
                        14643,
                        14905,
                        14906,
                        14907,
                        14908,
                        14909,
                        14989,
                        15045,
                        15046,
                        29568,
                        29571,
                        37418,
                        37417,
                        37416,
                        37419,
                        37415,
                        37414,
                        37413,
                        37412,
                        37411,
                        37410,
                        37409,
                        37387,
                        37385,
                        35860,
                        43338,
                        57058,
                        57069,
                        57078,
                        58962,
                        62084,
                        62093,
                        62836,
                        62833,
                        62837,
                        62855,
                        62864,
                        62686,
                        63704,
                        63705,
                        63706,
                        63707 ,
                        63709,
                        63711,
                        63713,
                        63716,
                        63717
                        
                        
                        # Fakies: Sind richtig aber aus praktischen Gründen umgedreht
                        # 16 ist schon Rhein
                        
                )
        )
        
        
        
        new_row <- data.table(
                ecoserv_id = paste0("rlp_x_00", 1:2),
                FROM       = c("P42", "P52"),
                TO         = c("P44", "P2183"),
                score_up   = 1,
                score_down = 1,
                geom       = c(rivers[TO == "P42", geom],
                               rivers[TO == "P52", geom])
        )
        
        rivers <- rbindlist(list(rivers, new_row))
        
        rivers[, c("score_up_eval", "score_down_eval", "evaled") := .(1, 1, 0)]
        
        
        # test_rivers[TO == "P10554"]
        test_rivers <- copy(rivers)
        test_rivers[, row_id := 1:nrow(test_rivers)]
        for (j in c(1:31)) {
                test_rivers %<>% st_as_sf()
                start_segement <- st_nearest_feature(x = samples[j, ],
                                                     y = test_rivers)
                setDT(test_rivers)
                last_id = start_segement
                test_rivers[start_segement, c("score_up_eval", "score_down_eval", "evaled") := .(score_up, score_down, 1)]
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
                                names(going_to)[i] <-
                                        as.character(unlist(last_id))[i]
                        }
                        
                        # What is the updated score of the last segement?
                        # This object can be read as:
                        # The object in row names(last_score_down)[i] has an updated score of last_score_down[[i]]
                        pre_last_score_down <-
                                test_rivers[last_id_ul, score_down_eval]
                        last_score_down <- list()
                        for (g in seq_along(pre_last_score_down)) {
                                last_score_down[[g]] <- pre_last_score_down[g]
                                names(last_score_down)[g] <-
                                        as.character(unlist(last_id))[g]
                        }
                        if (sum(duplicated(going_to)) != 0) {
                                dup_id <- which(duplicated(going_to))
                                # note 27.08: I removed two brackets around dup_id and added the unlists
                                dup_id <-
                                        which(unlist(going_to) %in% unlist(going_to[dup_id]))
                                dup_score_down <-
                                        last_score_down[dup_id]
                                max_id <-
                                        which(dup_score_down == max(unlist(
                                                dup_score_down
                                        )))
                                last_score_down[dup_id] <-
                                        last_score_down[max_id]
                        }
                        
                        
                        
                        # What rivers start from the last end point
                        # The object pre_nxt_stop is a vector with object row numbers
                        # The object nxt_stop is a list with
                        (pre_nxt_stop <-
                                        which(test_rivers$FROM %in% going_to))
                        nxt_stop <- list()
                        for (i in seq_along(pre_nxt_stop)) {
                                # id of a row that is the next river segment
                                nxt_stop[[i]] <-  pre_nxt_stop[i]
                                # Name = name of the point from which this one starts
                                # where does this one come from
                                loop_from <-
                                        test_rivers[pre_nxt_stop[i], FROM]
                                loop_name <-
                                        test_rivers[row_id %in% as.character(unlist(last_id)) &
                                                            TO == loop_from, row_id]
                                #if (length(loop_name) > 1) loop_name <- names(last_score_down)
                                names(nxt_stop)[i] <- loop_name
                        }
                        
                        if (length(nxt_stop) == 0)
                                break()
                        for (i in seq_along(nxt_stop)) {
                                loop_var <- names(nxt_stop)[i]
                                test_rivers[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]),
                                                                                               1)]
                                # test_rivers[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]), 1)]
                        }
                        #test_rivers[nxt_stop, c("score_down_eval", "evaled") := .(score_down * last_score_down,1)]
                        last_id <- nxt_stop
                        print(paste0(
                                "round ",
                                counter,
                                ": ",
                                names(going_to)
                        ))
                        counter <- counter + 1
                }
        }
        
        
        # save to file ------------------------------------------------------------
        
   
        
        saveRDS(
                test_rivers,
                paste0(
                        "003_processed_data/map_passability/",
                        Sys.Date(),
                        "_final_passability_map",
                        num_loo,
                        ".RDS"
                )
        )
        to_remove <- setdiff(x = ls(), 
                y = c("samples", "reverse"))
        rm(list = to_remove)
        rm(to_remove);gc()
        
        
}
