# ------------------------------ #
### --- Fix flow direction --- ### 
# ------------------------------ #

# date written: 21.10.20
# date changed: 28.10.20 

# Used to be part of 005_create_map.R. Exacted because it is also useful for other parts of the project. 


# setup -------------------------------------------------------------------
pacman::p_load(data.table,
               dplyr,
               here,
               sf,
               stringr,
               tmap)

#setwd 
setwd(here())

# dirs
dir_pd  = "003_processed_data/map_passability"
dir_fun = "002_r_scripts/functions/"
dir_rd = "001_raw_data/"

# load reverse function 
source(file.path(dir_fun, "F_003_reverse_pasability_map.R"))
source(file.path(dir_fun, "F_006_add_river.R"))

# options 
tmap_mode("view")

# load data ---------------------------------------------------------------
dt_rivers   <- readRDS(file.path(dir_pd, "2020-08-26_rivers_w_flow_and_barriers.RDS"))
st_sites    <- readRDS(file.path(dir_rd, "probestellen", "2020-09-23_all_sites.RDS"))

# carpeting ---------------------------------------------------------------
dt_rivers[, ecoserv_number := as.numeric(str_extract(string=ecoserv_id, pattern="[0-9].*"))]

# delete segments ---------------------------------------------------------
dt_rivers  <-
        dt_rivers[!ecoserv_id %in% c(
                "rlp_55",
                "rlp_56",
                "rlp_203",
                "rlp_212",
                "rlp_214",
                "rlp_374",
                "rlp_248",
                "rlp_10137",
                "rlp_10152",
                "rlp_10174",
                "rlp_16929",
                "rlp_16930",
                
                "swd_19631",
                "swd_32406",
                "swd_34009",
                "swd_37142",
                "swd_37658",
                "swd_37712",
                "swd_38065",
                "swd_40883",
                "swd_41717",
                "swd_43986",
                "swd_48147",
                "swd_67705",
                "swd_63726",
                "swd_64279",
                "swd_64280",
                "swd_67704",
                "swd_69582",
                "swd_71702",
                "swd_71703",
                "swd_71961",
                "vdn_6661",
                "vdn_7861"
       
)]


# Manual improvements -----------------------------------------------------
dt_rivers[ecoserv_id == "rlp_54"   , FROM := "P52"]
dt_rivers[ecoserv_id == "rlp_192"  , FROM := "P2184"]
dt_rivers[ecoserv_id == "rlp_192"  , TO := "p_add_01"]
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
dt_rivers[ecoserv_id == "rlp_16937", FROM   := "P2917"]

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
dt_rivers = reverse(x= c(
        "rlp_197", 
        "rlp_10080",
        "rlp_10081",
        "rlp_10107",
        "rlp_10108",
        "rlp_10109",
        "rlp_10116",
        "rlp_10117",
        "rlp_10138",
        "rlp_10139",
        "rlp_10141",
        "rlp_10145",
        "rlp_10146",
        "rlp_10279",
        "rlp_10283",
        "rlp_10284",
        "rlp_10285",
        "rlp_10333", 
        "rlp_10334",
        "rlp_10338",
        #"rlp_10339",
        "rlp_10400",
        "rlp_10406", 
        "rlp_10407",
        "rlp_10471",
        "rlp_10479",
        "rlp_10507",
        "rlp_10558",
        "rlp_10559",
        "rlp_10563",
        "rlp_10585",
        "rlp_10593",
        "rlp_10594",
        "rlp_10633",
        "rlp_10640",
        "rlp_10642",
        "rlp_10646",
        "rlp_10674",
        "rlp_10726",
        "rlp_10727",
        "rlp_10770",
        "rlp_11178",
        "rlp_11200",
        "rlp_11221",
        "rlp_11274",
        "rlp_11299",
        "rlp_11310",
        "rlp_11316",
        "rlp_11332",
        "rlp_11402",
        "rlp_11449",
        "rlp_11719",
        "rlp_11759",
        "rlp_12283",
        "rlp_12284",
        "rlp_13890",
        "rlp_13910",
        "rlp_13913",
        "rlp_13917",
        "rlp_13928",
        "rlp_13962",
        "rlp_13975",
        "rlp_13978",
        "rlp_14038",
        "rlp_14046",
        "rlp_14101",
        "rlp_14147",
        "rlp_14157",
        "rlp_14924",
        "rlp_14933",
        "rlp_14935",
        
        "vdn_247",
        "vdn_2088",
        "vdn_3872",
        "vdn_4394",
        "vdn_4400",
        "vdn_4416",
        "vdn_4634",
        "vdn_5421",
        "vdn_5890",
        "vdn_6121",
        "vdn_7371",
        "vdn_7393",
        "vdn_7398",
        "vdn_7408",
        "vdn_7412",
        "vdn_7413",
        "vdn_7426",
        "vdn_7436",
        "vdn_7468",
        "vdn_7469",
        "vdn_7470",
        "vdn_7683",
        #"vdn_7685",
        "vdn_7687",
        #"vdn_7689",
        "vdn_7698",
        "vdn_7700",
        "vdn_7963",
        "vdn_7964",
        "vdn_7965",
        "vdn_7966",
        "vdn_7967",
        "vdn_8047",
        "vdn_8103",
        # "vdn_8104",
        
        "swd_45701",
        "swd_45704",
        "swd_51994",
        "swd_53519",
        "swd_53521",
        "swd_53543",
        "swd_53544",
        "swd_53545",
        "swd_53546",
        "swd_53547",
        "swd_53548",
        "swd_53549",
        "swd_53550",
        "swd_53551",
        "swd_53552",
        "swd_53553",
        "swd_59472",
        "swd_63164",
        "swd_63165",
        "swd_63166",
        "swd_65204",
        "swd_68155",
        "swd_68157", 
        "swd_68181",
        
        
        "sar_444",
        "sar_464",
        "sar_477",
        "sar_3319",
        "sar_6538",
        "sar_6547",
        "sar_7140",
        "sar_7290",
        "sar_7287",
        "sar_7291",
        "sar_7309",
        "sar_7318",
        "sar_8158",
        "sar_8159",
        "sar_8160",
        "sar_8161",
        "sar_8163",
        "sar_8165",
        "sar_8167",
        "sar_8170",
        "sar_8171"
        
        #temporary 
        #"swd_68184"
        #"rlp_188"
))

