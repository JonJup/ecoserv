#### ------------------------------ ### 
#### --- Create Map for Meeting --- ### 
#### ------------------------------ ### 

# date created: 17.09.20 
# date changed: 18.09.20 + 23. 
# date used: 17.09.20 + 18. +23. 

# create passability maps for the meeting 30.09.20 

# setup -------------------------------------------------------------------
pacman::p_load(sf, tmap, magrittr, dplyr, here, RColorBrewer,tmaptools)
setwd(here())


# load data ---------------------------------------------------------------
sf_pas      <- st_read("003_processed_data/map_passability/2020-08-27_temp_4326.gpkg")
sf_sites    <- st_read("003_processed_data/map_passability/2020-08-26_sites_for_plot.gpkg")
sf_pas_fake <- st_read("003_processed_data/map_passability/2020-09-20_fake_map_meeting.gpkg")
sf_tmo      <- st_read("001_raw_data/tmo_region_map/TMO_region.shp")
sf_schutz   <- st_read("../Ecoserv/001_data/Aussengrenzen_Schutzgebiete/DLM250_Schutzgebiete.shp")

# carpet data  ------------------------------------------------------------
# fake 
sf_pas_fake %<>% filter(evaled == 1)

# transform all to WGS84 
sf_pas      %<>% st_transform(crs = 4326)
sf_sites    %<>% st_transform(crs = 4326)
sf_pas_fake %<>% st_transform(crs = 4326)
sf_tmo      %<>% st_transform(crs = 4326)
sf_schutz      %<>% st_transform(crs = 4326)

# rename eval_score_down
names(sf_pas)[7]      <- "Passierwahrscheinlichkeit"
names(sf_pas_fake)[7] <- "Passierwahrscheinlichkeit"

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
sf_pas_fake_cropped <- st_crop(sf_pas_fake, crop_box_buffer)
sf_site_cropped     <- st_crop(sf_sites   , crop_box_buffer)
sf_tmo_cropped      <- st_crop(sf_tmo,      crop_box_buffer)
sf_schutz_cropped   <- st_crop(st_buffer(sf_schutz,0), crop_box_buffer)

# download open street map as background 
osm <- read_osm(sf_pas_cropped, ext=1.1) 

real <- osm %>%
  tm_shape() +
  tm_rgb(alpha = 0.5) +
  #tm_shape(sf_schutz_cropped) +
  #tm_polygons(alpha = 0.7) +
  tm_shape(sf_pas_cropped) +
  tm_lines(
    col = "Passierwahrscheinlichkeit",
    lwd = 2,
    palette = "RdYlGn",
    style = "pretty",
    n = 6,
    legend.hist = TRUE
  ) +
  tm_shape(sf_site_cropped) +
  tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white",
    frame = F,
    legend.frame = T,
    legend.outside = T
  )   
  
real

fake <- osm %>%
  tm_shape() +
  tm_rgb(alpha = 0.5) +
  #tm_shape(sf_tmo_cropped) +
  #tm_polygons(alpha = 0.7) +
  tm_shape(sf_pas_fake_cropped) +
  tm_lines(
    col = "Passierwahrscheinlichkeit",
    lwd = 2,
    palette = "RdYlGn",
    style = "pretty",
    n = 10,
    legend.hist = TRUE
  ) +
  tm_shape(sf_site_cropped) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white",
    frame = F,
    legend.frame = T,
    legend.outside = T
  )

fake

 # save to file  -----------------------------------------------------------

# tmap_save(filename = paste0("004_plots/passability_map/", Sys.Date(), "_map_meeting.jpeg"), tm = real)
# tmap_save(filename = paste0("004_plots/passability_map/", Sys.Date(), "_map_meeting_fake.jpeg"), tm = fake)


