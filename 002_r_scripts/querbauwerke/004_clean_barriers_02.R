# -------------------------------- #
### --- clean barriers RLP 2 --- ### 
# -------------------------------- #


# Setup -------------------------------------------------------------------
pacman::p_load(sf, dplyr, magrittr, beepr, here, stringr, data.table)
setwd(here())


# data IO ----------------------------------------------------------------
data <- readRDS("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/querbauwerke_clean.RDS")
#spatial <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/querbauwerke.gpkg")


# analysis ----------------------------------------------------------------

# how many NAs and where? 
sum(is.na(data$AUFWAERTSP))
sum(is.na(data$ABWAERTSPA))

# -> NAs only in Abwaerts 

data_reformated <- data.table(
        querbauwerk = sort(unique(data$NAME2))
)

for (i in seq_along(data_reformated$querbauwerk)) {
        
        loop_var <- data_reformated$querbauwerk[i]
        loop_dat <- data[NAME2 == loop_var]
        n        <- nrow(loop_dat)
        loop_ab_u    <- loop_dat[ABWAERTSPA == "unpassierbar"            , .N]
        loop_ab_e    <- loop_dat[ABWAERTSPA == "eingeschränkt"           , .N]
        loop_ab_g    <- loop_dat[ABWAERTSPA == "gravierend eingeschränkt", .N]
        loop_ab_p    <- loop_dat[ABWAERTSPA == "passierbar"              , .N]
        NA_AB        <- sum(is.na(loop_dat$ABWAERTSPA))
        
        
        data_reformated[querbauwerk == loop_var, 
                        c("N", "ab_u", "ab_g", "ab_e", "ab_p", "NA_ab") := 
                                .(n, loop_ab_u, loop_ab_g, loop_ab_e,
                                  loop_ab_p, NA_AB)]
        
        
}

# fill NAs with most common value for others 

for (i in seq_along(data_reformated$querbauwerk)) {
        
        loop_var <- data_reformated$querbauwerk[i]
        # skip if there are no NAs 
        if (data_reformated[querbauwerk == loop_var]$NA_ab == 0) next()
        max_value <- max(data_reformated[querbauwerk == loop_var,c("ab_u", "ab_g", "ab_e", "ab_p")])
        if (max_value == 0) {
                data[NAME2 == loop_var & is.na(ABWAERTSPA), ABWAERTSPA := 6]
        }
        max_id <- which(data_reformated[querbauwerk == loop_var, 3:6] == max_value) + 2
        data[NAME2 == loop_var & is.na(ABWAERTSPA), ABWAERTSPA := max_id]
        
        
}

data[ABWAERTSPA == 3, ABWAERTSPA := "unpassierbar"]
data[ABWAERTSPA == 4, ABWAERTSPA := "gravierend eingeschränkt"]
data[ABWAERTSPA == 5, ABWAERTSPA := "eingeschränkt"]
data[ABWAERTSPA == 6, ABWAERTSPA := "passierbar"]


data[, score_down := case_when(ABWAERTSPA == "unpassierbar" ~ 0, 
                               ABWAERTSPA == "gravierend eingeschränkt" ~ 0.33,
                               ABWAERTSPA == "eingeschränkt" ~ 0.66,
                               ABWAERTSPA == "passierbar" ~ 1,)]
data[, score_up  := case_when(AUFWAERTSP == "unpassierbar" ~ 0, 
                              AUFWAERTSP == "gravierend eingeschränkt" ~ 0.33,
                              AUFWAERTSP == "eingeschränkt" ~ 0.66,
                              AUFWAERTSP == "passierbar" ~ 1,)]

data %<>% st_as_sf()
st_write(data, paste0("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/",Sys.Date(),"_qbw_rlp_hr_final.gpkg"))
