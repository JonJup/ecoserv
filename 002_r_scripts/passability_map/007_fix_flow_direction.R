# ------------------------------ #
### --- Fix flow direction --- ### 
# ------------------------------ #

# date written: 21.10.20

# Used to be part of 005_create_map.R. Exacted because it is also useful for other parts of the project. 


# setup -------------------------------------------------------------------
pacman::p_load(data.table,
               dplyr, 
               here,
               sf,
               tmap
               )

#setwd 
setwd(here())

# dirs
dir_pd  = "003_processed_data/map_passability"
dir_fun = "002_r_scripts/functions/"

# load reverse function 
source(file.path(dir_fun, "F_003_reverse_pasability_map.R"))
source(file.path(dir_fun, "F_006_add_river.R"))

# options 
tmap_mode("view")

# load data ---------------------------------------------------------------
dt_rivers   <- readRDS(file.path(dir_pd, "2020-08-26_rivers_w_flow_and_barriers.RDS"))

# carpeting ---------------------------------------------------------------
dt_rivers[, ecoserv_number := as.numeric(stringr::str_extract(string=ecoserv_id, pattern="[0-9].*"))]

# delete segments ---------------------------------------------------------
dt_rivers  <-
        dt_rivers[!ecoserv_id %in% c(
                "swd_19631",
                "swd_32406",
                "swd_34009",
                "swd_37658",
                "swd_37712",
                "swd_40883",
                "swd_43986",
                "swd_48147",
                "swd_67705",
                "swd_63726",
                "swd_64279",
                "swd_64280",
                "swd_67704",
                "swd_71702",
                "swd_71703",
                "swd_71961",
                "vdn_7861"
       
)]


# Manual improvements -----------------------------------------------------
dt_rivers[ecoserv_id == "rlp_54"   , FROM := "P52"]
dt_rivers[ecoserv_id == "rlp_10112", FROM := "P19952"]
dt_rivers[ecoserv_id == "rlp_10118", FROM := "P2590"]
dt_rivers[ecoserv_id == "rlp_10143", FROM := "P2634"]
dt_rivers[ecoserv_id == "rlp_10143", TO   := "P2638"]
dt_rivers[ecoserv_id == "rlp_10280", FROM := "P3136"]
dt_rivers[ecoserv_id == "rlp_10391", FROM := "P3136"]
dt_rivers[ecoserv_id == "rlp_10394", FROM := "P2917"]
dt_rivers[ecoserv_id == "rlp_10398", FROM := "P3150"]
dt_rivers[ecoserv_id == "rlp_10398", TO   := "P3160"]
dt_rivers[ecoserv_id == "rlp_10399", FROM := "P3150"]
dt_rivers[ecoserv_id == "rlp_10509", FROM := "P3374"]
dt_rivers[ecoserv_id == "rlp_10611", FROM := "P3414"]
dt_rivers[ecoserv_id == "rlp_10627", FROM := "P3598"]
dt_rivers[ecoserv_id == "rlp_10627", TO   := "P3612"]
dt_rivers[ecoserv_id == "rlp_10634", FROM := "P3422"]
dt_rivers[ecoserv_id == "rlp_11198", TO   := "P404"]
dt_rivers[ecoserv_id == "rlp_14111", FROM := "P29614"]
dt_rivers[ecoserv_id == "rlp_14942", TO   := "P11990"]

dt_rivers[ecoserv_id == "vdn_2342" , TO   := "P28346"]
dt_rivers[ecoserv_id == "vdn_2342" , FROM := "P22684"]
dt_rivers[ecoserv_id == "vdn_4399" , FROM := "P22684"]
dt_rivers[ecoserv_id == "vdn_7362" , FROM := "P20200"]
dt_rivers[ecoserv_id == "vdn_7362" , TO   := "P22508"]

dt_rivers[ecoserv_id == "sar_4600",  FROM := "P10674"]
dt_rivers[ecoserv_id == "sar_8158",  FROM := "P117261"]
dt_rivers[ecoserv_id == "sar_8158",  TO   := "P114079"]
dt_rivers[ecoserv_id == "sar_8400",  FROM := "P122813"]
dt_rivers[ecoserv_id == "sar_8400",  TO   := "P403"]
dt_rivers[ecoserv_id == "vdn_16960", FROM := "P10564"]


# out ---------------------------------------------------------------------
dt_rivers[ecoserv_id %in% c("vdn_6657", "vdn_6658", "vdn_6660"), c("FROM", "TO") := c(1,2,3)]


