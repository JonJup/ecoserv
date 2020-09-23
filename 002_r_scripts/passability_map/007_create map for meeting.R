#### ------------------------------ ### 
#### --- Create Map for Meeting --- ### 
#### ------------------------------ ### 

# date created: 17.09.20 
# date changed: 18.09.20 
# date used: 17.09.20 + 18. 



# setup -------------------------------------------------------------------
pacman::p_load(sf, tmap, magrittr, dplyr, here, RColorBrewer,tmaptools)
setwd(here())


# load data ---------------------------------------------------------------
data      <- st_read("001_data/map_passability/2020-08-27_temp_4326.gpkg")
sites     <- st_read("001_data/map_passability/2020-08-26_sites_for_plot.gpkg")
data_fake <- st_read("001_data/map_passability/2020-09-20_fake_map_meeting.gpkg")
tmo       <- st_read("001_data/tmo_region_map/TMO_region.shp")


# carpet data  ------------------------------------------------------------
# fake 
data_fake %<>% filter(evaled == 1)

# transform all to WGS84 

data      %<>% st_transform(crs = 4326)
sites     %<>% st_transform(crs = 4326)
data_fake %<>% st_transform(crs = 4326)
tmo       %<>% st_transform(crs = 4326)

names(data)[7] <- "Passierwahrscheinlichkeit"
names(data_fake)[7] <- "Passierwahrscheinlichkeit"


tm_shape(data) + tm_lines() + tm_shape(sites) + tm_dots()
crop_box <- st_bbox(filter(sites, site %in% c("ES001", "ES005", "PW_05", "ES013")))

crop_box_buffer <- crop_box * c(
        0.990, #xmin
        0.990, #ymin
        1.100, #xmax
        1.003  #ymax
        )

data_cropped      <- st_crop(data, crop_box_buffer)
fake_data_cropped <- st_crop(data_fake, crop_box_buffer)
site_cropped      <- st_crop(sites, crop_box_buffer)

osm <- read_osm(data_cropped, ext=1.1) 

real <- osm %>%
  tm_shape() +
  tm_rgb(alpha = 0.5) +
  tm_shape(tmo) +
  tm_polygons(alpha = 0.5) +
  tm_shape(data_cropped) +
  tm_lines(
    
    col = "Passierwahrscheinlichkeit",
    lwd = 2,
    palette = "RdYlGn",
    style = "pretty",
    n = 6,
    legend.hist = TRUE
  ) +
  tm_shape(site_cropped) +
  tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white",
    frame = F,
    legend.frame = T,
    legend.outside = T
  )   
  
real

fake <- osm %>%
  tm_shape() + tm_rgb(alpha = 0.5) +
  tm_shape(tmo) + tm_polygons() + 
  tm_shape(fake_data_cropped) + tm_lines(
    col = "Passierwahrscheinlichkeit",
    lwd = 3,
    palette = "RdYlGn",
    style = "pretty",
    n = 10,
    legend.hist = TRUE
  ) +
  tm_shape(site_cropped) + tm_dots(size = .5) +
  tm_layout(
    legend.bg.color = "white",
    frame = F,
    legend.frame = T,
    legend.outside = T
  ) 

fake

tmap_save(filename = "~/../Desktop/real.pdf", tm = real)
tmap_save(filename = "~/../Desktop/fake.pdf", tm = fake)


