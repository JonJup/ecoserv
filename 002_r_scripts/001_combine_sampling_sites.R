# ---------------------------------- # 
### --- Combine Sampling sites --- ### 
# ---------------------------------- #

# Ecoserv 
#date 27.05.20 
#Combine sampling sites from Thomas Schmidt 


# setup -------------------------------------------------------------------

pacman::p_load(sf, tmap, here, magrittr, dplyr, ggmap, rgeos)

tmap_mode("plot")

setwd(here())

# read in data  -----------------------------------------------------------

sites_fr <- st_read("001_raw_data/probestellen/frankreich/ECOSERV_sites (FRA).shp")
sites_pw <- st_read("001_raw_data/probestellen/pfaelzerwald/pot_PW.shp") 
sites_hr <- st_read("001_raw_data/probestellen/hunsrueck/perselHunsrueck.shp")
sites_sw <- st_read("001_raw_data/probestellen/schwarzwald/Schwarzwaldforelle.shp")

# set projections
sites_fr <- st_set_crs(sites_fr, value = 4284)
sites_hr <- st_set_crs(sites_hr, value = 31464)

# transform to WGS84 
sites_fr <- st_transform(sites_fr, crs = 4326)
sites_pw <- st_transform(sites_pw, crs = 4326)
sites_hr <- st_transform(sites_hr, crs = 4326)

# homogenize variables 
sites_fr %<>% dplyr::select(-c("NsampCG", "NsampST")) %>% st_zm()
sites_pw %<>% mutate(site = paste0("PW_0", id)) %>% dplyr::select(-id)
sites_pw$bow = NA
sites_hr %<>% mutate(site = paste0("HR_0", 1:nrow(sites_hr)))
sites_hr$bow = NA
sites_sw %<>% st_zm()

all_sites <- rbind(sites_pw, sites_hr, sites_fr, sites_sw)

saveRDS(object = all_sites,
        file = paste0("001_raw_data/probestellen/",Sys.Date(),"_all_sites.RDS"))

rm(list = ls())