# -------------------------------- #
### --- Plot passability map --- ### 
# -------------------------------- #

#date written: 27.08.20 
#date changes: 
#date used   : 27.08.20 + 28. 
#Jonathan Jupke 
# Ecoserv 
# Passability Map 

#-- what? -- # 
# Plot passability map for Ecoserv  

#TODO color palette
#TODO save
#TODO background map 

# source ------------------------------------------------------------------
pacman::p_load(sf,tmap, magrittr, dplyr, tmaptools, OpenStreetMap )
setwd(here())
data(NLD_muni)
osm_NLD <- read_osm(NLD_muni, ext=1.1)

tm_shape(osm_NLD) + tm_rgb()


data <- st_read("001_data/map_passability/2020-08-27_temp.gpkg")
data %<>% st_transform(crs = 4326)
st_write(data, "001_data/map_passability/2020-08-27_temp_4326.gpkg")


# data %<>% mutate("passability_down_class" = ifelse(evaled == 0, NA, 
#                                                    ifelse(score_down_eval == 0.0, 7,
#                                                    ifelse(score_down_eval  > 0.0 & score_down_eval <= 0.2, 6,
#                                                    ifelse(score_down_eval  > 0.2 & score_down_eval <= 0.4, 5,
#                                                    ifelse(score_down_eval  > 0.4 & score_down_eval <= 0.6, 4,
#                                                    ifelse(score_down_eval  > 0.6 & score_down_eval <= 0.8, 3,
#                                                    ifelse(score_down_eval  > 0.8 & score_down_eval <= 1.0, 2,1
#                                                           ))))))))

data %<>% mutate("dp_inv" = 1 - score_down_eval)

data %<>% mutate("alpha_var" = ifelse(evaled == 0, 0.1, 1))  
data$passability_down_class_f <- factor(data$passability_down_class)
data_e <- filter(data, evaled == 1)
# tmo <- tm_shape(data[1:1000, ]) + tm_lines(col = "passability_down_class", lwd = "alpha_var")


tmo <- tm_shape(data_e) + 
        tm_lines(col = "dp_inv", 
                                   lwd = 2,
                                   legend.hist = TRUE,
                                   palette = "YlOrRd") + 
        tm_layout(legend.outside = TRUE, 
                  legend.show = T)
        
tmo
tmap_mode("view")
tmap_mode("plot")
