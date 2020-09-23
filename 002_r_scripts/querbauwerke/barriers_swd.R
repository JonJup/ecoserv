### -------------------------------- ###
### --- Barrier file schwarzwald --- ### 
### -------------------------------- ###

#date: 31.07.20 

# what? 


# setup -------------------------------------------------------------------
pacman::p_load(here, sf, dplyr, magrittr, beepr, data.table, readxl, stringr)
setwd(here())

# load data ---------------------------------------------------------------
barrier_swd <- st_read("001_data/Querbauwerke/Querbauwerke_Schwarzwald/qbw_sw.gpkg")
barrier_pwd <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/2020-06-18_qbw_rlp_hr_final.gpkg")
barrier_for_names <- read_excel("001_data/Querbauwerke/Querbauwerke_Schwarzwald/AKWB RBW 2020.05 Oberrheingebiet.xlsx")


# carpet ------------------------------------------------------------------
setDT(barrier_swd)
setDT(barrier_pwd)
u_swd <- unique(barrier_swd$Anlagentyp) %>% sort
u_pwd <- unique(barrier_pwd$NAME2) %>% sort

barrier_swd2 <- copy(barrier_swd)

barrier_swd2[,c("datenfÃ.hrende.Dienststelle", "OAC_NR", "WIBAS_ID", "GewÃ.sser..AWGN.", "GewÃ.sserkennzahl", "GewÃ.sser.ID") := NULL]
names(barrier_swd2)[1:2] <- c("name", "type_old")


## Kommentar Dammbalkenverschluss 
#Mein Verständiss von Dammbalken ist, dass diese idR nur temporär eingesetzt
#werden. Wenn sie eingesetzt sind, sind sie vermutlich unpasserbar. Nicht
#eingesezt stellen sie allderdings keine Behinderung dar. Daher weise ich ihnen 1 zu 
barrier_swd2[type_old == "Dammbalkenverschluss", c("type_new", "score_down", "score_up") := .("Dammbalkenverschluss",1,1)]

## Kommentr Dachwehr 
# Dachwehre sind beweglich. Sie haben idR immer einen Überlauf und schließen
# damit den FLuss nicht vollständig. Außerdem können Sie bei bedarf auch
# vollständig gesänkt werden. Keine Englische Übersetzung oder detusche
# Literatur zur Passierbarkeit gefunden


## Kommentar schÃ¼tz 

#Es handelt sich um Schütze(engl.: Sluice), Eine Barruiere im Wasser die in
#Schienen hoch gezogen oder gesenckt werden kann. Beim schwimmen unter einer
#Schütze kann es zu erhöter Mortalität bei Fischlarven (Marttin & De Graaf,2002
#in Mendley) kommen. Gardner et al. (2016)
#(https://www.tandfonline.com/doi/abs/10.1080/24705357.2016.1252251) finden,
#dass 91% von 94 Salmo salar erfolgreich ein Schütz passieren.
# Fazit: Es kommt auf den Fisch, das Lebensstadium und die Einstellung des Schützes (über- oder unterfluss sowie Grüße der Öffnung) an. 
# Ich denke die 95 ist ok für alle? 

# Laut Wikipedia ist eine Stauklappe auch ein Schütz

barrier_swd2[type_old %in% c("DrucksegmentschÃ¼tz", "HakendoppelschÃ¼tz", "HakenschÃ¼tz", "HubschÃ¼tz", "SektorschÃ¼tz", "Stauklappe", "ZugsegmentschÃ¼tz"), 
             c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]


barrier_pwd[NAME2 == "Wehr", table(score_down)]
barrier_pwd[NAME2 == "Wehr", table(score_up)]
barrier_swd2[type_old %in% c("Doppelklappe(Dachwehr)", "festes Wehr", "Heberwehr", "Schlauchwehr", "Staubalkenwehr", "Zwei- oder mehrteiliger Wehrverschluss"), c("type_new", "score_down", "score_up") := .("Wehr",1,0)]


