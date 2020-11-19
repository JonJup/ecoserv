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

# directories 
dir_pd = "003_processed_data/"
dir_rd = "001_raw_data/"

# load data ---------------------------------------------------------------
# dt_rivers = readRDS(file.path(dir_pd, "map_passability", "fixed_rivers.RDS"))
# st_sites  = readRDS(file.path(dir_rd, "probestellen", "2020-09-23_all_sites.RDS"))
source("002_r_scripts/passability_map/007_fix_flow_direction.R")


# carpeting ---------------------------------------------------------------
st_rivers = st_as_sf(dt_rivers)
if (st_crs(st_sites) != st_crs(st_rivers)) st_sites %<>% st_transform(crs = st_crs(st_rivers))


# fixes have been moved to 007_fix_flow_direction.R. See github history before 21.10.20

dt_rivers_loop <- copy(dt_rivers)
dt_rivers_loop[, row_id := 1:nrow(dt_rivers_loop)]
dt_rivers_loop[,evaled:=0]
st_rivers_loop = st_as_sf(dt_rivers_loop)
which(st_sites$site %in% c("ES001", "ES002", "ES003"))
for (j in c(16:18)) {
        start_segement <- st_nearest_feature(x = st_sites[j,], 
                                             y = st_rivers)
        last_id = start_segement
        dt_rivers_loop[start_segement,
                       c("score_up_eval", "score_down_eval", "evaled") :=
                               .(score_up, score_down, evaled + 1)]
        counter = 1 
        while (1 != 2) {
                
                # Which Point did the last segment flow into   
                # This object can be read as: 
                # The object in row names(going_to)[i] end in point going_to[[i]]
                        last_id_ul <- unlist(last_id)
                        pre_going_to <- dt_rivers_loop[last_id_ul, TO]
                        going_to <- list()
                        for (i in seq_along(pre_going_to)) {
                                going_to[[i]] <- pre_going_to[i]     
                                names(going_to)[i] <- as.character(unlist(last_id))[i]
                        }
                        
                        # What is the updated score of the last segment? 
                        # This object can be read as: 
                        # The object in row names(last_score_down)[i] has an updated score of last_score_down[[i]]
                        pre_last_score_down <- dt_rivers_loop[last_id_ul, score_down_eval]
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
                        (pre_nxt_stop <- which(dt_rivers_loop$FROM %in% going_to))
                        nxt_stop <- list()
                        for (i in seq_along(pre_nxt_stop)) {
                                # id of a row that is the next river segment 
                                nxt_stop[[i]] <-  pre_nxt_stop[i]
                                # Name = name of the point from which this one starts
                                # where does this one come from 
                                loop_from <- dt_rivers_loop[pre_nxt_stop[i], FROM]
                                loop_name <- dt_rivers_loop[row_id %in% as.character(unlist(last_id)) & TO == loop_from, row_id]
                                #if (length(loop_name) > 1) loop_name <- names(last_score_down)
                                names(nxt_stop)[i] <- loop_name
                        }
                        
                        if (length(nxt_stop) == 0) break()
                        for (i in seq_along(nxt_stop)) {
                                loop_var <- names(nxt_stop)[i]
                                dt_rivers_loop[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]), evaled+1)]
                                # dt_rivers_loop[nxt_stop[[i]], c("score_down_eval", "evaled") := .(score_down * unlist(last_score_down[loop_var]), 1)]
                        }
                        #dt_rivers_loop[nxt_stop, c("score_down_eval", "evaled") := .(score_down * last_score_down,1)]
                        last_id <- nxt_stop
                        print(paste0("round ", counter,": ", names(going_to)))
                        counter <- counter + 1
        }
}

## -- look at map -- ## 

dt_rivers_loop %>% 
        filter(evaled!=0) %>% 
        
        st_as_sf() %>% 
        tm_shape() + 
        tm_lines(col="score_down", palette = "Pastel1", scale = 4) 
   
old_temp <- dir("003_processed_data/map_passability/", pattern = "_workshop", full.names = T)
file.remove(old_temp)     
dt_rivers_loop %>%
        st_as_sf() %>%
        st_write(paste0(
                "003_processed_data/map_passability/",
                Sys.Date(),
                "_workshop_map.gpkg")
                )
