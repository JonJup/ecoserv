### ------------------ ###
# --- Clean Barriers --- # 
### ------------------ ###

# Setup -------------------------------------------------------------------
pacman::p_load(sf, dplyr, magrittr, beepr, here, stringr, data.table)
setwd(here())

# load data  --------------------------------------------------------------
#barrier_pwhr_old <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/old/qbw-old.shp")
barrier_pwhr_new <- st_read("001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/querbauwerke.gpkg")
#barrier_nv   <- st_read("001_data/Querbauwerke/Querbauwerke_Nordvogesen/Ouvrages.shp")

setDT(barrier_pwhr_new)
barrier_pwhr_new[, NAME2 := NAME]

barrier_pwhr_new <- barrier_pwhr_new[AUFWAERTSP != "kein Bauwerk vorhanden"]
barrier_pwhr_new[grepl(x = NAME, pattern = "nicht"), NAME2 := "deleteme"]
barrier_pwhr_new <- barrier_pwhr_new[NAME2 != "deleteme"]
barrier_pwhr_new <- barrier_pwhr_new[NAME2 != "evtl. Kleiner Absturz"]
barrier_pwhr_new <- barrier_pwhr_new[NAME2 != "Glatte Rampe - beseitigt"]
barrier_pwhr_new <- barrier_pwhr_new[NAME2 != "Nicht vorh. Glatte Rampe"]
numbers_string <- 12159:20000 %>% as.character()
barrier_pwhr_new[NAME %in% numbers_string, NAME2 := "Number"]
barrier_pwhr_new[NAME == "2373220000", NAME2 := "Number"]

barrier_pwhr_new$NAME2 %>% unique %>% sort 

barrier_pwhr_new$NAME2 %>% unique %>% sort %>%  .[grep(x = ., pattern = "furt")]
barrier_pwhr_new$NAME %>% unique %>% sort %>%  .[grep(x = ., pattern = "furt")]


# Generell ----------------------------------------------------------------
barrier_pwhr_new[grepl(x = NAME, pattern = "Ableitung"),          NAME2 := "Ableitung"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Abschlag"),           NAME2 := "Abschlag"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Absetzbecken"),       NAME2 := "Absetzbecken"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Absturz"),            NAME2 := "Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Auslauf"),            NAME2 := "Auslauf"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Ausleitung"),         NAME2 := "Auslauf"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Absturztreppe"),      NAME2 := "Absturztreppe"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Blockierung"),       NAME2 := "Blockierung"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Bogendurchlass"),    NAME2 := "Bogendurchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Bogend."),           NAME2 := "Bogendurchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Brücke"),            NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "brücke"),            NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Bahnbrücke"),        NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Betonbrücke "),      NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Eisenbahnbrücke"),   NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Zufahrt"),           NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Durchlaß"),          NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Durchlass"),         NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "D "),                NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Verrohrung"),        NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Straßendurchlass"),  NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Strassendurchlass"), NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Grundschwelle"),     NAME2 := "Grundschwelle"]
barrier_pwhr_new[grepl(x = NAME, pattern = "hoher Absturz"),      NAME2 := "hoher Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Hoher Absturz"),      NAME2 := "hoher Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Kläranlage"),         NAME2 := "Kläranlage"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Klärwerk"),           NAME2 := "Kläranlage"]
barrier_pwhr_new[grepl(x = NAME, pattern = "kleiner Absturz"),    NAME2 := "kleiner Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Kleiner Absturz"),    NAME2 := "kleiner Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "kl. Absturz"),        NAME2 := "kleiner Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Kl. Absturz"),        NAME2 := "kleiner Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "kl.Absturz"),         NAME2 := "kleiner Absturz"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Mündung"),            NAME2 := "Mündung"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Sohlabsturz"),        NAME2 := "Absturz"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Betonsteg"),         NAME2 := "Steg"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Betonüberfahrt"),    NAME2 := "Brücke"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Fußgängersteg")   ,   NAME2 := "Steg"]
barrier_pwhr_new[grepl(x = NAME, pattern = "Holzsteg")        ,   NAME2 := "Steg"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Pegel"),             NAME2 := "Pegel"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Querbauwerk"),       NAME2 := "Querbauwerk"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Wehr"),              NAME2 := "Wehr"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "wehr"),              NAME2 := "Wehr"]
barrier_pwhr_new[grepl(x = NAME,  pattern = "ehem. Wehr"),        NAME2 := "Misc QBW"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "verrohrung"),        NAME2 := "Durchlass"]
barrier_pwhr_new[grepl(x = NAME2, pattern = "Woog"),              NAME2 := "Woog"]



## -- Special -- ## 
                                   

# A -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "2-geteilter Absturz",
        "2 Kleine Abstürze",
        "3 Abstürze",
        "Abst. Furt",
        "Abst. uh D",
        "Abst.Treppe",
        "natürliche Abstürze aus anstehenden Felsen",
        "Sohlabsturz oberhalb Landgrafenbrücke",
        "Sohlabsturz Lohrsdorfer Fußgängerbrücke Raue Rampe",
        "Sohlabsturz oberhalb Landgrafenbrücke 2",
        "Felsabsturz a.d. Wagnermühle",
        "Schrägabsturz",
        "Wasserfall Pyrmonter Mühle", 
        "Abstürze"
),
NAME2 := "Absturz"]

barrier_pwhr_new[NAME  %in% c("Eisenbahnbrücke mit kleinem Absturz"),
                 NAME2 := "Absturz und Brücke"]

barrier_pwhr_new[NAME %in% c(
        "Absturz u. Durchlass",
        "Durchlaß mit Absturz",
        "Durchlass mit Absturz",
        "Durchlass mit Absturz an der  Brücke",
        "Durchlass mit Absturz hinter Schäfersmühle",
        "Durchlass mit Absturz in Ochtendung",
        "Durchlass mit Absturz und Gleite",
        "Durchlass mit beseitigtem Kleinen Absturz",
        "Durchlass und kleiner Absturz",
        "Durchlaß mit sich anschließender glatter Gleite und kleinem Absturz"
),
NAME2 := "Absturz mit Durchlass"]