barrier_swd2[is.na(score_down), unique(type_old)]

# Fix Umlaute 
barrier_swd2[, name := str_replace_all(name, pattern = "Ã¼", replacement = "ü")]
barrier_swd2[, name := str_replace_all(name, pattern = "Ãœ", replacement = "ü")]
barrier_swd2[, name := str_replace_all(name, pattern = "Ã¤", replacement = "ä")]
barrier_swd2[, name := str_replace_all(name, pattern = "Ã–", replacement = "ö")]
barrier_swd2[, name := str_replace_all(name, pattern = "Ã¶", replacement = "ö")]
barrier_swd2[, name := str_replace_all(name, pattern = "ÃŸ", replacement = "ß")]

barrier_swd2[type_old %in% c("Sonstige", "k.A"), type_old := NA]

u_pwd
(left_over_names <- barrier_swd2[is.na(score_down), sort(unique(name))])

barrier_pwd[NAME2 == "Auslauf", mean(score_down)]
barrier_pwd[NAME2 == "Auslauf", mean(score_up)]
barrier_pwd[NAME2 == "Misc QBW", table(score_down)]
barrier_pwd[NAME2 == "Mühle", table(score_up)]


# 
barrier_swd2[str_detect(name, "weiher$"), table(type_old)]
barrier_swd2[str_detect(name, "weiher$"), unique(name)]
barrier_swd2[str_detect(name, "Mühle$") &  is.na(type_old) & is.na(type_new), unique(name)]

# manual entries -------------------------------------------------------
## -- B -- ## 
barrier_swd2[name %in% c("Dogern_Aubecken_Schluchseewerk AG",
                         "Prinzbach-Zollgraben/zw. B33 und L94" ,                      
                         "Prinzbach-Zollgraben/L94"             ,                      
                         "Prinzbach-Zollgraben/Kinzig"          ,                      
                         "Prinzbach-Zollgraben/Kinzigdamm"      ,                      
                         "Prinzbach-Zollgraben/Am Kinzigdamm"   ,                      
                         "Prinzbach-Zollgraben/Mündungsbereich" ,
                         "Wyhl"                                 ,                      
                         "Zell-Weierbach / oberhalb Sportanlage",                     
                         "Zell i.W._Fessmann & Hecker",
                         "Rinnbach / Verbindungsstraße", 
                         "Gütenbach/ Hauptstraße Kirchstraße 1",                   
                         "Gütenbach/ Kreuzstraße",                   
                         "Gütenbach/ Schulstraße 1",                   
                         "Gütenbach/ Staatsberg",
                         "Fußbach /Straßenbrücke" ), 
             c("type_new", "score_down", "score_up") := .("Bruecke", 1, 1)]
## -- D -- ## 
barrier_swd2[name %in% c("Erddamm zum Aufstau Teich Amann öttiswald 2",
                         "Fernecker Querdamm"), 
             c("type_new", "score_down", "score_up") := .("Damm", 0, 1)]
## -- E -- ## 
barrier_swd2[name %in% c("Rinnbach / Spitzgraben-Einleitung"),
             c("type_new", "score_down", "score_up") := .("Einlauf", 1, 1)]
