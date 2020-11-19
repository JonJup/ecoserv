### --- Ecoserv 
### --- Downstream colonization with CDMetaPOP
### --- 19.11.20 
### --- Master script 

# setup -------------------------------------------------------------------
pacman::p_load(data.table,
               dplyr,
               here,
               magrittr,
               raster,
               rgeos,
               sf,
               shp2graph,
               sp,
               tmap)
tmap_mode("view")
# pacman::p_load(sf, 
#                dplyr, 
#                magrittr,
#                here, 
#                purrr, 
#                data.table,
#                tmap, 
#                lwgeom, 
#                stringr)

## DIRECTORIES
DIR = list(
        sites = here("001_raw_data/probestellen/"),
        river = here("../01_Lehre/07_projekt_uwi/projekt_uwi_passability/01_data/"),
        script = here("002_r_scripts/cdmetapopgen/populate_downstream/"),
        network = here("003_processed_data/network/")
)

## OPTIONS 
OP_GOAL = FALSE

#files 
st_sites = readRDS(file.path(DIR$sites, "2020-09-23_all_sites.RDS"))
dt_rivers = readRDS(file.path(DIR$river, "fixed_rivers.RDS"))
igraph_nodes  = readRDS(file.path(DIR$network, "2020-11-18_list_pre_network.RDS"))
igraph_rivers = readRDS(file.path(DIR$network, "2020-11-18_igraph_river.RDS"))

# choose point  -----------------------------------------------------------

int_start_site = 2

# find outlet  ------------------------------------------------------------
if (OP_GOAL)
{source(file.path(DIR$script, "01_letflow.R"))
dt_rivers_loop %>%
        filter(evaled != 0) %>%
        st_as_sf() %>%
        tm_shape() +
        tm_lines(col = "evaled",
                 palette = "RdYlGn",
                 scale = 4)}

ch_goal_segment_id = "swd_68161"
# derive point 
# source(file.path(DIR$script, "01_goal_segment_point.R"))

# path to outlet  ---------------------------------------------------------
source(file.path(DIR$script, "01_find_path.R"))

# create pseudo locations  ------------------------------------------------
#source(file.path(DIR$script, "01_pseudo_locations"))



# probability of successful migration  -----------------------------------




