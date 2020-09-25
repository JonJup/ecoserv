#### ------------------------------ ### 
#### --- Create Map for Meeting --- ### 
#### --- Barrier subsets ---------- ### 
#### ------------------------------ ### 

# date created: 25.09.20 
# date changed: 
# date used: 25.09.20

# create passability maps for the meeting 30.09.20 

# setup -------------------------------------------------------------------
pacman::p_load(sf, tmap, magrittr, dplyr, here, RColorBrewer,tmaptools)
setwd(here())


# load data ---------------------------------------------------------------
sf_08    <- readRDS("003_processed_data/map_passability/maps_w_removed_barriers/2020-09-25_final_passability_map08.RDS")
sf_06    <- readRDS("003_processed_data/map_passability/maps_w_removed_barriers/2020-09-25_final_passability_map06.RDS")
sf_04    <- readRDS("003_processed_data/map_passability/maps_w_removed_barriers/2020-09-25_final_passability_map04.RDS")
sf_02    <- readRDS("003_processed_data/map_passability/maps_w_removed_barriers/2020-09-25_final_passability_map02.RDS")
sf_sites <- readRDS("001_raw_data/probestellen/2020-09-23_all_sites.RDS")
#sf_sites    <- st_read("003_processed_data/map_passability/2020-08-26_sites_for_plot.gpkg")

# carpet data  ------------------------------------------------------------
# fake 

vec_files <- ls()
for (i in seq_along(vec_files)) {
  chr_loop_name <- vec_files[i]
  dt_loop <- get(chr_loop_name)
  if (!grepl(pattern = "sites", x = chr_loop_name)){
    dt_loop %<>% filter(evaled == 1)
    names(dt_loop)[7] <- "Passierwahrscheinlichkeit"
  }
  sf_loop <- st_as_sf(dt_loop)
  sf_loop %<>% st_transform(crs = 4326)
  assign(x = chr_loop_name,
         value = sf_loop)
  rm(sf_loop, chr_loop_name,i, dt_loop);gc()
}

# create box to crop streams 
crop_box <- st_bbox(filter(sf_sites, site %in% c("ES001", "ES005", "PW_05", "ES013")))

crop_box_buffer <- crop_box * c(
        0.990, #xmin
        0.990, #ymin
        1.100, #xmax
        1.003  #ymax
        )

for (i in seq_along(vec_files)) {
  chr_loop_name <- vec_files[i]
  sf_loop <- get(chr_loop_name)
  sf_loop <- st_crop(sf_loop, crop_box_buffer)
  assign(x = paste0("crop_",chr_loop_name),
         value = sf_loop)
  rm(sf_loop, chr_loop_name,i);gc()
}


# download open street map as background 
osm <- read_osm(crop_sf_02, ext=1.1) 

## palette 
color_pal <- brewer.pal(name = "RdYlGn", n = 10)
color_pal <- color_pal[c(1,3,5,7,10)] 
# map 02 
map02 <- osm %>% 
  tm_shape() + tm_rgb(alpha = 0.5) +
  tm_shape(crop_sf_02) +tm_lines(col = "Passierwahrscheinlichkeit",lwd = 2,palette = color_pal,
                                 style = "pretty",n = 6,legend.hist = TRUE) +
  tm_shape(crop_sf_sites) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white", frame = F,
    legend.frame = T,
    legend.outside = T,
    title = "80% entfernt"
  )   
map04 <- osm %>% 
  tm_shape() + tm_rgb(alpha = 0.5) +
  tm_shape(crop_sf_04) +tm_lines(col = "Passierwahrscheinlichkeit",lwd = 2,palette = color_pal,
                                 style = "pretty",n = 6,legend.hist = TRUE) +
  tm_shape(crop_sf_sites) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white", frame = F,
    legend.frame = T,
    legend.outside = ,
    title = "60% entfernt"
  )     
map06 <- osm %>% 
  tm_shape() + tm_rgb(alpha = 0.5) +
  tm_shape(crop_sf_06) +tm_lines(col = "Passierwahrscheinlichkeit",lwd = 2,palette = color_pal,
                                 style = "pretty",n = 6,legend.hist = TRUE) +
  tm_shape(crop_sf_sites) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white", frame = F,
    legend.frame = T,
    legend.outside = T,
    title = "40% entfernt"
  )     
map08 <- osm %>% 
  tm_shape() + tm_rgb(alpha = 0.5) +
  tm_shape(crop_sf_08) +tm_lines(col = "Passierwahrscheinlichkeit",lwd = 2,palette = color_pal,
                                 style = "pretty",n = 6,legend.hist = TRUE) +
  tm_shape(crop_sf_sites) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white", frame = F,
    legend.frame = T,
    legend.outside = T,
    title = "20% entfernt"
  )   

 # save to file  -----------------------------------------------------------

tmap_save(filename = paste0("004_plots/passability_map/removed_barriers/", Sys.Date(), "_20removed.jpeg"), tm = map08)
tmap_save(filename = paste0("004_plots/passability_map/removed_barriers/", Sys.Date(), "_40removed.jpeg"), tm = map06)
tmap_save(filename = paste0("004_plots/passability_map/removed_barriers/", Sys.Date(), "_60removed.jpeg"), tm = map04)
tmap_save(filename = paste0("004_plots/passability_map/removed_barriers/", Sys.Date(), "_80removed.jpeg"), tm = map02)