## -- M -- ## 
barrier_swd2[name %in% c("Bauwerk J",
                         "Bauwerk K",
                         "Querbauwerk",
                         "Blumberg_Mühlbach_Sonstiges",
                         "FP Korker Wald - Flussgraben Nord",                          
                         "FP Korker Wald - Flussgraben Mitte",                        
                         "FP Korker Wald - Flussgraben Süd",
                         "Rinnbach / Wildsättel / Pferdekoppel" ,    
                         "Rotzel_Wasserteiler Rotzeler Wühre  Hochsaler Wuhr" ,        
                         "Segeten 2b Schöpfe Hochsaler Wuhr aus Murg"    ,    
                         "Säckingen_Eggbergbecken_Schluchseewerk AG" ,    
                         "Sägmühle/ Mühlkanal Ettenheimmünster" ,    
                         "Sandfang Sandsee" ,    
                         "Sasbach" ,    
                         "Sasbach / Sasbachwalden/Bad" ,    
                         "Sasbach/Jechtingen" ,    
                         "Saubach - Engen",
                         "Wittnau_Alte Dreisam_ Segmente",
                         "Schmider, Hermann",                
                         "Schwallung Schwarzenbach",                
                         "Schweiz_Seegraben_Scharte",                
                         "Schwörstadt_Bechtelesgraben_Segment",                
                         "Schwörstadt_Bechtelesgraben_Segmente",                
                         "Schwörstadt_Bechtelesgraben_Sonstiges",                
                         "Siegelau/ Vogtssepphof",                
                         "Sölden_Scharte",                
                         "Sölden_Segment",                
                         "Stegwiesen",                
                         "Steinen_Schwammerich_Segment",                
                         "Steinen_Steinenbach_Segment",                
                         "Strittmatt_Ibachfassung_Schluchseewerk AG",                
                         "Stromerzeugung Weisser",                
                         "T23/5 Fallenanlage nähe Laimnau Bollenbach",                
                         "T39 Dr.Heyna",                
                         "Todtnau_Künbach_Segment",                    
                         "Triebwerk J. Grossmann (ehem. Lohsägemühle)",
                         "Unterentersbach/ Dorfstraße oberhalb Gasthaus" ,      
                         "Unterentersbach/ Dorfstraße Richtung Oberentersbach" ,      
                         "Unterentersbach/ Dorfstraße uh. Helmen" ,      
                         "Unterentersbach/ Untere Dorfsraße" ,      
                         "Unterentersbach/Dorfstraße/Zeller Straße" ,      
                         "Unterentersbach/In der Gass" ,      
                         "Unterentersbach/Kirche" ,      
                         "Untersimonswald/ Wachtfelsen" ,      
                         "Verbindungsbauwerk Quellengraben" ,      
                         "Verbindungsbauwerk Schwarzer Stock" ,      
                         "VErteilerbachwerk Krebsbach NN LB4 Rippolingen" ,      
                         "Vogtsburg i. Kaiserst.-Krottenbach_Segment" ,      
                         "Vogtsburg i. Kaiserst._Krottenbach_Segment" ,      
                         "Vogtsburg i. Kaiserstuhl_Krottenbach_Segment" ,      
                         "Vöhringen/Scharte" ,      
                         "Waldau" ,      
                         "Waldkirch/ Bäzenmatte" ,      
                         "Waldkirch/ Lochmättle" ,      
                         "Waldkirch/ Sportplatz" ,      
                         "Wasserentnahmestelle Kurhaus Bad Herrenalb" ,      
                         "Wasserversorgungsanlage Lützenhardt" ,      
                         "Wertheim Linner Tauberbad Flst.1540",
                         "Prinzbach/oberhalb B33" ,                              
                         "Reichenbach/ Langenbach" ,                                   
                         "Reichenbach/ Lindendobel" ,                                  
                         "Reichenbach/ Schindelloch" ,                                 
                         "Rheinfelden_Warmbach_Segment",                               
                         "Rickenbach_Dorfbachfassung_Schluchseewerk AG", 
                         "Rickenbach_Seelbach_Segment",             
                         "Ringsheim/ Hanfrößenfeld",            
                         "Ringsheim/ Reifenäckerle",           
                         "Rinnbach / Hasenfeld",          
                         "Rinnbach / Hilserhofen",         
                         "Rinnbach / Kinzig",        
                         "Rinnbach / Kleinzitzenhofen",       
                         "Rinnbach / Linx",      
                         "Rinnbach / Litzenmättig",     
                         "Rinnbach / Muhrfeldbiotop",
                         "Minseln_Segmente",                  
                         "Mooshof",                  
                         "Münchweier/ Mühlenweg",                  
                         "Oberalpfen_Steinbach_Segment",                  
                         "Obere Menzenschwander Kluse",                  
                         "Obersasbach/Erlenschachen",                  
                         "Opferdingen",                  
                         "Orschweier / Rittmatten / Wiesenwässerung",                  
                         "Panther, Thomas",
                         "Mauchen_Mauchenbach_Fischzucht im Hauptschluss", 
                         "Haslachsimonswald/ Goldsbachmatte",                   
                         "Haslachsimonswald/ Hanover",            
                         "Häusern_Schwarzabecken_Schluchseewerk AG",            
                         "Helbling",            
                         "Herbolzheim/ Unterhalb Kläranlage",            
                         "Herrenwieser Schwallung",            
                         "Hinter-Freiersbach/Langenberg",            
                         "Hofstetten/ Am Steuer",            
                         "Hofstetten/ Gihrenhof",            
                         "Hofstetten/ Westlich Tochtermannsberg",            
                         "Hornberg_Hornbergbecken_Schluchseewerk AG",            
                         "Hungerbühl",            
                         "Ibach_Schwarzenbach_Segmente",            
                         "Ichenheimer Faschinat",            
                         "Kandern_Lippisbach_Segment",            
                         "Katzenmoos/ Lindenweg",            
                         "Kinzigtal/Staighof",            
                         "Kippenheim",             
                         "Lehmann, Hubert",
                         "Görwihl_Eschenbächle aus Steimelbach (Vordere Wühre)",       
                         "Görwihl_Lochmühlebach_Tröndle",      
                         "Görwihl_NN-OT2 aus Steimelbach (Vordere Wühre)",      
                         "Görwihl_Rüßwihl_Lochmühlebach_Brett",      
                         "Görwihl_Rüßwihl_Lochmühlebach_Segmente",      
                         "Grafenhausen_Erlenbach_Scharte",      
                         "Grafenhausen_Schlücht_Scharte",      
                         "Grafenhausen_Schlücht_Segmente",      
                         "Grafenhausen_Schlücht_sonstiges",      
                         "Grimmelshofen_Mühlbach_Brett für Löschwasser",      
                         "Grombacher Entlastungsbauwerk",      
                         "Gross, Johannes",
                         "Brumatte / Stellfallen",                           
                         "Denzlingen/ Breitmatte",              
                         "Denzlingen/ Deutsche Bahnstrecke",              
                         "Denzlingen/ Fischnau 2",              
                         "Denzlingen/ Fischnau1",              
                         "Denzlingen/ Hanswinkel",              
                         "Denzlingen/ Hinter dem Berg",              
                         "Denzlingen/ Langer Brühl",              
                         "Denzlingen/ Langer Brühl 1",              
                         "Denzlingen/ Ochsenmatte",              
                         "Denzlingen/ Rauacker",              
                         "Denzlingen/ Rossmatte",              
                         "Denzlingen/ Vor dem Giesen",              
                         "Denzlingen/ Wagmatten",              
                         "Dietingen/Scharte",              
                         "Dietlingen/Scharte",              
                         "Dorfstraße / Ecke Engelgässle",              
                         "Dorfstraße 06 / W",              
                         "Ebersweierer Bach / Riesenwaldstr. 05",              
                         "Eckartweier/oberhalb Eckartweier",              
                         "Eggingen_Mauchenbach_Segmente",              
                         "Einbach/Echle, Naturfreundehaus",              
                         "Einbach/Laßgrund",              
                         "Entlastungsbauwerk Krummbach",              
                         "Entnahme Anlagesee Unteres Tal Heimbach",              
                         "Entnahmebauwerk 46",              
                         "Entnahmebauwerk 54",              
                         "Entnahmebauwerk 64",              
                         "Entnahmebauwerk Fischparadies Diersheim",              
                         "Entnahmebauwerk Kappes-Müller",              
                         "Entnahmebauwerk N",              
                         "Epfendorf W 1 Sauter",              
                         "Erzpoche",              
                         "Eschach 1",              
                         "Ettenheim/ An der Autobahn A5",              
                         "Ettenheim/ Stadtmitte",              
                         "Ettenheim/ Unterer Garten",              
                         "Fa c. Glauner Klosterbrauerei",              
                         "Fi-Regelbauwerk 1 Mühlhausen",              
                         "FP Korker Wald - Fischgießen",              
                         "FP Korker Wald - Kammbach",              
                         "Freiburg/Stadt",              
                         "Freiburg/Stadtgebiet",              
                         "Freiburg_Alte Dreisam_Segmwent",
                         "Alte Elz / E-Werk Kenzingen",                           
                         "Alte Elz / Hauptwässergraben",                
                         "Alte Elz / Kaisergrien / viele Stellfallen",                
                         "Alte Elz / Kappel / Mühlumführung",                
                         "Alte Elz / Kenzingen / Kleine Elz",                
                         "Alte Elz / Rheingießen",                
                         "Aubach",                
                         "Bader, Karl",                
                         "Bauknecht/Schemel",                
                          "Berau_Mettmabecken_Schluchseewerk AG",                 
                          "Berau_Witznaubecken_Schluchseewerk AG",                 
                          "Bifangweiher Mimmenhausen Flst. Nr. 465",                 
                          "Blumberg_Mühlbach_Scharte",                 
                          "Bohlsbach / Bahnquerung",                 
                          "Bollenbach Süd / vor überlaufschwelle",                 
                          "Breisach a. Rhein_Brühlgraben_Segment",                 
                          "Breisach a. Rhein_Brühlgraben_Sonstiges",                 
                          "Breitenbach RT altes Freibad",                 
                          "Luttingen_Wasserüberleitung Hochsaler Wuhr in Katzengraben "), 
             c("type_new", "score_down", "score_up") := .("Misc QBW", 1, 1)]

