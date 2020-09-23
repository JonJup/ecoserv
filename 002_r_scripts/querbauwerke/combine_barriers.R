# ---------------------------- #
### --- Combine Barriers --- ###
# ---------------------------- #

#date written: 22.08.20 
#date changes: 
#date used   : 22.08.20 
#Jonathan Jupke 
# Ecoserv 
# Barriers 

#-- what? -- # 
# Take all single barrier files and combine them into one 


# setup -------------------------------------------------------------------
pacman::p_load(sf, here, data.table, magrittr, dplyr)
setwd(here())

# load data ---------------------------------------------------------------
b1 <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/2020-06-18_qbw_rlp_hr_final.gpkg") 
b2 <- readRDS("001_data/Querbauwerke/Querbauwerke_Nordvogesen/2020-08-04_vdn_amber_clean.RDS")
b3 <- readRDS("001_data/Querbauwerke/Querbauwerke_Schwarzwald/2020-08-04qbw_sw_clean.RDS")

# carpet ------------------------------------------------------------------
b2 %<>% st_as_sf()
b3 %<>% st_as_sf()

if (st_crs(b1) != st_crs(b2)) b2 <- st_transform(b2, crs = st_crs(b1))
if (st_crs(b1) != st_crs(b3)) b3 <- st_transform(b3, crs = st_crs(b1))

b1$ecoserv_barrier_id <- paste0("rlp_bar_", 1:nrow(b1))
b2$ecoserv_barrier_id <- paste0("vdn_bar_", 1:nrow(b2))
b3$ecoserv_barrier_id <- paste0("swd_bar_", 1:nrow(b3))

b1 %<>% select(ecoserv_barrier_id, score_down, score_up)
b2 %<>% select(ecoserv_barrier_id, score_down, score_up)
b3 %<>% select(ecoserv_barrier_id, score_down, score_up)

# Combine  -----------------------------------------------------------------
b_all <- rbind(b1,b2,b3)

plot(b_all)

# Save to file  ----------------------------------------------------------
st_write(dsn = paste0("001_data/Querbauwerke/", Sys.Date(), "_all_barriers.gpkg"), 
         obj = b_all)