# add new lines  ----------------------------------------------------------
dt_rivers = add_river(from_line = "rlp_148", to_line = "rlp_10105",
                      from_point = "P42", to_point = "P44"
                      )
dt_rivers = add_river(from_line = "rlp_54", to_line = "swd_68189",
                      from_point = "P26", to_point = "P104120"
                      )
dt_rivers = add_river(from_line = "rlp_188", to_line = "rlp_9913",
                      from_point = "P52", to_point = "P2183"
                      )
dt_rivers = add_river(from_line = "rlp_10145", to_line = "rlp_201",
                      from_point = "P2648", to_point = "P61"
                      )
dt_rivers = add_river(from_line = "rlp_201", to_line = "rlp_202",
                      from_point = "P62", to_point = "P54"
                      )
dt_rivers = add_river(from_line = "rlp_202", to_line = "swd_68185",
                      from_point = "P64", to_point = "P104112"
                      )
dt_rivers = add_river(from_line = "rlp_192", to_line = "rlp_191",
                      from_point = "p_add_01", to_point = "P55"
                      )
dt_rivers = add_river(from_line = "rlp_10403", to_line = "swd_68158",
                      from_point = "P3160", to_point = "P104058"
                      )
dt_rivers = add_river(from_line = "rlp_373", to_line = "swd_68162",
                      from_point = "P128", to_point = "P104066"
                      )



## ---- add rows ----- ## 
new_number_rlp <- dt_rivers[str_detect(string=ecoserv_id,pattern="rlp"), max(ecoserv_number)]
dt_new_row <- data.table(ecoserv_id = paste0("rlp_", new_number_rlp + 1:2), 
                         FROM       = c("P42","P52"   ),
                         TO         = c("P44", "P2183"), 
                         score_up   = 1,
                         score_down = 1,
                         ecoserv_number = new_number_rlp + 1:2, 
                         geom       = c(dt_rivers[TO == "P42", geom], 
                                        dt_rivers[TO == "P52", geom])
)

dt_rivers <- rbindlist(list(dt_rivers, dt_new_row), 
                       use.names = TRUE)

## second delete step 
dt_rivers = dt_rivers[!ecoserv_id %in% c(
        "rlp_10404",
        "rlp_16932",
        "rlp_16934",
        "rlp_16961",
        "rlp_16962",
        # temp 
        "rlp_10138"
)
]

rm(add_river, dir_fun, dt_new_row, new_number_rlp, reverse);gc()

# save to file  -----------------------------------------------------------
# saveRDS(object=dt_rivers,
#         file=file.path(dir_pd, "fixed_rivers.RDS"))
# 
# if(readline("Remove all? ") == "yes")rm(list=ls())

# workshop ---------------------------------------------------------------

# ## -- always -- ## 


# st_rivers = st_as_sf(dt_rivers)
# st_sites%<>%st_transform(crs=st_crs(st_rivers))