barrier_pwhr_new[NAME %in% c("Absturz mit Fischpass"),
                 NAME2 := "Absturz mit Fischpass"]

barrier_pwhr_new[NAME %in% c("Furt Fuchshofen, Absturz",
                             "Furt mit Absturz",
                             "Furt mit kleinem Absturz"),
                 NAME2 := "Absturz mit Furt"]

barrier_pwhr_new[NAME %in% c(
        "Absturz mit anschl. Glatter Gleite",
        "Absturz mit Gleite",
        "Glatte Gleite mit Absturz",
        "Gleite mit anschl. Absturz",
        "Absturz Liers, Raue Gleite",
        "Absturz mit Rauer Gleite",
        "Schrägabsturz mit glatter Gleite"
),
NAME2 := "Absturz mit Gleite"]

barrier_pwhr_new[NAME %in% c(
        "Absturz, raue Rampe",
        "Absturz und Raue Rampe / Gleite",
        "Absturz und Raue Gleite/Rampe",
        "Absturz und Raue Gleite / Rampe",
        "Absturz mit Rampe",
        "Absturz mit glatter Rampe",
        "Abstürze + Rampe"
),
NAME2 := "Absturz mit Rampe"]

barrier_pwhr_new[NAME %in% c("Absturz mit Umlauf"), NAME2 := "Absturz mit Umlauf"]

barrier_pwhr_new[NAME %in% c("Absturzkaskade"),     NAME2 := "Absturztreppe"]


