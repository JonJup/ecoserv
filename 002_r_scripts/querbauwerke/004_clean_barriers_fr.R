# --------------------------------- #
### --- Clean French Barriers --- ### 
# --------------------------------- #

#date: 18.06.20
#Jonathan Jupke 


# setup -------------------------------------------------------------------

pacman::p_load(here,sf,dplyr,data.table, magrittr)
setwd(here())


# data IO  ----------------------------------------------------------------

data <- st_read("001_data/Querbauwerke/Querbauwerke_Nordvogesen/Ouvrages.shp") %>% setDT
pw_data <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/2020-06-18_qbw_rlp_hr_final.gpkg") %>% setDT


# Changes  ----------------------------------------------------------------

# These are also repeated later in the code together with their derivation.
# Running these commands you will do all the changes that are elaborated later
# on without all the exploratory commands.

data2 <- data[, c(6,12,13,30,36,50,74)] 
data2[lib_type == "Barrage", c("name_neu", "score_up", "score_down")
      := .("Sperrung", 0,0)]
data2 <- data[, c(6,12,13,30,36,50,74)] 

data2[lib_type == "Barrage", c("name_neu", "score_up", "score_down")
      := .("Sperrung", 0,0)]

data2[lib_type %in% c("Buse", "D", "Dalot"), c("name_neu", "score_up", "score_down")
      := .("Durchlass", 0.66,1)]

data2[lib_type == "Ouvrage mixte", c("name_neu", "score_up", "score_down")
      := .("Mühle", 0,1)]

data2[lib_type == "Passerelle", c("name_neu", "score_up", "score_down")
      := .("Steg", 1,1)]

data2[lib_type %in% c("Pont", "Pont/Seuil"), c("name_neu", "score_up", "score_down")
      := .("Brücke", 1,1)]

data2[lib_type %in% c("Seuil"), c("name_neu", "score_up", "score_down")
      := .("Schwelle", 1,1)]

data2[is.na(score_up) & lib_sys_ou == "Vannes", 
      c("name_neu", "score_up", "score_down") := .("Wehr", 0.33, 1)]

data2[is.na(score_up) & lib_sys_ou == "Poutres", 
      c("name_neu", "score_up", "score_down") := .("Brücke", 1, 1)]

data2[is.na(score_up) & lib_sys_ou == "Batardeau", 
      c("name_neu", "score_up", "score_down") := .("Damm", 0.66, 0)]

data2[NOM_PRINC %in% c("Etang", "etang", "Etang Engel", "etang d'haspelschiedt", "etang d'entenboechel", "etang d'hasselfurt", "Ancien plan d'eau"), 
      c("name_neu", "score_up", "score_down") := .("Teich", 0, 1)]

data2[NOM_PRINC %in% c("digue etang"), 
      c("name_neu", "score_up", "score_down") := .("Damm", 0.66, 0)]