# ## -- what? -- ## 
# sub=tb_edge_id_sub$ecoserv_id
# 
# sub=c("PW_01", "PW02")
# 
# rivers_sub=dt_rivers[ecoserv_id %in% sub]
# 
# rivers_sub %>% 
#         mutate(fromto=paste(FROM, TO)) %>% 
#         st_as_sf() %>% 
#         tm_shape() + tm_lines(col="ecoserv_id", lwd=3) + 
#         tm_text(text="fromto")
# 
# ## -- bbox around sites -- ## 
# ## -- + plot            -- ## 
# st_sites_sub = filter(st_sites, site %in% c("PW_01", "PW_02")) 
# 
# st_sites_sub %>% 
#         st_bbox() * c(.99,.99,1.11,1.11) -> 
#         cut_bbox
# 
# st_cropped=sf::st_crop(
#         x=st_rivers, 
#         y=cut_bbox
#         )
# 
# tm_shape(st_cropped) + tm_lines() + 
#         tm_shape(st_sites_sub) + tm_dots(col = "red")
# 
# ## ------------------- ## 
# ## -- add lines eda -- ## 

# extract lines between which a link is missing 
# st_rivers_sub =
#         st_rivers %>%
#         filter(ecoserv_id %in% c("rlp_188", "rlp_9913"))
# 
# st_data = st_rivers
# st_data_sub = st_data %>% 
#         filter(ecoserv_id %in% c(from_line, to_line))
# 
# 
# st_data_sub_points =
#         st_data_sub %>%
#         st_cast(to = "POINT") %>%
#         mutate(p_id = row_number())
# 
# 
# st_line_to = st_data_sub %>%
#         filter(ecoserv_id == to_line)
# st_line_from = st_data_sub %>%
#         filter(ecoserv_id == from_line)
# st_points_from = st_data_sub_points %>%
#         filter(ecoserv_id == from_line)
# st_points_to = st_data_sub_points %>%
#         filter(ecoserv_id == to_line)
# st_points_from = st_points_from[c(1, nrow(st_points_from)), ]
# st_points_to = st_points_to[c(1, nrow(st_points_to)), ]
# 
# tm_shape(st_points_from) + tm_dots() + 
#         tm_shape(st_points_to) + tm_dots()
# 
# p_id1 = st_nearest_feature(x = st_line_to,
#                            y = st_points_from)
# p_id2 = st_nearest_feature(x = st_line_from,
#                            y = st_points_to)
# p_id1 = st_points_from$p_id[p_id1]
# p_id2 = st_points_to$p_id[p_id2]
# 
# 
# # cast to points
# options(warn=-1);
# st_rivers_sub_point =
#         st_rivers_sub %>%
#         st_cast(to = "POINT");
# options(warn=1)
# 
# st_rivers_sub_point %<>%
#         mutate(p_id = 1:nrow(st_rivers_sub_point))
# point_id_2 <-
#         unique(st_nearest_feature(
#                 filter(st_rivers_sub_point, ecoserv_id == "rlp_188"),
#                 filter(st_rivers_sub_point, ecoserv_id == "rlp_9913")
#         ))
# point_id_1 <-
#         unique(st_nearest_feature(
#                 filter(st_rivers_sub_point, ecoserv_id == "rlp_9913"),
#                 filter(st_rivers_sub_point, ecoserv_id == "rlp_188")
#         ))
# point_id_1 = filter(st_rivers_sub_point, ecoserv_id == "rlp_9913") %>% 
#         st_drop_geometry() %>% 
#         select(p_id) %>% 
#         .[point_id_1,]
# 
# point_id_2 = filter(st_rivers_sub_point, ecoserv_id == "rlp_188") %>% 
#         st_drop_geometry() %>% 
#         select(p_id) %>% 
#         .[point_id_2,]
# 
# tm_shape(st_rivers_sub_point) +
#         tm_dots()
# 
# st_rivers_sub_point %>%
#         filter(p_id %in% c(442, 446)) %>%
#         st_coordinates(st_new_line) %>%
#         .[, -3] %>%
#         list() %>%
#         st_multilinestring() %>%
#         st_sfc() ->
#         st_new_line
# 
# st_crs(st_new_line)=st_crs(st_rivers_sub)
# 
# tm_shape(st_rivers_sub) + tm_lines() +
#         tm_shape(st_new_line) + tm_lines()
# 
# df_attributes = data.frame(
#         "ecoserv_id" = paste0("add_",
#                               max(dt_rivers$ecoserv_number) + 1),
#         "FROM" = "P40",
#         "TO"   = "P44",
#         score_up=1,
#         score_down=1,
#         ecoserv_number=max(dt_rivers$ecoserv_number) + 1
# )
# 
# st_new_line = st_sf(df_attributes, geom = st_new_line)
# st_crs(st_new_line)=st_crs(st_rivers)
# st_rivers %<>% rbind(st_new_line)


# #-----------------------#
# 
# 
# 
# ## ------------------- ## 
#         #tmap_mode("view")
# 
# # to_split <- rivers[ecoserv_id == "vdn_7861"]
# # to_split %<>% st_as_sf()
# # to_split %<>% st_cast("POINT")
# # 
# # st_nearest_feature(y = to_split, 
# #                    x = st_as_sf(rivers[ecoserv_id == "rlp_16958"]))
# # 