# B -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "A 61",
        "A65",
        "Ã¿stliche Straßenbrücke Ortsumgehung",
        "Abbiegung Klosterstraße zur L 523",
        "Abzweig Feldweg",
        "B53, Mülheim (Mosel)",
        "Airbase",
        "Alte Eisenbahnzufahrt",
        "Alte Eisenbahnzufahrt Kraftwerk Biebermühle",
        "Altes Brückchen",
        "Am Albertgraben",
        "am Pumpwerk nördlich der B49",
        "Am Schmiedtor, Lambsheim",
        "An der Kesser, Lambsheim",
        "An der Klippelsmühle",
        "Appenheim Brunnengasse",
        "Appenheim Ingelheimer Straße",
        "Aquädukt",
        "Auffahrt B41",
        "Autobahn A 61",
        "B9",
        "B 37",
        "B41",
        "B41 Niederbrombach",
        "B41 Niederhambach",
        "B49",
        "B50",
        "B270 Sien",
        "B 271",
        "B 407",
        "B 420",
        "BÃ¿cke am Weidenbaum",
        "Bad Dürkheim, B 37",
        "Bad Dürkheim, Gerberstr.",
        "Bad Dürkheim, Kaiserslauterer Str.",
        "Bad Dürkheim, Kaiserslauterner Str.",
        "Bad Dürkheim, L516",
        "Bad Dürkheim, lange Verrohrung",
        "Bad Dürkheim, Naturkundemuseum",
        "Dackenheimer Str., Freinsheim",
        "Bad Dürkheim, Weinstraße Nord",
        "baufällige Holzbohlenbrücke",
        "baufällige Holzbrücke",
        "Becherbach Sportplatz",
        "Becherbach, Neue Straße",
        "bei  Erdorf",
        "bei  Metterich",
        "bei  Speicher",
        "Bernardshof",
        "Betonbrücke",
        "Betonzufahrt",
        "Betriebsauffahrt_Ab_72",
        "Bollwerkstraße",
        "Brückchen, Campingplatz",
        "Bubensteig, Lambsheim",
        "Bundesautobahn A3",
        "Bundesstraße B 41",
        "Bundesstraße B 53tt",
        "Bundesstraße B255",
        "Camping",
        "Campinplatz Papiermühle",
        "Dietrichsbrücke",
        "Eisenbahn-Viadukt",
        "Eisen Ortsmitte",
        "Einfahrt Olksmühle",
        "Emlandstrasse",
        "Erdorf",
        "Erpolzheim, Bürgerhaus",
        "Erpolzheim, Guthmannshausenerstr.",
        "Erpolzheim, Hauptstraße",
        "Erpolzheim, Im Kitzig",
        "Erpolzheim, Jahnstraße",
        "Erpolzheim, Privatsteg",
        "Feldwegbogenbrücke",
        "Feldwegbrücke",
        "Ferienpark Hambachtal Minigolfplatz",
        "Firma Cordier",
        "Firmengelände",
        "Fohren-Linden, Lindenstraße" ,
        "Fohren-Linden, Mühlweg",
        "Franz-Liszt-Str., Freinsheim",
        "Friedelhausen",
        "Fußgängerbücke",
        "Gau-Algesheim, An der Layenmühle",
        "Gau-Algesheim, Bahnhofstraße"    ,
        "Gau-Algesheim, Karl-Domdey-Straße",
        "Gau-Algesheim, Neugasse"         ,
        "Gau-Algesheim, Wüstenrotstraße"  ,
        "Gau Algesheim, Bahntrasse"        ,
        "Gau Algesheim, Im Hippel",
        "Grenze Truppenübungsplatz Baumholder",
        "Grethen, Friedrich-Ebert-Str.",
        "Großkarlbacher Str., Freinsheim",
        "Grubstr.",
        "Grundstücks-überfahrt",
        "Grundstücksüberfahrt",
        "Hammerschmiede",
        "Hardenburg, Schlossberg",
        "Hardenburg, Sporthalle",
        "Hauptstraße",
        "Hauptstraße Lingenfeld",
        "Hausen",
        "Hausen, Mitte",
        "Heimbach K60",
        "Heimbach L347",
        "Hetzerath Hauptstraße",
        "Hetzerath Kirchgäßchen",
        "Hof",
        "Hofeinfahrt",
        "Hofunterführung_Ab_254",
        "Hofzufahrt",
        "Hohestegstraße Lingenfeld",
        "Honigsäckelstraße, Ungstein",
        "Horbach",
        "Hüttingen a. d. Kyll",
        "Im Rüth, Weisenheim am Sand",
        "K 4",
        "K 5, Erpolzheimer Straße",
        "K145",
        "K16 südlich Minfeld",
        "K17 Wilzenberg",
        "K31",
        "K40",
        "K41",
        "K59",
        "K59 Niederehe",
        "K6 nordwestlich Schwollen",
        "K70 Otzweiler",
        "K71 Limbach",
        "K74 Kerpen",
        "K80",
        "K81" ,
        "K82 Bannberscheid",
        "K82 Staudt",
        "K85 westlich Nohn",
        "K86 zwischen Borler und Bodenbach",
        "K9",
        "Straßenbrücke L 477 am Pegel Walshausen",
        "Straßenbrücke K 7 bei Pegelanlage Niedermohr",
        "Kandel L554",
        "Kandel Schwanenweiher",
        "Kastend. Straße",
        "Kastend.Straße",
        "Kiebitzweg",
        "Kollweiler",
        "Kreisstraße K 94",
        "Kreuzung B39",
        "L 425",
        "L 454",
        "L 455",
        "L 455 (im Unterwasser)",
        "L 455, Freinsheim",
        "L 516",
        "L 526",
        "L141",
        "L169",
        "L169 Abzweig L176",
        "L173",
        "L173 Hußweiler",
        "L173 Kronweiler",
        "L174 Böschweiler",
        "L174 östlich Oberhambach",
        "L174 südlich Niederhambach",
        "L174 westlich Oberhambach",
        "L182 Heimweiler" ,
        "L182, nördlich Becherbach",
        "L182, südlich Becherbach",
        "L300",
        "L313",
        "L313 Eschelbach",
        "L314" ,
        "L315",
        "L318",
        "L347"  ,
        "L348 südöstlich Fohren-Linden",
        "L40",
        "L41"  ,
        "L454",
        "L47",
        "L49 südlich Heidweiler" ,
        "L516",
        "L542",
        "L542 östlich Landau-Bornheim",
        "L70 Bongard",
        "L72 südlich Trierscheid",
        "Lambsheim",
        "L70 Bongard"                        ,
        "L72 südlich Trierscheid",
        "Lambsheim",
        "Landesstraße L 288 - Hinterkirchen" ,
        "Landesstraße L 300 - Guckheim",
        "Landesstraße L 302 - Schneidmühle",
        "Landesstraße L 302 - Willmenrod",
        "Landesstraße L 496",
        "Landstraße L496",
        "landw. Überfahrt"                  ,
        "Leistadt, Hauptstrasse",
        "Leistadt, Waldstraße",
        "Leistadt, Weidenhof",
        "Liebenscheid, Langgasse",
        "Limbach Hintergasse",
        "Lindenstr.",
        "Museum unterm Trifels",
        "Nähe Bahnhof, Lambsheim",
        "Neustadt/Weinstraße, Zentrum",
        "Nieder-Hilbersheim Kreisstraße"       ,
        "Niederbieber - Boesner, Firma Textron",
        "Niederstaufenbach"                    ,
        "nord-westlich Erpolzheim"             ,
        "nördl. Erdorf"                        ,
        "nördl. Horbach"                       ,
        "nördl. Kallstadt"                     ,
        "Nördl. Kallstadt"                     ,
        "nördl. Leistadt"                      ,
        "nördl. Linden"                        ,
        "nördl. Wiesbach"                      ,
        "nördlich Erpolzheim"                  ,
        "nordöstl. Leistadt"                   ,
        "nordwestl. Erpolzheim"                ,
        "nordwestl. Kallstadt"                 ,
        "nordwestlich Erpolzheim"              ,
        "Nordwestlich Kallstadt" ,
        "Ober Hilbersheim, Im Kleegarten",
        "Oberstaufenbach"  ,
        "Ortseingang Neumühle",
        "Ortslage Ahrbrück (Am Kindergarten)",
        "Ortslage Ahrbrück (Rocchusstrasse)",
        "Ortslage Becherbach",
        "Ortslage Bruch, Burgstraße",
        "Ortslage Bruch, Schulstraße",
        "Ortslage Partenheim",
        "Ortslage Unterjeckenbach",
        "östl. Erpholzheim",
        "östl. Erpolzheim",
        "Parkplatzzufahrt",
        "Private Überfahrt",
        "Querung A6",
        "Querung A61",
        "Querung am alten Forsthaus",
        "Querung an Abzweig Waldweg",
        "Querung Feldweg",
        "Querung K7",
        "Querung K7, Flughafenbstraße",
        "Querung L453",
        "Querung L522",
        "Querung L523",
        "Querung unterhalb  L523, Adlerberg",
        "Radweg Gelbachtal",
        "Reichenbach",
        "Rheinstraße Gau-Algesheim",
        "Ruine Hardenburg",
        "Salmtal Dörbach K46",
        "Speyerer Str., Weisenheim am Sand",
        "Sien, Sickingerstraße",
        "Siedlung Weißenstein",
        "Sien, Schloßstraße",
        "Schwollen Hauptstraße",
        "Stadecken Bahnhofstraße",
        "Stadecken L413",
        "süd-westl. Erpolzheim",
        "südl. Bf.  Speicher" ,
        "südl. Erpolzheim",
        "südl. Mundhardterhof",
        "Theodor-Heuss-Str., Weinsheim am Sand",
        "Tintesmillen K148 Landesgrenze Deutschland-Luxemburg",
        "Überbauung",
        "Überbauung Fa. Cordier",
        "Überbauung Fabrik",
        "Überfahrt",
        "Überfahrt-Freizeitmobile",
        "Überfahrt aus Beton",
        "Überfahrt aus Holzbohlen",
        "Überfahrt aus Sandstein",
        "Überfahrt Gaststätte Saupferch, Absperbauwerk Fischteich",
        "Überfahrt Landwirstchaft Rohrdurchlass",
        "Überfahrt",
        "Überfahrt Linden",
        "Überfahrt mittels Rohr",
        "Überfahrt Queidersabach",
        "Überfahrt Queidersbach",
        "Überfahrt südl. Bann",
        "Überfahrt Werksgelände APO",
        "Überfahrt, Betonplatte",
        "unter Straße",
        "Ungstein",
        "Ungstein, Altenbacher Straße",
        "Unterführung A48" ,
        "Unterführung_A61"  ,
        "Unterführung_B256"  ,
        "Unterführung_B258_Virneburg",
        "Unterquerung Bahn", 
        "Weisenheimer Str., Freinsheim" ,           
        "Werksgelände Boehringer Ingelheim", 
        "Werksgelände Hochwaldsprudel",       
        "Werksgelände Spedition Ruppenthal", 
        "Westheim Haardtweg",       
        "Westheim Lindenstraße", 
        "westl Weisenheim am Sand",       
        "westl. Erpolzheim", 
        "westl. Lambsheim", 
        "Wirtschaftsweg, Armcor-Profil", 
        "Wiesenüberfahrt Randecker Hof", 
        "westl. Weisenheim"     ,                    
        "westl. Weisenheim am Sand",                 
        "weswtl. Erpolzheim" , 
        "Waldweg",
        "Wachenheim, Barfußpfad"        ,            
        "Wachenheim, Bürklin-Wolf-Str." ,            
        "Wald zwischen B9 und Rhein"    ,            
        "Wäldchenweg", 
        "Talweide, Freinsheim", 
        "Viehtränke_Ab_575"
),
NAME2 := "Brücke"]

