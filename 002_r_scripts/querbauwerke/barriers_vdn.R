### ------------------------ ###
### --- Barrier file VDN --- ### 
### ------------------------ ###

#date: 04.08.20 

# setup -------------------------------------------------------------------
pacman::p_load(here, sf, dplyr, magrittr, beepr, data.table, readxl, stringr, purrr)
setwd(here())


# function to get mode  ---------------------------------------------------

getmode <- function(v) {
        uniqv <- unique(v)
        uniqv[which.max(tabulate(match(v, uniqv)))]
}

# load data ---------------------------------------------------------------
barrier_swd <- readRDS("001_data/Querbauwerke/Querbauwerke_Schwarzwald/2020-08-04qbw_sw_clean")
barrier_pwd <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/2020-06-18_qbw_rlp_hr_final.gpkg")
barrier_vdn <- st_read("001_data/Querbauwerke/Amber/barrier_atals/atlas.gpkg")
rivers_vdn  <- st_read("001_data/Gewaessernetze/Gewaessernetz_Nordvogesen/River.shp")

setDT(barrier_pwd)

# crop barrier atlas to vdn  ----------------------------------------------
st_crs(barrier_vdn)
st_crs(rivers_vdn)

barrier_vdn <- st_set_crs(x = barrier_vdn, value = 4326)
rivers_vdn %<>% st_transform(crs = st_crs(barrier_vdn))

barrier_vdn2 <- st_crop(x = barrier_vdn,
                        y = st_bbox(rivers_vdn))

nn = st_nearest_feature(barrier_vdn2, rivers_vdn); beep()
rivers_resorted <- rivers_vdn[nn,]

distance_list <-
        map(.x = 1:nrow(barrier_vdn2),
            .f = ~ as.numeric(st_distance(x = barrier_vdn2[.x, ],
                                          y = rivers_resorted[.x, ]))); beep()

distance_list2 <- unlist(distance_list)
distance_table <- data.table("amber_id" = barrier_vdn2$GUID,
                             "nn_distance" = distance_list2,
                             "type_old"    = barrier_vdn2$type,
                             "height"      = barrier_vdn2$Height,
                             "geom"        = barrier_vdn2$geom)

distance_table2 <- distance_table[nn_distance <= 100]
hist(distance_table2$nn_distance)

# assign category and score -----------------------------------------------

barrier_pwd[NAME2 == "Weiher"]
barrier_pwd[NAME2 == "Damm", mean(score_up)]
distance_table2$type_old %>% table
distance_table2[, c("type_new", "score_down", "score_up") := .(character(), numeric(), numeric())]
distance_table2[type_old == "culvert", c("type_new", "score_down", "score_up") :=
                        .("Durchlass",
                          barrier_pwd[NAME2 == "Durchlass", mean(score_down)],
                          barrier_pwd[NAME2 == "Durchlass", mean(score_up)])]

distance_table2[type_old == "dam", c("type_new", "score_down", "score_up") :=
                        .("Damm",
                          barrier_pwd[NAME2 == "Damm", mean(score_down)],
                          barrier_pwd[NAME2 == "Damm", mean(score_up)])]

distance_table2[type_old == "ford", c("type_new", "score_down", "score_up") :=
                        .("Furt",
                          barrier_pwd[NAME2 == "Furt", mean(score_down)],
                          barrier_pwd[NAME2 == "Furt", mean(score_up)])]

distance_table2[type_old == "other", c("type_new", "score_down", "score_up") :=
                        .("Misc QBW",
                          barrier_pwd[NAME2 == "Misc QBW", mean(score_down)],
                          barrier_pwd[NAME2 == "Misc QBW", mean(score_up)])]

distance_table2[type_old == "ramp", c("type_new", "score_down", "score_up") :=
                        .("Rampe",
                          barrier_pwd[NAME2 == "Rampe", mean(score_down)],
                          barrier_pwd[NAME2 == "Rampe", mean(score_up)])]

distance_table2[type_old == "sluice", c("type_new", "score_down", "score_up") :=
                        .("Schuetz",
                          barrier_swd[type_new == "Schuetz", mean(score_down)],
                          barrier_swd[type_new == "Schuetz", mean(score_up)])]

distance_table2[type_old == "weir", c("type_new", "score_down", "score_up") :=
                        .("Weiher",
                          barrier_pwd[NAME2 == "Weiher", mean(score_down)],
                          barrier_pwd[NAME2 == "Weiher", mean(score_up)])]

distance_table2[, c("amber_id", "nn_distance", "type_old", "height") := NULL]

saveRDS(distance_table2, 
        paste0("001_data/Querbauwerke/Querbauwerke_Nordvogesen/", Sys.Date(), "_vdn_amber_clean.RDS"))
        