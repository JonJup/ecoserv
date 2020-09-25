#### ------------------------------ ### 
#### --- Create Map for Meeting --- ### 
#### ------------------------------ ### 

# date created: 25.09.20 
# date changed: 
# date used: 25.09.20

# create passability maps for the meeting 30.09.20 with fake barrier values

# setup -------------------------------------------------------------------
pacman::p_load(sf, tmap, magrittr, dplyr, here, RColorBrewer,tmaptools)
setwd(here())


# load data ---------------------------------------------------------------
sf_pas      <- readRDS("003_processed_data/map_passability/fake map/2020-09-25_final_passability_map_fake.RDS")
sf_sites    <- st_read("003_processed_data/map_passability/2020-08-26_sites_for_plot.gpkg")

# carpet data  ------------------------------------------------------------
# fake 
sf_pas %<>% filter(evaled == 1) %>% st_as_sf()

# transform all to WGS84 
sf_pas      %<>% st_transform(crs = 4326)
sf_sites    %<>% st_transform(crs = 4326)

# rename eval_score_down
names(sf_pas)[7]      <- "Passierwahrscheinlichkeit"

# create box to crop streams 
crop_box <- st_bbox(filter(sf_sites, site %in% c("ES001", "ES005", "PW_05", "ES013")))

crop_box_buffer <- crop_box * c(
        0.990, #xmin
        0.990, #ymin
        1.100, #xmax
        1.003  #ymax
        )

# crop data 
sf_pas_cropped      <- st_crop(sf_pas     , crop_box_buffer)
sf_site_cropped     <- st_crop(sf_sites   , crop_box_buffer)

# download open street map as background 
osm <- read_osm(sf_pas_cropped, ext=1.1) 

color_pal <- brewer.pal(name = "RdYlGn", n = 10)
color_pal <- color_pal[c(1,3,5,7,10)] 

plot_pas <- osm %>%
  tm_shape() +
  tm_rgb(alpha = 0.5) +
  tm_shape(sf_pas_cropped) +
  tm_lines(
    col = "Passierwahrscheinlichkeit",
    lwd = 2,
    palette = color_pal,
    style = "pretty",
    n = 11,
    legend.hist = TRUE
  ) +
  tm_shape(sf_site_cropped) +
  tm_dots(size = .5) +
  tm_layout(
    title = "Höhere Auflösung",
    legend.bg.color = "white",
    frame = F,
    legend.frame = T,
    legend.outside = T
  )   
  
plot_pas


 # save to file  -----------------------------------------------------------

 tmap_save(filename = paste0("004_plots/passability_map/", Sys.Date(), "_map_meeting_hohe_aufloesung.jpeg"), tm = plot_pas)