barrier_swd2[name %in% c("Münchweier/ Steiners Mühle" ,                                
                         "Oberkessach Obere Mühle" ,                                  
                         "Oberkessach Untere Mühle"  ,                                 
                         "Plauelbach/Willstätt Mühle"), 
             c("type_new", "score_down", "score_up") := .("Muehle", 1, 0)]
## -- S -- ## 
barrier_swd2[name %in% c(
        "Ettenheim/ Mittelried HRB",
        "Schließe im RHWD",
        "Schliesse zum Nägelegraben (Wolfertgraben)",
        "Mauchen_Mauchenbach_beweglicher Aufstau",
        "Grundablass HRB Untergrombach",
        "GA HRB Hägenich im Kl. Sulzbächle",                          
        "GA HRB Hägenich im S-L-R-Flutkanal"
), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
## -- T -- ## 
barrier_swd2[name %in% c("Teichanlage Stadt BS nördl. Rippolingen Aufstau durch Damm ", 
                         "Sasbach / In den Höfen / Teiche", 
                         "Tumlinger See",
                         "Böllen_Böllenbach_Löschwasserteich", 
                         "Rinnbach / Muhrfeldbiotop / Kiessee"
                         ), 
             c("type_new", "score_down", "score_up") := .("Teich", 1, 0)]

## -- W -- #
barrier_swd2[name %in% c("Willstätt/Altarm", 
                         "Willstätt / Einlassbauwerk ehem. Kinzigschleife (Altwasser)",
                         "Argenseebach Wehr Wuhrmühle"), 
             c("type_new", "score_down", "score_up") := .("Wehr", 0.9, 0.44)]

barrier_swd2[name %in% c("Linsenbergweiher"), 
            c("type_new", "score_down", "score_up") := .("Weiher", 1, 0.66)]

## -- A -- ## 
barrier_swd2[str_detect(name, "Absturz")    & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Absturz", 0.99, 0.36)]
barrier_swd2[str_detect(name, "Abzweig")    & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
barrier_swd2[str_detect(name, "Auslauf")    & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Auslauf", 1, 0)]
barrier_swd2[str_detect(name, "Ableitung")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
barrier_swd2[str_detect(name, "Ausleitung") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
barrier_swd2[str_detect(name, "ausleitung") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
barrier_swd2[str_detect(name, "ausleitung") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
barrier_swd2[str_detect(name, "Auslass")    & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Ableitung", 1, 1)]
 
## -- B -- ## 
barrier_swd2[str_detect(name, "Brücke")     & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Bruecke", 1,1)]

## -- D -- ## 
barrier_swd2[str_detect(name, "Düker")     & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up")  := .("Dueker", 1, 1)]
barrier_swd2[str_detect(name, "Durchlass")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Durchlass", 1, 1)]
barrier_swd2[str_detect(name, "Durchlaß")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up")  := .("Durchlass", 1, 1)]

## -- E -- ## 
barrier_swd2[str_detect(name, "Einlauf")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Einlauf", 1, 1)]
barrier_swd2[str_detect(name, "Einlauf")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Einlauf", 1, 1)]

## -- M -- ## 
barrier_swd2[str_detect(name, "mühle$")     & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Muehle", 1, 0)]
barrier_swd2[str_detect(name, "mühle ")     & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Muehle", 1, 0)]
## -- P -- ## 
barrier_swd2[str_detect(name, "Pegel")      & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Pegel", 1, 1)]

## -- S -- ## 
barrier_swd2[str_detect(name, "Schleuse")         & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schleuse", 0, 0)]
barrier_swd2[str_detect(name, "schleuse")         & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schleuse", 0, 0)]
barrier_swd2[str_detect(name, "schütz")           & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Schütz")           & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "^BW ")             & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "^HRB ")            & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "^RBS ")            & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Reglungsbauwerk")  & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Regelungsbauwerk") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "RegBW")            & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "RBW")              & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Regelungschieber") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Regelungsbw")      & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Schuetz", 0.95, 0.5)]
barrier_swd2[str_detect(name, "Stausee")          & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Stausee", 0, 0)]
barrier_swd2[str_detect(name, "Staustufe")        & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Staustufe", 0.33, 0)]
barrier_swd2[str_detect(name, "Stau")             & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Staumauer", 0, 0)]
barrier_swd2[str_detect(name, "sperre")           & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Staumauer", 0, 0)]

## -- T -- ## 
barrier_swd2[str_detect(name, "teich")           & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Teich", 1, 0)]

## -- W -- ## 
barrier_swd2[str_detect(name, "Wasserkraft") & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wasserwerk", 0.65, 0.16)]
barrier_swd2[str_detect(name, "WoWKA")       & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wasserwerk", 0.65, 0.16)]
barrier_swd2[str_detect(name, "WKA")         & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wasserwerk", 0.65, 0.16)]
barrier_swd2[str_detect(name, "Weiher")      & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Weiher", 1, 0.66)]
barrier_swd2[str_detect(name, "Wehr")        & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wehr", 0.9, 0.44)]
barrier_swd2[str_detect(name, "wehr")        & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wehr", 0.9, 0.44)]
barrier_swd2[str_detect(name, "^W ")         & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wehr", 0.9, 0.44)]
barrier_swd2[str_detect(name, "Sägewerk")         & is.na(type_old) & is.na(type_new), c("type_new", "score_down", "score_up") := .("Wehr", 0.9, 0.44)]

# save to file  -----------------------------------------------------------
barrier_swd2
saveRDS(object = barrier_swd2, 
        file = paste0("001_data/Querbauwerke/Querbauwerke_Schwarzwald/", Sys.Date(),"qbw_sw_clean"))

