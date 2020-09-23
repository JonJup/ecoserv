# --------------------------- #
### --- Combine streams --- ### 
# --------------------------- #

# date created:21.08.20 
# date used   :21.08.20
# Jonathan Jupke 
# Ecoserv 
# Passability Map 

# Combine the stream networks form Pfälzerwald/Hunsrück, Nordvogesen, Saarland und Schwarzwald

# setup -------------------------------------------------------------------
pacman::p_load(sf, data.table, dplyr, magrittr, here, beepr)
setwd(here())

# load data ---------------------------------------------------------------
rn1 <- st_read("001_data/Gewaessernetze/Gewaessernetz_Pfalz_Hunsrueck/2020-08-23_fixed_pwh_river_network.gpkg")
rn2 <- st_read("001_data/Gewaessernetze/Gewaessernetz_Nordvogesen/2020-08-11_fixed_vdn_river_network.gpkg")
rn3 <- st_read("001_data/Gewaessernetze/Gewaessernetz_Schwarzwald/2020-08-20_fixed_swd_river_network.gpkg")
rn4 <- st_read("001_data/Gewaessernetze/Gewaessernetz_Saarland/2020-08-11_fixed_sar_river_network.gpkg")

# combine data  -----------------------------------------------------------
if (st_crs(rn4) != st_crs(rn1)) rn1 %<>% st_transform(crs = st_crs(rn4))
if (st_crs(rn4) != st_crs(rn2)) rn2 %<>% st_transform(crs = st_crs(rn4))
if (st_crs(rn4) != st_crs(rn3)) rn3 %<>% st_transform(crs = st_crs(rn4))

rn_all <- rbind(rn1,rn2, rn3, rn4)
# st_write(rn_all, paste0("001_data/map_passability/", Sys.Date(), "_test_find_double_streams.gpkg"))
# remove overlaps  --------------------------------------------------------

# I did not remove overlaps. Lets just see what happens

rn_all %<>% filter(!ecoserv_id %in% c("swd_32406", "swd_37658", "swd_37712", "swd_43986", "swd_67705", "swd_63726"))
split <- rn_all %>% 
        filter(ecoserv_id == "vdn_7861")  
split_points <- st_cast(split, "POINT")
split_lines <- st_split(x = split, y = split_points[77,]) %>% st_collection_extract(type = "LINESTRING")
what_region <- str_extract(split_lines$ecoserv_id[1], "[:alpha:]+")
current_max <-
        rn_all$ecoserv_id[str_detect(rivers$ecoserv_id, pattern = what_region)] %>%
        str_split_fixed(pattern = "_", n = 2) %>%
        .[, 2] %>%
        as.numeric() %>%
        max()
split_lines$ecoserv_id <- paste0(what_region, "_", current_max:(current_max+nrow(split_lines)-1))

split %<>% filter(ecoserv_id != "vdn_7861") 
rn_all <- rbind(rn_all, split_lines)

# tm_shape(split) + tm_lines() 
#         tm_shape(st_as_sf(rivers[ecoserv_id == "rlp_16958"])) + tm_lines() +
#         tm_shape(to_split[77,]) + tm_dots(col = "red") +
#         tm_shape(split_lines) + tm_lines(col  = "ecoserv_id")

# save to file  -----------------------------------------------------------
st_write(rn_all, paste0("001_data/map_passability/", Sys.Date(), "_all_networks_combined_and_split.gpkg"))

rm(list = ls())
