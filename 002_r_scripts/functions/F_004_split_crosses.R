#### ---- FUNCTION: FIX CROSSES ---- ####

# date created:31.07.20 
# Jonathan Jupke 
# project: ECOSERV
# connected scripts: map_passability/001_split_streams.R  


# split stream segments that cross others 

fix_crosses  <- function(id) {
split_lines  <- NULL
river_subset <- data[st_crosses(data[id, ], data)[[1]],]
out_val      <- ifelse(nrow(river_subset) > 1, T, F)
if (out_val) {
        split_lines <- st_split(x = data[id, ],
                                y =  river_subset)
        split_lines %<>% st_collection_extract(type = "LINESTRING")
}
return(split_lines)
}