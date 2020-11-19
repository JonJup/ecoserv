### --- Ecoserv 
### --- Downstream colonization with CDMetaPOP
### --- 19.11.20 
### --- Call script 


st_rivers = st_as_sf(dt_rivers)

# in case the coordinates reference system (crs) of sites is not the same as that of the rivers ... 
if (st_crs(st_sites) != st_crs(st_rivers)) {
        st_sites %<>% st_transform(crs = st_crs(st_rivers))
}

dt_rivers_loop <- copy(dt_rivers)
dt_rivers_loop[, row_id := 1:nrow(dt_rivers_loop)]
dt_rivers_loop[,evaled:=0]
st_rivers_loop = st_as_sf(dt_rivers_loop)

for (j in int_start_site) { # START LOOP 1 
        
        # find the river segment that is closest to the point (i.e. the start segment)
        start_segement <- st_nearest_feature(x = st_sites[j,], 
                                             y = st_rivers)
        # the last_id variable hold the segment from which "water is coming" 
        last_id = start_segement
        # assign the start segment its own scores for up and down and mark it as evaled 
        dt_rivers_loop[start_segement,
                       c("score_up_eval", "score_down_eval", "evaled") :=
                               .(score_up, score_down, evaled + 1)]
        
        # The counter variable ounts the rounds inside the while loop 
        counter = 1 
        # While loop with a trivial always true condition. 
        # Only stops through break() commands   
        while (1 != 2) {# START WHILE 1
                
                # Which Point did the last segment flow into   
                # This object can be read as: 
                # The object in row names(going_to)[i] ends in point going_to[[i]]
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
        } # END WHILE1
        rm(loop_var, going_to, last_id_ul, pre_going_to, loop_from, loop_name, nxt_stop, pre_nxt_stop, 
           pre_last_score_down, last_id, dup_id, dup_score_down, counter, start_segement, max_id, last_score_down, dt_riv)
} # END LOOP1 
rm(i,j, st_rivers_loop)




