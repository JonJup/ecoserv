### --- reverse function --- #### 

# date written: 22.08.20 
# date changes: 
# date used   : 22.08.20 
# Jonathan Jupke 
# Ecoserv 
# Passability Map 


reverse <- function(x) {
        new_to   <- pull(rivers[x, "FROM"])
        new_from <- pull(rivers[x, "TO"])
        rivers[x, c("FROM", "TO") := .(new_from, new_to)]
        
}