barrier_pwhr_new[NAME %in% c("Durchlass, Brücke", "Durchlaß / Brücke", "Durchlass, Brücke B9"),
                 NAME := "Brücke mit Durchlass"]


# D -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "Bahndamm",
        "Damm Rückhaltebecken",
        "Erpolzheim, Bahndamm",
        "Staudamm mit Schützöffnungen",
        "Staudamm zur HW-Rückhaltung",
        "Weiherdamm"
),
NAME2 := "Damm"]

barrier_pwhr_new[NAME %in% c("Drainage_Ab_89_bis_94"),
                 NAME2 := "Drainage"]

barrier_pwhr_new[NAME %in% c("Drosselleitung RHB Horbach"),
                 NAME2 := "Drosselleitung"]

barrier_pwhr_new[NAME %in% c("Düker"),
                 NAME2 := "Düker"]

barrier_pwhr_new[NAME %in% c(
        "3-fach Rohrd.",
        "Autobahndurchlass A65",
        "Bahndurchlass",
        "Doppelrohrdurchlass_Ab_543",
        "Doppelter Rohrdurchlass",
        "DStraße Dill",
        "D. Straße Lüxem",
        "Eisenbahndurchlass",
        "funktionsloser Rohrdurchlass",
        "Rahmendurchlass",
        "Rahnendurchlass",
        "Rohrd. Zufahrt Haus",
        "Rohrdurchlass Zufahrt Weide",
        "Rohrdurchlass Lemberger Weiher",
        "Rohr Gussweg",
        "Rohr Straße",
        "Rohr Wildniss",
        "Rohr2",
        "Rohrd.",
        "Rohrd. Feldweg",
        "Rohrd. Straße",
        "Rohrd. Teich",
        "Rohrd. verfallen",
        "Rohrd. Weide",
        "Rohrd. Wiese",
        "Rohrd.Feldweg",
        "Rohrd.Weide",
        "Rohrdurchlass",
        "Rohrdurchlass - Anfang -",
        "Rohrdurchlass - Ende -",
        "Rohrdurchlass Abschnitt 154",
        "Rohrdurchlass Abschnitt 175",
        "Rohrdurchlass Abschnitt 180",
        "Rohrdurchlass Abschnitt 182",
        "Rohrdurchlass Abschnitt 184",
        "Rohrdurchlass Abschnitt 188",
        "Rohrdurchlass Altenwoogsmühle",
        "Rohrdurchlass B9",
        "Rohrdurchlass Feldweg",
        "Rohrdurchlass Heilbachtal",
        "Rohrdurchlass im Waldweg",
        "Rohrdurchlass MÃ¿nchweiler",
        "Rohrdurchlass Muendung 1",
        "Rohrdurchlass Muendung 2",
        "Rohrdurchlass RRB Niedersimten",
        "Rohrdurchlass Straße",
        "Rohrdurchlass unter Forstweg",
        "Rohrdurchlass unter Fortweg",
        "Rohrdurchlass Weideneinfahrt",
        "Überfahrt Rohrdurchlass oberhalb alter Eisenbahnbrücke",
        "Verrohrung Straße und entlang anschließendem Weiher",
        "Rohrdurchlass Wiesbach",
        "Rohrdurchlass Wieseneinfahrt",
        "Rohrdurchlass Wirtschaftsweg",
        "Rohrdurchlass_1_Erlenmühle",
        "Rohrdurchlass_2_Erlenmühle",
        "Rohrdurchlass_Ab_111",
        "Rohrdurchlass_Ab_139",
        "Rohrdurchlass_Ab_140",
        "Rohrdurchlass_Ab_15",
        "Rohrdurchlass_Ab_150",
        "Rohrdurchlass_Ab_228",
        "Rohrdurchlass_Ab_260",
        "Rohrdurchlass_Ab_271",
        "Rohrdurchlass_Ab_49a",
        "Rohrdurchlass_Ab_49b",
        "Rohrdurchlass_Ab_520",
        "Rohrdurchlass_Ab_53",
        "Rohrdurchlass_Ab_55a",
        "Rohrdurchlass_Ab_55b",
        "Rohrdurchlass_Ab_574",
        "Rohrdurchlass_Ab_576",
        "Rohrdurchlass_Ab_578",
        "Rohrdurchlass_Ab_580",
        "Rohrdurchlass_Ab_584",
        "Rohrdurchlass_Ab_586",
        "Rohrdurchlass_Ab_58a",
        "Rohrdurchlass_Ab_58b",
        "Rohrdurchlass_Ab_61",
        "Rohrdurchlass_Eisenbahn",
        "Rohre uh Teich",
        "Straßend. Waldk.",
        "Straßendurchlass",
        "Straßendurchlass B270"              ,
        "Straßendurchlass B420",
        "Straßendurchlass Bann"              ,
        "Straßendurchlass K 88",
        "Straßendurchlass K117"              ,
        "Straßendurchlass K20",
        "Straßendurchlass K20 Kirchenarnbach",
        "Straßendurchlass K28",
        "Straßendurchlass K37"               ,
        "Strassendurchlass K37",
        "Straßendurchlass K38"               ,
        "Straßendurchlass K503",
        "Straßendurchlass K53",
        "Verdohlung",
        "Verdohlung Rheinmühle",
        "Verdolung",
        "Verdolung der Mooslauter bei der Unteren Pfeifermühle",
        "Verdolung unter Supermarkt",
        "Verdolung, Sohlverbau" ,
        "Verohrung Queidersbach",
        "Verr. Heilgenmoschel"  ,
        "Verr. Heiligenmoschel" ,
        "Verr. Weide"           ,
        "Verr.Baggerbetrieb"    ,
        "Verrohrung"            ,
        "Verrohung B51",
        "Straßenndurchlass", 
        "Verdolung unter altem Mühlengebäude", 
        "Wegdurchlass", 
        "Verrohrung"  ,                              
        "Verrohung unter L 46", 
        "Dohl",
        "Dohl Sägewerk", 
        "Verrohrung"
),
NAME2 := "Durchlass"]

