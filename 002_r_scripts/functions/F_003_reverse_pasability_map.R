# ---------------------------- #
### --- reverse function --- ###
# ---------------------------- #

# date written: 22.08.20 
# date changes: 23.10.20
# date used   : 22.08.20 
# Jonathan Jupke 
# Ecoserv 
# Passability Map 


reverse <- function(x) {
        
        new_to   <- pull(dt_rivers[ecoserv_id %in% x, "FROM"])
        new_from <- pull(dt_rivers[ecoserv_id %in% x, "TO"])
        dt_rivers[ecoserv_id %in% x, c("FROM", "TO") := .(new_from, new_to)]
        
}



# Change log ---------------------------------------------------------------
## -- 23.10.20 
# Changed the name of the river variable from "rivers" to "dt_rivers"