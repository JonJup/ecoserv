### -------------------- ###
### --- split stream --- ### 
### -------------------- ###

#date created:31.07.20 
#date used   :31.07.20, 23.08
# Split stream segments at each inflow

# setup -------------------------------------------------------------------
pacman::p_load(sf, here, dplyr, magrittr, beepr, tmap, stringr, lwgeom, data.table, purrr, furrr)
setwd(here())

source("002_r_scripts/functions/F_004_split_crosses.R")
source("002_r_scripts/functions/F_005_split_touches.R")
# load data ---------------------------------------------------------------
rn1 <- st_read("001_raw_data/gewaessernetze/Gewaessernetz_Pfalz_Hunsrueck/2020-07-31_fixed_rlp_river_network.gpkg")
rn2 <- st_read("001_raw_data/gewaessernetze/Gewaessernetz_Nordvogesen/River.shp")
rn3 <- st_read("001_raw_data/gewaessernetze/Gewaessernetz_Saarland/Gewaesser/gewaesser.gpkg")
rn4 <- st_read("001_raw_data/gewaessernetze/Gewaessernetz_Schwarzwald/Gewaessernetz.shp")

# maps  -------------------------------------------------------------------
#tm_shape(rn1) + tm_lines() + tm_shape(rn2) + tm_lines() + tm_shape(rn3) + tm_lines() + tm_shape(rn4) + tm_lines()

# carpet to common format  ------------------------------------------------
rn1 %<>% mutate(ecoserv_id = paste0("rlp_", 1:nrow(rn1))) %>% select(ecoserv_id)
rn2 %<>% mutate(ecoserv_id = paste0("vdn_", 1:nrow(rn2))) %>% select(ecoserv_id)
rn3 %<>% mutate(ecoserv_id = paste0("sar_", 1:nrow(rn3))) %>% select(ecoserv_id)
rn4 %<>% mutate(ecoserv_id = paste0("swd_", 1:nrow(rn4))) %>% select(ecoserv_id)

rn3 %<>% st_zm()
rn4 %<>% st_zm()

# split junctions  --------------------------------------------------------


##### -----             Choose River Network                ----- #####
# Choose one of the river networks 
data <- rn1 
data <- rn2 
data <- rn3 
data <- rn4 
##### -----             Choose River Network end            ----- #####


plan(multicore, 
     workers = 6)

##### -----             Run Fix Crosses         ----- #####
# run fix crosses via purrr::map_dfr
# n_crosses <- 1
# while (n_crosses != 0) {
# 
# fix_crosses_output <- future_map_dfr(.x = 1:nrow(data),
#                                      .f = fix_crosses,
#                                      .progress = T)
# 
# n_crosses <- nrow(fix_crosses_output)
# if(n_crosses == 0) break()
# # all unique ecoserv_ids in the fixed data, i.e. all stream segments that will be altered 
# fix_crosses_ids    <- unique(fix_crosses_output$ecoserv_id)
# # which rows in the data set correspond to these ids 
# to_be_fixed_ids    <- which(data$ecoserv_id %in% fix_crosses_ids)
# # remove the rows with unsplit segments. The new split segments will be added later. 
# data               <- data[- to_be_fixed_ids,]
# saveRDS(data, "001_data/Gewaessernetze/Gewaessernetz_Pfalz_Hunsrueck/temp_pwhr_cross.RDS")
# }
##### .....             END fix Crosses         ..... #####
##### -----             Run Fix Touches         ----- #####
# run fix crosses via purrr::map_dfr
n_touches <- 1
counter   <- 1 
while (n_touches != 0) {
        fix_touches_output <- map_dfr(.x = 1:nrow(data), 
                                      .f = fix_touch); beepr::beep()
        n_touches <- nrow(fix_touches_output)
        if(n_touches == 0) break()
        fix_touches_ids    <- unique(fix_touches_output$ecoserv_id)
        to_be_fixed_ids    <- which(data$ecoserv_id %in% fix_touches_ids)
        data               <- data[- to_be_fixed_ids,]
        prefix             <- str_remove(data$ecoserv_id[1], "_[0-9]*")
        number             <- str_remove_all(data$ecoserv_id, "[a-z]*_") %>% as.numeric() %>% max + 1
        fix_touches_output$ecoserv_id <- paste0(prefix, "_", number:(number + (nrow(fix_touches_output) - 1)))
        data               <- rbind(data, fix_touches_output)
        saveRDS(data, "001_data/Gewaessernetze/Gewaessernetz_Schwarzwald/temp_sw_cross.RDS")
        print(paste("Finished run", counter, "with", n_touches, "rows remaining @", Sys.time()))
        counter <- counter + 1
}
        ##### .....             END Fix Touches         ..... #####
# Save To File  -----------------------------------------------------------


st_write(data, paste0("001_data/Gewaessernetze/Gewaessernetz_Pfalz_Hunsrueck/",Sys.Date(), "_fixed_pwh_river_network.gpkg"))
#st_write(data, paste0("001_data/Gewaessernetze/Gewaessernetz_Nordvogesen/",Sys.Date(), "_fixed_vdn_river_network.gpkg"))
#st_write(data, paste0("001_data/Gewaessernetze/Gewässernetz_Saarland/"    ,Sys.Date(), "_fixed_sar_river_network.gpkg"))
#st_write(data, paste0("001_data/Gewaessernetze/Gewaessernetz_Schwarzwald/",Sys.Date(), "_fixed_swd_river_network.gpkg"))