barrier_pwhr_new[NAME2 %in% "Bogendurchlass", NAME2 := "Durchlass"]

barrier_pwhr_new[NAME %in% c(
        "Durchlass mit Gleite",
        "Durchlass mit Rauer Gleite",
        "Glatte Gleite, Durchlass",
        "Raue Gleite und Durchlass",
        "Raue Gleite, Durchlass",
        "Raue Gleite, Durchlass, Sohlverbau"
),
NAME2 := "Durchlass mit Gleite"]

barrier_pwhr_new[NAME %in% c(
        "Durchlass mit Gleite",
        "Durchlass mit Rauer Gleite",
        "Glatte Gleite, Durchlass",
        "Mittelmühle, Sehr Hoher Absturz, Durchlass"
),
NAME2 := "Durchlass mit hohem Absturz"]

barrier_pwhr_new[NAME %in% c("Kleine Abstürze, Durchlass"),
                 NAME2 := "Durchlass mit kleinem Absturz"]

barrier_pwhr_new[NAME %in% c(
        "Durchlaß - glatte Rampe mit hohem Absturz",
        "Durchlass mit rauer Rampe",
        "Durchlass und Rampe",
        "Glatte Rampe, Durchlass",
        "Raue Rampe, Durchlass",
        "Straßend. + Rampe"
),
NAME2 := "Durchlass mit Rampe"]

barrier_pwhr_new[NAME %in% c("Durchlass, Sohlgleite"),
                 NAME2 := "Durchlass mit Sohlgleite"]

# F -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c("Furt",
                             "Furt Jugendherberge Altenahr",
                             "Furt Mayschoß",
                             "Furte", 
                             "Wegfurt"), 
                 NAME2 := "Furt"]

barrier_pwhr_new[NAME %in% c("Furt als Glatte Rampe"),
                 NAME2 := "Furt mit Rampe"]

barrier_pwhr_new[NAME %in% c(
        "Furt mit rauer Gleite",
        "Furt mit Rauer Gleite",
        "Furt mit Rauer Gleite / Rampe",
        "Furt, Raue Gleite"
),
NAME2 := "Furt mit Gleite"]



# G -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "Drei raue Gleiten",
        "ehem. Wiesenwehr - Glatte Gleite",
        "glatte Gleite",
        "Glatte Gleite",
        "Glatte Gleite, ehem. Durchlass",
        "Glatte Gleite - ehem. Wiesenwehr",
        "Glatte Gleite aus Fels",
        "Glatte Gleite / Rampe",
        "glatte Gleite mit Störsteinen",
        "glatte Gleite mit vorangehendem Ufer- und Sohlverbau",
        "Glatte Gleite, Raue Gleite",
        "Glatte Gleite, Wegfurt",
        "Gleite / Rampe",
        "Gleite mit hohem Absturz",
        "kleine raue Gleiten",
        "Raue Gleite an Durchlass",
        "Raue Gleite Alsdorfer Mühle",
        "Raue Gleite Niederzerfer Mühle",
        "Raue Gleite Wolsfelder Mühle",
        "Jüngstmühle, Raue Gleite",
        "3 kleine raue Gleiten",
        "Drei raue Gleiten",
        "Raue Gleite Georg-Weierbach - Wiesenwehr",
        "Raue Gleite, ehem. Friedrichswehr",
        "Raue Gleite",
        "raue Gleite / Rampe",
        "raue Gleite",
        "Raue Gleite / Rampe",
        "Raue Gleite / Rampe bei Niedergüdeln",
        "Raue Gleite / Rampe, Düker",
        "Raue Gleite / Sohlbefestigung",
        "Raue Gleite /Rampe",
        "Raue Gleite Abachsmühle",
        "Raue Gleite Annenmühle",
        "Raue Gleite Hofgut \"Burg Heid\" (Heidsmühle)",
        "Raue Gleite Hüstersmühle",
        "Raue Gleite Kirche Alsdorf",
        "Raue Gleite Klostermühle Arnstein",
        "Raue Gleite Lichtentalsmühle",
        "Raue Gleite Studentenmühle",
        "Raue Gleite Untermühle",
        "Raue Gleite Walkmühle",
        "Raue Gleite, ehem. Kleines Ochsenklavier",
        "Raue Gleite, ehem. Trapezabsturz",
        "Raue Gleite, ehem. Trapezabsturz, Sohlverbau",
        "Raue Gleite/ Rampe",
        "Raue Gleite/Rampe",
        "Raue Gleiten",
        "Schütztafelwehr, Raue Gleite",
        "Mehrere Gleiten / Rauschen",
        "Natürliche raue Gleite"  ,
        "Natürliche Raue Gleiten und Rampe",
        "rauhe Gleite / Rampe"
),
NAME2 := "Gleite"]

barrier_pwhr_new[NAME %in% c("Glatte Gleite mit anschließendem hohen Absturz",
                             "Glatte Gleite und hoher Absturz"),
                 NAME2 := "Gleite mit hohem Absturz"]

barrier_pwhr_new[NAME %in% c(
        "Gleite mit kleinem Absturz",
        "Kleiner Absturz mit Gleite",
        "Kleiner Absturz, Glatte Gleite",
        "Kleiner Absturz, Raue Gleite"
),
NAME2 := "Gleite mit kleinem Absturz"]


