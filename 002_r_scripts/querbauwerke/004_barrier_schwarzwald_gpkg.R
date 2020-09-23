library(sf)
library(xlsx)
library(data.table)

data(World)
data <- read.xlsx("001_data/Querbauwerke/Querbauwerke_Schwarzwald/AKWB RBW 2020.05 Oberrheingebiet.xlsx", sheet = 1)

setDT(data)
data <- data[!is.na(Nord) & !is.na(Ost)]
data2 <- st_as_sf(data, coords = c("Ost", "Nord"))
st_crs(data2) <- 25832
plot(data2[,1])

st_write(data2, "001_data/Querbauwerke/Querbauwerke_Schwarzwald/qbw_sw.gpkg")