# Reverse -----------------------------------------------------------------
reverse(c(29, 
          1259, 1286, 1287, 1288, 1295, 1316, 1317, 1324, 1512, 1517, 1579, 1649, 1657, 1685, 1736, 1737,
          1741, 1763, 1771, 1772, 1811, 1818, 1820, 1824, 1852, 1585, 1904, 1905, 1948,
          2356, 2378, 2399, 2452, 2477, 2488, 2494, 2510, 2580, 2627, 2897, 2937, 3461, 
          3462,  
          5068, 5088, 5091, 5095, 5106, 5140, 5153, 5156, 5216, 5224, 5279, 5325, 5335,
          6102, 6111, 6113, 
          8308,
          9580, 
          10816, 
          11344, 11360 ,11578,
          12365, 12834, 
          13065, 
          14412, 14413, 14314, 14336, 14341, 14351, 14355, 14356, 14369, 14379, 14628, 14632, 14641, 14643, 14905, 14906, 14907, 14908, 14909, 14989, 
          15045, 15046,
          29568, 29571, 
          37418, 37417, 37416, 37419, 37415, 37414, 37413, 37412, 37411, 37410, 37409, 37387, 37385, 35860, 
          43338,
          57058, 57069, 57078,
          58962,  
          62084, 62093, 62836, 62833, 62837, 62855, 62864, 62686, 
          63704, 63705, 63706, 63707 , 63709, 63711,  63713, 63716, 63717
          
          
          # Fakies: Sind richtig aber aus praktischen Gründen umgedreht 
          # 16 ist schon Rhein 
          
))
# add new lines  ----------------------------------------------------------
dt_rivers = add_river(from_line = "rlp_147", to_line = "rlp_149", 
                      from_point = "P40", to_point = "P44", 
                      cast_p1 = 87, cast_p2 = 217)


# save to file  -----------------------------------------------------------
saveRDS(object=dt_rivers,
        file=file.path(dir_pd, "fixed_rivers.RDS"))

# workshop ---------------------------------------------------------------
st_rivers = st_as_sf(dt_rivers)


## -- what? -- ## 
sub=tb_edge_id_sub$ecoserv_id

sub=c("PW_01", "PW02")

rivers_sub=dt_rivers[ecoserv_id %in% sub]

rivers_sub %>% 
        mutate(fromto=paste(FROM, TO)) %>% 
        st_as_sf() %>% 
        tm_shape() + tm_lines(col="ecoserv_id", lwd=3) + 
        tm_text(text="fromto")

## -- bbox around sites -- ## 
st_sites_sub = filter(st_sites, site %in% c("PW_01", "PW_02")) 

st_sites_sub %>% 
        st_bbox() * c(.99,.99,1.11,1.11) -> 
        cut_bbox

st_cropped=sf::st_crop(
        x=st_rivers, 
        y=cut_bbox
        )

tm_shape(st_cropped) + tm_lines() + 
        tm_shape(st_sites_sub) + tm_dots(col = "red")

## ------------------- ## 
## -- add lines eda -- ## 
st_rivers_sub = st_rivers %>% 
        filter(ecoserv_id %in% c("rlp_147", "rlp_149"))

st_rivers_sub_point = st_rivers_sub %>% 
        st_cast(to="POINT")

st_rivers_sub_point %<>% mutate(p_id = 1:nrow(st_rivers_sub_point))

tm_shape(st_rivers_sub_point) + 
        tm_dots()

st_rivers_sub_point %>%
        filter(p_id %in% c(87, 217)) %>%
        st_coordinates(st_new_line) %>%
        .[, -3] %>%
        st_linestring() %>% 
        st_sfc() -> 
        st_new_line

st_crs(st_new_line)=st_crs(st_rivers_sub)

tm_shape(st_rivers_sub) + tm_lines() + 
        tm_shape(st_new_line) + tm_lines()

df_attributes = data.frame(
        "ecoserv_id" = paste0("add_",
                              max(dt_rivers$ecoserv_number) + 1),
        "FROM" = "P40",
        "TO"   = "P44",
        score_up=1,
        score_down=1,
        ecoserv_number=max(dt_rivers$ecoserv_number) + 1
)

st_new_line = st_sf(df_attributes, geom = st_new_line)   
st_crs(st_new_line)=st_crs(st_rivers)
st_rivers %<>% rbind(st_new_line)

## ------------------- ## 
        #tmap_mode("view")

# to_split <- rivers[ecoserv_id == "vdn_7861"]
# to_split %<>% st_as_sf()
# to_split %<>% st_cast("POINT")
# 
# st_nearest_feature(y = to_split, 
#                    x = st_as_sf(rivers[ecoserv_id == "rlp_16958"]))
# 