# H -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "hohe Abstürze",
        "hoher Schrägabsturz",
        "Hoher Schrägabsturz",
        "sehr hoher Schrägabsturz"
),
NAME2 := "hoher Absturz"]

barrier_pwhr_new[NAME %in% c("Hoher Trapezabsturz und Raue Gleite"),
                 NAME2 := "hoher Absturz mit Gleite"]

barrier_pwhr_new[NAME %in% c(
        "Glatte Rampe, Hoher Absturz",
        "Hoher Absturz mit Rauer Rampe",
        "Kleine bis sehr hohe Abstürze"
),
NAME2 := "hoher Absturz mit Rampe"]


# K -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c("Betonkanal"), NAME2 := "Kanal"]

barrier_pwhr_new[NAME %in% c(
        "Kl.Abst.Platten",
        "kl.Abstieg",
        "kleine Abstürze",
        "kleiner Absturz mit Steinriegel",
        "kleiner Absturz, Holzschwelle",
        "kleiner Absturz, Pflasterrinne, Verrohrung",
        "Kleine Abstürze"
),
NAME2 := "kleiner Absturz"]

barrier_pwhr_new[NAME %in% c("Kleiner Absturz, glatte Rampe"),
                 NAME2 := "kleiner Absturz mit Rampe"]

barrier_pwhr_new[NAME %in% c("Kleiner Absturz mit Umlauf"),
                 NAME2 := "kleiner Absturz mit Umlauf"]

barrier_pwhr_new[NAME %in% c("Kleine Raue Gleite", 
                             "Kleine Gleite"),
                 NAME2 := "kleine Gleite"]


# M -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "eh. Kupferhammer",
        "eh. WKA Fa. Glatz",
        "eh. WKA Fa. IAC (einst Fa. Häussling)",
        "ehem. glatte Gleite",
        "ehem. raue Gleite",
        "ehem. raue  Rampe",
        "ehem. Sägewerk Steiner",
        "Ehem. Schaffwehr",
        "Ehem. Schütztafelwehr",
        "ehem. Sohlschwelle",
        "ehem. Staustufe Hohenrhein",
        "ehem. Tisch- und Stuhlfabrik",
        "ehem. Wiesenwehr",
        "ehem. WKA Untermühle",
        "ehemalige Absperrung",
        "Ehemalige Absperrung Fischteich",
        "ehemalige glatte Gleite",
        "ehemalige raue Gleite",
        "ehemalige raue Rampe",
        "Ehemaliges Regelbauwerk oben",
        "Ehemaliges Regelbauwerk unten",
        "ehemalige Sohlschwelle",
        "ehemalige Staustufe",
        "ehemalige Uferbefestigung",
        "Ehemaliges Wiesenwehr, Sohlenrampe",
        "ehemalige WKA",
        "ehemaliges Regelbauwerk",
        "ehemaliges Wehr",
        "Ehrang",
        "Entnahme für  Fischteich",
        "Fiktiver Datensatz Bewertung Schwarzbach",
        "Fiktiver Datensatz Bewertung Sieg",
        "In den Forlen",
        "Kaltenbrunner Hütte",
        "Klaustal",
        "Mauer als Uferbegrenzung",
        "mehrere QBW",
        "Mosellaschacht",
        "Nachtweide 2",
        "Nettehammer",
        "Pappenfabrik",
        "Philippsburg",
        "Pumpwerk",
        "QBW oh Rückhaltebecken",
        "Querbauwerk",
        "Regenrückhaltebecken Klein-Winternheim (Auslass)",
        "Renaturierungsbereich",
        "Renaturierungsbereich, Wäldchenweg",
        "Rheinmündung",
        "Rückhaltebecken Böchingen",
        "Rückhaltebecken Rhodt unter unter Rietburg",
        "Sägewerk Becker",
        "Schloss Föhren",
        "Schule Niederbrombach",
        "Sportplatz",
        "Spotplatz Battweiler",
        "Steinschüttung bei Dierbach",
        "Störsteine, Sohlverbau",
        "Stadecken Auf der Silz",
        "südl. Queidersbach", 
        "Tannenhof", 
        "Teilung Erlenbach - Wattbach" ,                        
        "Truppenübungsplatz Baumholder", 
        "Weidenthal", 
        "Zaunanlage", 
        "Unter der Pford",                           
        "V-Profil"       ,                           
        "Verbau Höhe Hollergasse, Dierbach", 
        "Waldgaststätte Zum Schützenhaus" , 
        "V-Profil"
),
NAME2 := "Misc QBW"]

