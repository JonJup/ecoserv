### --- riverdist --- ### 

pacman::p_load(igraph,magrittr,riverdist, shp2graph, sf, sp)

data <-st_read("001_raw_data/gewaessernetze/Gewaessernetz_Saarland/2020-08-11_fixed_sar_river_network.gpkg")
data=data[!st_is_empty(data), ]
data$random <- rnorm(nrow(data), 1,0)
data%<>%as_Spatial()
test=readshpnw(data)
test2=nel2igraph(test[[2]], test[[3]])
plot(test2, vertex.label = NA, vertex.size = 2, vertex.size2 = 2, mark.col = "green",
     main = "The converted igraph graph")
