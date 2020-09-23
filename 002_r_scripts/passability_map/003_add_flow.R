# ---------------------------------- #
### --- Durchlässigkeitskarten --- ### 
# ---------------------------------- #

#date written: 21.08.20 
#date changes: 
#date used   : 21.08.20 + 25 
#Jonathan Jupke 
# Ecoserv 
# Passability Map 

#-- what? -- # 
# To create a map I need to get the flow direction in every case. This requires several steps: 
# i) extract junction points and find their height 
# ii) from this I can see which stream flows into which and check that this is correct with the height

# Setup -------------------------------------------------------------------
pacman::p_load(sf, dplyr, magrittr, here, tmap, data.table, purrr, raster, stringr)
setwd(here())

# load data ---------------------------------------------------------------
data <- st_read(dsn = "001_data/map_passability/2020-08-25_all_networks_combined_and_split.gpkg")
dem  <- raster("001_data/DEM/DEM_Europe/eu_dem_merged.tif")

# prepare data  -----------------------------------------------------------
# remove empty elements 
data <- data[!st_is_empty(data),]
# check for duplicates 
dup_id <- which(duplicated(data$ecoserv_id))
data[dup_id, ]

for (i in seq_along(dup_id)) {
        org_data <- data$ecoserv_id[dup_id[i]]
        org_data %<>% str_remove("_.*") 
        org_data_ids <- str_detect(string = data$ecoserv_id, pattern = org_data)
        all_ids <- data$ecoserv_id[org_data_ids] %>% str_remove(".*_") %>% 
                as.numeric
        new_id <- max(all_ids) + 1
        data$ecoserv_id[dup_id[i]] <- paste0(org_data, "_", new_id) 
        rm(org_data, org_data_ids, all_ids, new_id);gc()
}
rm(i);gc()
# check again 
if (length(which(duplicated(data$ecoserv_id))) == 0) print("passed") else print("failed")
rm(dup_id);gc()
# check for NAs 
na_id <- which(is.na(data$ecoserv_id))
# data[na_id, ]
# data %>% filter(is.na(ABSCHNITT)) %>% plot
# data <- data[-na_id,]
rm(na_id);gc()
# bring dem and river network to same CRS 
data %<>% st_transform(crs = raster::crs(dem))
# visual check -- good 
# plot(dem)
# plot(data, add = T)
dem_crop <- raster::crop(x = dem, y = data)
# visual check -- good 
# plot(dem_crop)
# plot(data, add = T)
rm(dem);gc()

# extract start and end points --------------------------------------------
# function to extract start and end points from stream segements and add their heights 
river_to_start_end_point <- function(index) {
        
        casted     <- st_cast(data[index,], to = "POINT")
        start_end  <- casted[c(1,nrow(casted)),]
        id_numbers <- c(2 * index - 1, 2 * index)
        start_end  %<>% mutate(ID = c(paste0("P", id_numbers[1]), 
                                      paste0("P", id_numbers[2])))
        start_end$height <- raster::extract(x = dem_crop, 
                                            y = start_end)
        return(start_end)
        
}

 