barrier_pwhr_new[NAME %in% c(
        "Ackermühle Guldental",
        "Alte Mühle",
        "Altmühle",
        "Aumühle",
        "Bann-Mühle",
        "Bannmühle",
        "Bannmühle Windesheim",
        "Bannmühle Stromberg",
        "Berizzi Mühle",
        "Bienwaldmühle",
        "Brummenmühle",
        "Burgalbenmühle",
        "Christiansmühle",
        "Cramersmühle Kallenfels",
        "Dauersberger Mühle",
        "Dorseler Mühle",
        "Dorfmühle",
        "Fischwoogmühle",
        "Freie Neumühle",
        "Fronmühle",
        "Etgertersägemühle",
        "Eyersheimer Mühle",
        "Furtmühle",
        "Goffingsmühle",
        "Grundhöfersche Mühle",
        "Gumbsweiler Mühle",
        "Haagsmühle, ehem. Glatte Rampe",
        "Hahnmühle",
        "Haus Schellenmühle",
        "Hecklersmühle",
        "Heilhauser Mühle",
        "Heinzenberger Mühle",
        "Horbachermühle",
        "Hoßmühle",
        "Iggelheimer Mühle (Walther Mühle)",
        "Irreler Mühle",
        "Jakobsmühle",
        "Klaramühle",
        "Klostermühle",
        "Knittelsheimer Mühle",
        "Kolbenmühle",
        "Lachnitsmühle",
        "Langmühle",
        "Langenauer Mühle",
        "Laubachsmühle",
        "Laubenheimer Mühle",
        "Lindener Mühle",
        "Linke Queichmühle",
        "Linke Queichmühle",
        "Lohmühle",
        "Looskyllermühle",
        "Luftmühle",
        "Mahlmühle",
        "Mausmühle",
        "Mittelbrunnermühle",
        "Mittelmühle",
        "Mittelmühle / Neumühle",
        "Moschelmühle im Kanal",
        "Neumühle",
        "Niedermühle",
        "Obere Horbachsmühle",
        "Obermühle",
        "Obermühle Bellheim",
        "Obermühle Kügler",
        "Mühle - Rheingrafenmühle"  ,
        "Mühle Breiner" ,
        "Mühle Erdesbach"  ,
        "Mühle Köhl" ,
        "Mühle Kügler Altenbamberg"  ,
        "Mühle Lauterbourg" ,
        "Mühle Matzenbach"  ,
        "Mühle Maurer" ,
        "Mühle Nanzdietschweiler"  ,
        "Mühle Norheim" ,
        "Mühle Opp"  ,
        "Mühle Rehhütte" ,
        "Mühle Rehweiler"  ,
        "Mühle Scheibenhard" ,
        "Mühle Schmidt"  ,
        "Mühle Spanier" ,
        "Mühle Steckweiler"  ,
        "Mühlenbäckerei Hahn" ,
        "Nähe  Albacher Mühle"  ,
        "Nesselrother Mühle" ,
        "Niederpierscheider Mühle"  ,
        "Obere Bettinger Mühle" ,
        "Paterbacher Mühle/Fockenmühle"  ,
        "Öl-/Untermühle"  ,
        "Ölmühle",
        "Papiermühle",
        "Pappelmühle" ,
        "Peffinger Mühle",
        "Pfeils-Mühle Gerolstein",
        "Pfirrmannsche Mühle und Garrechtsche Mühle",
        "Pintenmühle",
        "Pronsfelder Mühle",
        "Ranzenmühle",
        "Rauschenmühle",
        "Rauschermühle",
        "Rechte Queichmühle - Avril Mühle",
        "Riedelberger Mühle",
        "Schmeissbacher Mühle"                       ,
        "Schulder Mühle"               ,
        "Sinspelter Mühle"                           ,
        "Sohlschwelle \"Mühlengrund\"" ,
        "Spangenburger Mühle"                        ,
        "Steinalber Mühle"             ,
        "Untere Bettinger Mühle"                     ,
        "Untere Lünebacher Mühle"      ,
        "Untere Mühle",
        "westl. Eyersheimer Mühle",
        "Wiesweiler Mühle",
        "Zeiskamer Mühle",
        "Rieschweilermühle Sties",
        "Römersmühle/Kauchersmühle",
        "Rosengartenmühle",
        "Rosselmühle",
        "Sägemühle",
        "Schäfersmühle",
        "Schloßmühle"  ,
        "Schloßmühle Hanhofen",
        "Schmelzmühle",
        "Spitalmühle",
        "Stadtmühle Bergzabern",
        "Stadtmühle Annweiler",
        "Springiersbacher Klostermühle von 1731",
        "Steinmühle",
        "Theismühle" ,
        "Streitmühle",
        "Untermühle",
        "Untere Salmrohrer Sägemühle", 
        "Wappenschmiedmühle"
),
NAME2 := "Mühle"]


# Q -----------------------------------------------------------------------

barrier_pwhr_new[NAME %in% c("Querriegel aus Beton"), NAME2 := "Querriegel"]
# R -----------------------------------------------------------------------

barrier_pwhr_new[NAME %in% c(
        "Blocksteinrampe (ehem. Wehr der Fuchsmühle und Neumühle)",
        "glatte Rampe",
        "Glatte Rampe",
        "glatte Rampe mit Störsteinen",
        "Glatte Rampe, Gottschalksmühle",
        "Glatte Rampe Dockendorfer Mühle",
        "glatte Rampe unter Überbau",
        "Glatte Rampe, Unterhammer",
        "Glatte Rampe Wiesenwehr",
        "Raue Rampe mit Ausleitung",
        "Haidmühle - Raue Rampe",
        "halbseitige Steinrampe",
        "Hanosiusmühle",
        "Stauwehr 5/7 mit rauer Rampe",
        "Stauwehr 7/7 mit rauer Rampe",
        "Raue Rampe Korlinger Mühle",
        "Rampe / Gleite",
        "Rampe am Kindergarten in Plaidt",
        "Rampe an der Heinzkyllermühle",
        "Rampe mit anschl. Sohlsprung",
        "Rampe/Gleite",
        "Rampe_Ab_2",
        "Rampe_Ab_3",
        "Rampe_Ab_3a",
        "Rampe_Ab_4",
        "Rampe_Ab_5",
        "Rampe_Ab_6",
        "Rampen",
        "raue  Rampe",
        "Roeser Mühle, Glatte Rampe",
        "Mehrere raue Rampen",
        "raue Rampe",
        "Raue Rampe",
        "Raue Rampe / Gleite",
        "Raue Rampe am Kloster",
        "Raue Rampe Breitwiesenmühle",
        "Raue Rampe mit Umlauf",
        "Raue Rampe Pfeilsmühle Birresborn",
        "Raue Rampe zur Sohlstabilisierung",
        "Raue Rampe, Raue Gleite",
        "raue Rampe, z.T. aufgebrochen",
        "raue Rampe/Gleite",
        "Raue Rampe/Gleite",
        "Raue Rampe/Gleite Wagnermühle",
        "Raue Rampen",
        "Steinrampe", 
        "Wiesenmühle, Raue Rampe und Gleite", 
        "Vollrampe"
),
NAME2 := "Rampe"]

barrier_pwhr_new[NAME %in% c("beseitigtes Wehr Geißheckmühle heute mit  Blocksteinrampe)"),
                 NAME2 := "Rampe mit Wehr"]

barrier_pwhr_new[NAME %in% c("3 kleine raue Gleiten", "Drei raue Gleiten"), NAME2 := "Gleite"]

barrier_pwhr_new[NAME %in% c("Rechenbauwerk"), NAME2 := "Rechenbauwerk"]