data2[is.na(score_up) & NOM_PRINC %in% c("Passage sous voie firr", "Passage bust", "Passage sous chemin", 
                       "Passage sous supermarche et parking", "Passage sous stade", 
                       "Passage sous route", "Passage sous hapital et ville",
                       "Busage", "barrage de karlsmuhl", "Busage sous RD BitcheLemberg", 
                       "busage sous barrage ecriteur de crue", "Busage sous RD BitcheLemberg", 
                       "Buse sous la route", "Passage routier", "Pertuis _ irrigation"), 
      c("name_neu", "score_up", "score_down") := .("Durchlass", 0.66,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Ancien moulin Eberbach", "DORFMaHLE", "Kuppertsmuehle", 
                       "Langmattermuehle", "Moulin-scierie","moulin Burgraff" ,
                       "Moulin d'Eschwiller", "Moulin de Butten","moulin de dorst" , 
                       "Moulin de loutzviller","moulin de weiskirch" ,"Moulin de Weiskirch prise d'eau",
                       "Moulin hydro lectrique RG" ,"Moulin infnrieur de Volmunster" ,"Neumuehle",                                          
                       "oligmuehle", "Schleifmuehle"), 
      c("name_neu", "score_up", "score_down") := .("Mühle", 0,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Pont", "Pont acc", "Pont de la route forestiqre du grand Gruenewald", "Pont Zinsel du Sud", "enrochement aval pont",
                       "Rue du moulin", "Stade"),
      c("name_neu", "score_up", "score_down") := .("Brücke", 1,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Seuil", "seuil aval pont", "petit seuil sous passerelle"),
      c("name_neu", "score_up", "score_down") := .("Schwelle", 1,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("barrage d'altmuhl", "barrage de karlsmuhl"),
      c("name_neu", "score_up", "score_down") := .("Sperrung", 0,0)]

data2[is.na(score_up) & NOM_PRINC %in% c("Desableur"),
      c("name_neu", "score_up", "score_down") := .("Rechenbauwerk", 1,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Confluence", "Schorbach proche confluence Horn"),
      c("name_neu", "score_up", "score_down") := .("Gewässerkreuzung", 1,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("D", "Deversoir du moulin de loutzviller", "Deversoir moulin d'eschviller", "Pris source", "Prise d'eau",
                       "prise d'eau bras de dtrivation de l' tang de Fleckenstein", "prise d'eau moulin Rehmuehle"),
      c("name_neu", "score_up", "score_down") := .("Abfluss", 1,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Vannage", "vanne de la scierie", "Vannes"),
      c("name_neu", "score_up", "score_down") := .("Weiher", 0.33,1)]

data2[is.na(score_up) & NOM_PRINC %in% c("Ancienne ptcherie", "Lavoir", "Lavoir_Obersteinbach", "Otherbuehl", "Pisciculture Liebfraunthal"),
      c("name_neu", "score_up", "score_down") := .("Misc QBW", 1,1)]

data2[is.na(score_up) & TYPE_NOM %in% c("Barrage"),
      c("name_neu", "score_up", "score_down") := .("Sperrung", 0,0)]

data2[is.na(score_up) & TYPE_NOM %in% c("Obstacle induit par un pont"),
      c("name_neu", "score_up", "score_down") := .("Brücke", 1,1)]

data2[is.na(score_up) & TYPE_NOM %in% c("Seuil en rivi0re", "Seuil en rivi4re","Seuil en rivi5re","Seuil en rivi6re","Seuil en rivi7re"),
      c("name_neu", "score_up", "score_down") := .("Schwelle", 1,1)]

data2[is.na(score_up), c("name_neu","score_up", "score_down") := .("Misc QBW", 1,1)]



# EDA -------------------------------------------------------------------

# COL 1:5 - Ids 
# COL 06 - Name - 44 of 1,641
# COl 07 - some id 
# COL 08 - ? 
# COL 09 - lib_cond_h - Wasserhöhe?- kategorisch; zwei Level: "Basses eaux" und "Moyennes eaux"             - 297  of 1641
# COL 10 - lib_droit_ - ?          - kategorisch; ein Level: Actif                                          - 12   
# COL 11 - date_droit - Seit wann  - Datum                                                                  - 8    
# COL 12 - lib_type   - QBW Typ    - Character                                                              - 1436 
# COL 13 - lib_sys_ou - QBW Typ    - Character                                                              - 149                                                
# COL 14 - lib_manvr  - Beweglich? - Character; ein lvl "Manuelle"                                          - 31   
# COL 15 - lib_positi - Position des QBW - Character, "Au fil de l'eau" "En rive droite"  "En rive gauche"  - 428  
# COl 16 - hauteur_ch - Höhe von was? - numeric; 0 bis 6                                                    - alle 
# COL 17 - longueur_r - Länge      - numeric, 0 bis 500                                                     - alle 
# COL 18 - annee_cons - Baujahr, Unterschied zu date_droit? - Datum                                         - 4 
# COL 19 - etat_mobil - Beweglichkeit - kategorisch: "Bon"     "Mauvais" "Moyen"   "Ruine"                  - 31 
# COL 20 - etat_ouvra - geöffneter Zustand? - kategorisch: "Bon"     "Mauvais" "Moyen"   "Ruine"            - 562
# COL 21 - lib_usage  - Nutzung    - kategorisch: ~ 30 level                                                - 521 
# COL 22 - ouvrage_gr - ?          - alle 0                                                                 - alle 
# COl 23 - date_relev - ?          - Datum                                                                  - 751 
# COL 24 - lien_doc_f - ?          - numeric - 369 unique values                                            - 369
# COL 25 - lib_qual_x - ?          - kategorisch - ein Level: "Ortho 2011"                                  - 7 
# COL 26 - ID_ROE     - ID         - numeric 181 uniqe values             - 181
# COL 30 - NOM_PRINC  - Wieder ein name 
# COL 36 - Type_nom   - wieder ein name 
# COL 50 - EMO_NOM1   - Wieder ein QBW typ -  kategorisch: zwei Level: "Batardeau" und "Vannes levantes"    - 81 

# Vokabeln  ---------------------------------------------------------------
# Barrage   - absperrung, sperre 
# Batardeau - Querdamm 
# Buse      - Schacht  
# Etang     - Teich 
# Grille    - Gitter 
# Moine     - Mine?  
# moulin    - Mühle 
# Passerelle - Steg 
# Poutres   - Balken 
# Seuil     - Schwelle, Stufe
# Tulipe - Muffenrohr
# Vannes - eaux vannes ist abwasser 

glimpse(data)
i = 30

data[,i, with = F] %>% pull %>%  unique %>% sort
names(data)[i]
nrow(data) - sum(is.na(data[,i, with = F]))

# Ergänzen sich die beiden QBW-Arten (col 12 und 13)? -> nein 
nrow(data) - sum(is.na(data[,12]) & is.na(data[,13]))
data[!is.na(lib_sys_ou)]
# Ergänzen sich die beiden QBW-Arten (col 12 und 50)? -> ja teils!  
nrow(data) - sum(is.na(data[,12]) & is.na(data[,50]))
data[!is.na(lib_sys_ou)]
# Ergänzen sich die beiden QBW-Arten (col 12 und 30)? -> ja teils!  
nrow(data) - sum(is.na(data[,12]) & is.na(data[,30]))
data[!is.na(lib_sys_ou)]


# create new data set 
data2 <- data[, c(6,12,13,30,36,50,74)] 

data2$lib_type %>% unique %>% sort
data2[grepl(x = lib_type, pattern = "Barrage"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Barrage"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Barrage"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Barrage"), unique(EMO_NOM1)]
data2[lib_type == "Barrage", c("name_neu", "score_up", "score_down")
      := .("Sperrung", 0,0)]

data2[lib_type %in% "Buse"] # all others NA - denke ist durchlass 
data2[grepl(x = lib_type, pattern = "Buse"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Buse"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Buse"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Buse"), unique(EMO_NOM1)]
pw_data[NAME2  == "Durchlass", mean(score_up)]
data2[lib_type %in% c("Buse", "D", "Dalot"), c("name_neu", "score_up", "score_down")
      := .("Durchlass", 0.66,1)]

data2[lib_type == "Ouvrage mixte"] #  viele sind laut name Mühlen  
data2[grepl(x = lib_type, pattern = "Buse"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Buse"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Buse"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Buse"), unique(EMO_NOM1)]
pw_data[NAME2  == "Mühle", table(ABWAERTSPA)]

data2[lib_type == "Ouvrage mixte", c("name_neu", "score_up", "score_down")
      := .("Mühle", 0,1)]

data2[lib_type == "Ouvrage mobile"] #  viele sind laut name Mühlen  
data2[grepl(x = lib_type, pattern = "Ouvrage mobile"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Ouvrage mobile"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Ouvrage mobile"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Ouvrage mobile"), unique(EMO_NOM1)]

data2[lib_type == "Passerelle"] # Steg   
data2[grepl(x = lib_type, pattern = "Passerelle"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Passerelle"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Passerelle"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Passerelle"), unique(EMO_NOM1)]
pw_data[NAME2  == "Steg", table(ABWAERTSPA)]
pw_data[NAME2  == "Steg", table(AUFWAERTSP)]

data2[lib_type == "Passerelle", c("name_neu", "score_up", "score_down")
      := .("Steg", 1,1)]

data2[lib_type == "Pont"] # Brücke    
data2[grepl(x = lib_type, pattern = "Pont"), unique(lib_sys_ou)]
data2[grepl(x = lib_type, pattern = "Pont"), unique(NOM_PRINC)]
data2[grepl(x = lib_type, pattern = "Pont"), unique(TYPE_NOM )]
data2[grepl(x = lib_type, pattern = "Pont"), unique(EMO_NOM1)]
pw_data[NAME2  == "Brücke", table(ABWAERTSPA)]
pw_data[NAME2  == "Brücke", table(AUFWAERTSP)]

data2[lib_type %in% c("Pont", "Pont/Seuil"), c("name_neu", "score_up", "score_down")
      := .("Brücke", 1,1)]

data2[lib_type == "Seuil"]
pw_data[NAME2  == "Schwelle", table(ABWAERTSPA)]
pw_data[NAME2  == "Schwelle", table(AUFWAERTSP)]
data2[lib_type %in% c("Seuil"), c("name_neu", "score_up", "score_down")
      := .("Schwelle", 1,1)]

# grille -> ? 
# Vanne -> Schleuse 
# Poutres -> Balken/ Träger -> subsumiere ich unter Brücken.
# Batardeau -> Damm 
data2[is.na(score_up), unique(NOM_PRINC)] %>% sort
data2[is.na(score_up), unique(TYPE_NOM)] %>% sort
data2[is.na(score_up), unique(EMO_NOM1)] %>% sort
data2[is.na(score_up)]
pw_data[grepl(pattern = "Schleuse", x = pw_data$NAME)] 
# -> Schleusen fallen unter Wehr 
pw_data[NAME2 == "Wehr", mean(score_up)]
pw_data[NAME2 == "Wehr", mean(score_down)]
pw_data[NAME2 == "Damm", mean(score_up)]
pw_data[NAME2 == "Damm", mean(score_down)]
pw_data[NAME2 == "Teich", mean(score_down)]
pw_data[NAME2 == "Teich", mean(score_up)]
pw_data[NAME2 == "Rechenbauwerk", mean(score_down)]
pw_data[NAME2 == "Rechenbauwerk", mean(score_up)]
pw_data[NAME2 == "Gewässerkreuzung", mean(score_down)]
pw_data[NAME2 == "Gewässerkreuzung", mean(score_up)]
pw_data[NAME2 == "Ableitung", mean(score_down)]
pw_data[NAME2 == "Ableitung", mean(score_up)]


data2[is.na(score_up) & lib_sys_ou == "Vannes", 
      c("name_neu", "score_up", "score_down") := .("Wehr", 0.33, 1)]

data2[is.na(score_up) & lib_sys_ou == "Poutres", 
      c("name_neu", "score_up", "score_down") := .("Brücke", 1, 1)]

data2[is.na(score_up) & lib_sys_ou == "Batardeau", 
      c("name_neu", "score_up", "score_down") := .("Damm", 0.66, 0)]

data2[NOM_PRINC %in% c("Etang", "etang", "Etang Engel", "etang d'haspelschiedt", "etang d'entenboechel", "etang d'hasselfurt", "Ancien plan d'eau"), 
      c("name_neu", "score_up", "score_down") := .("Teich", 0, 1)]

data2[NOM_PRINC %in% c("digue etang"), 
      c("name_neu", "score_up", "score_down") := .("Damm", 0.66, 0)]

data2[NOM_PRINC %in% c("Passage sous voie firr", "Passage bust", "Passage sous chemin", 
                       "Passage sous supermarche et parking", "Passage sous stade", 
                       "Passage sous route", "Passage sous hapital et ville",
                       "Busage", "barrage de karlsmuhl", "Busage sous RD BitcheLemberg", 
                       "busage sous barrage ecriteur de crue", "Busage sous RD BitcheLemberg", 
                       "Buse sous la route", "Passage routier", "Pertuis _ irrigation"), 
      c("name_neu", "score_up", "score_down") := .("Durchlass", 0.66,1)]

data2[NOM_PRINC %in% c("Ancien moulin Eberbach", "DORFMaHLE", "Kuppertsmuehle", 
                       "Langmattermuehle", "Moulin-scierie","moulin Burgraff" ,
                       "Moulin d'Eschwiller", "Moulin de Butten","moulin de dorst" , 
                       "Moulin de loutzviller","moulin de weiskirch" ,"Moulin de Weiskirch prise d'eau",
                       "Moulin hydro lectrique RG" ,"Moulin infnrieur de Volmunster" ,"Neumuehle",                                          
                       "oligmuehle", "Schleifmuehle"), 
      c("name_neu", "score_up", "score_down") := .("Mühle", 0,1)]

data2[NOM_PRINC %in% c("Pont", "Pont acc", "Pont de la route forestiqre du grand Gruenewald", "Pont Zinsel du Sud", "enrochement aval pont",
                       "Rue du moulin", "Stade"),
      c("name_neu", "score_up", "score_down") := .("Brücke", 1,1)]

data2[NOM_PRINC %in% c("Seuil", "seuil aval pont", "petit seuil sous passerelle"),
      c("name_neu", "score_up", "score_down") := .("Schwelle", 1,1)]

data2[NOM_PRINC %in% c("barrage d'altmuhl", "barrage de karlsmuhl"),
      c("name_neu", "score_up", "score_down") := .("Sperrung", 0,0)]

data2[NOM_PRINC %in% c("Desableur"),
      c("name_neu", "score_up", "score_down") := .("Rechenbauwerk", 1,1)]

data2[NOM_PRINC %in% c("Confluence", "Schorbach proche confluence Horn"),
      c("name_neu", "score_up", "score_down") := .("Gewässerkreuzung", 1,1)]

data2[NOM_PRINC %in% c("D", "Deversoir du moulin de loutzviller", "Deversoir moulin d'eschviller", "Pris source", "Prise d'eau",
                       "prise d'eau bras de dtrivation de l' tang de Fleckenstein", "prise d'eau moulin Rehmuehle"),
      c("name_neu", "score_up", "score_down") := .("Abfluss", 1,1)]

data2[NOM_PRINC %in% c("Vannage", "vanne de la scierie", "Vannes"),
      c("name_neu", "score_up", "score_down") := .("Weiher", 0.33,1)]

# Reste 
data2[NOM_PRINC %in% c("Ancienne ptcherie", "Lavoir", "Lavoir_Obersteinbach", "Otherbuehl", "Pisciculture Liebfraunthal"),
      c("name_neu", "score_up", "score_down") := .("Misc QBW", 1,1)]


## -- TYPE_NOM

data2[is.na(score_up) & TYPE_NOM %in% c("Barrage"),
      c("name_neu", "score_up", "score_down") := .("Sperrung", 0,0)]

data2[is.na(score_up) & TYPE_NOM %in% c("Obstacle induit par un pont"),
      c("name_neu", "score_up", "score_down") := .("Brücke", 1,1)]

data2[is.na(score_up) & TYPE_NOM %in% c("Seuil en rivi0re", "Seuil en rivi4re","Seuil en rivi5re","Seuil en rivi6re","Seuil en rivi7re"),
      c("name_neu", "score_up", "score_down") := .("Schwelle", 1,1)]

# was jetzt noch übrig ist kriegt nur einsen. Kann ich nicht vergleichen. 
data2[is.na(score_up), c("name_neu","score_up", "score_down") := .("Misc QBW", 1,1)]



# Save to file  -----------------------------------------------------------

data3 <- st_as_sf(data2)
st_write(data3, "001_data/Querbauwerke/Querbauwerke_Nordvogesen/qbw_nv_clean.gpkg")