# S -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c("Schnelle zwischen zwei Erlen",
                             "natürliche Schnellen und Rauschen"),
                 NAME2 := "Schnelle"]

barrier_pwhr_new[NAME %in% c(
        "Sohlschwelle",
        "Sohlschwelle 2 \"Kleingärten Wiesengärtenweg\"",
        "Sohlschwellen",
        "Schwelle Herdorf Bahnübergang",
        "Stützschwelle"  ,
        "Stützschwelle mit senkrechtem Ab-sturz"
),
NAME2 := "Schwelle"]

barrier_pwhr_new[NAME %in% c(
        "ökologisch durchgängige Sohlgleite in Ochtendung",
        "ökologisch durchgängige Sohlgleite zur Floecksmühle",
        "ökologisch durchgängige Sohlgleite, Korbsmühle",
        "Raue Sohlgleite",
        "Raue Sohlgleiten",
        "Sohlengleite mit Niedrigwasserrinne"
),
NAME2 := "Sohlgleite"]

barrier_pwhr_new[NAME %in% c("Sohlenverbau",
                             "Sohlenverbau an Einleitung",
                             "Sohlverbau",
                             "Sohlverbau Betonplatte"),
                 NAME2 := "Sohlenverbau"]
barrier_pwhr_new[NAME %in% c("Talsperre, Staumauer Vianden (100 % Lux.)"), NAME2 := "Staumauer"]


barrier_pwhr_new[NAME %in% c("Stausee Bad Bergzabern",
                             "Stausee Bitburg"),
                 NAME2 := "Stausee"]

barrier_pwhr_new[NAME %in% c(
        "Staustufe Detzem",
        "Staustufe Enkirch",
        "Staustufe Fankel",
        "Staustufe Grevenmacher",
        "Staustufe Koblenz",
        "Staustufe Lahnstein",
        "Staustufe Lehmen",
        "Staustufe Müden",
        "Staustufe Palzem",
        "Staustufe Serrig",
        "Staustufe St. Aldegund",
        "Staustufe Trier",
        "Staustufe Wintrich",
        "Staustufe Zeltingen"
),
NAME2 := "Staustufe"]

barrier_pwhr_new[NAME %in% c(
        "alter Holzsteg",
        "baufälliger   Holzsteg",
        "baufälliger Holzsteg",
        "Fußsteg",
        "Fußsteg auf Stahlträgern",
        "Hahlsteg Stampermühle",
        "kleiner Privatsteg Niederhausen",
        "(Privat)steg über Bach",
        "privater Steg",
        "Privater Steg",
        "Stahlbetonsteg" ,
        "Stahlblechsteg",
        "Stahlgittersteg (privat) Fischteiche" ,
        "Stahlsteg",
        "Stahlsteg (privat) Fischteiche" ,
        "Stahlsteg Fischteiche",
        "Stahlsteg nördl. Wiesbach" ,
        "Stahlsteg privat Fischteiche",
        "Stahlsteg Wiesbach",
        "Steg als Stahlkonstruktion",
        "Steg auf 2 Stahlträgern"  ,
        "Steg aus Gitterrost Wiesbach",
        "Steg aus Gitterrosten",
        "Steg aus Stahl",
        "Steg aus Stahlblechen",
        "Steg aus Wellblech",
        "Steg aus Wellblechen",
        "Steg bei Haus Nr. 12",
        "Steg Linden",
        "Steg Oberauerbach",
        "Steg Queidersbach",
        "Steg Sportplatz",
        "Steg Weide Horbach",
        "Steg Wiesbach",
        "Verfallener Steg südlich Niederhausen"
),
NAME2 := "Steg"]

# T -----------------------------------------------------------------------

barrier_pwhr_new[NAME %in% c("Teichanlage, Forstamt Quint"), NAME2 := "Teich"]

# V -----------------------------------------------------------------------

barrier_pwhr_new[NAME %in% c("V-Profil oberhalb Nonnenwerther Mühle", "V-Profil"), NAME2 := "V-Profil"]

# W -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c(
        "Altes Wasserwerk Godelshausen",
        "WKA Großsteinhauser Mühle",
        "WKA Klug'sche Mühle" ,
        "WKA Leimersheimer Mühle"  ,
        "WKA Windener Mühle",
        "Schütze,  WKA Reidinger",
        "WKA Achatmühle",
        "WKA Bangert (eh. Färberei Meier)",
        "WKA Graf Westerholt" ,
        "WKA Höhl" ,
        "WKA Holzmühle",
        "WKA Leistenmühle" ,
        "WKA Neumühle" ,
        "WKA Reidinger",
        "WKA Sägmühle", 
        "Wasserkraftanlage Altwied", 
        "WK-Anlage Oberbettingen", 
        "WWK Hoppstädten-Weiersbach / Altmaiermühle"
),
NAME2 := "Wasserwerk"]

barrier_pwhr_new[NAME %in% c(
        "Billesweiher",
        "Gebertsholzweiher",
        "Germersheimer Teilungswehr",
        "Isenachweiher",
        "Lemberger Weiher",
        "Oberer Stüdenbachweiher",
        "Rohrbacherweiher"
),
NAME2 := "Weiher"]

barrier_pwhr_new[NAME %in% c("Freusburger Unterwehr",
                             "Hochwasserentlastungswehr"),
                 NAME2 := "Wehr"]

barrier_pwhr_new[NAME %in% c("Wehr mit Umlauf"),      NAME2 := "Wehr mit Umlauf"]
barrier_pwhr_new[NAME %in% c("Wehr mit Rutsche"),     NAME2 := "Wehr mit Rutsche"]

barrier_pwhr_new[NAME %in% c("Biedenbacherwoog"),     NAME2 := "Woog"]


# Z -----------------------------------------------------------------------
barrier_pwhr_new[NAME %in% c("Zugang Gartenbereich",
                             "Zugang Grundstück/Gehöft",
                             "Zugang Lettenmühle"),     
                 NAME2 := "Zugang"]

saveRDS(object = barrier_pwhr_new, 
        file   = "001_data/Querbauwerke/Querbauwerke_Pfalz_Hunsrueck/ok/querbauwerke_clean.RDS")
