if (!"import" %in% installed.packages()) renv::install("import")

if (!"styler" %in% installed.packages()) renv::install("styler")

# When installing the sf packagae I Get some errors..
# To try to solve the erros I installe dthe binary packages of some libs 

if (!"rgdal" %in% installed.packages()) renv::install("rgdal", type = "mac.binary")
if (!"sf" %in% installed.packages()) renv::install("sf", type = "mac.binary")
if (!"raster" %in% installed.packages()) renv::install("raster", type = "mac.binary")
if (!"spDataLarge" %in% installed.packages()) renv::install("spDataLarge", repos = "https://nowosad.r-universe.dev")
if (!"tmap" %in% installed.packages()) renv::install("tmap", type = "mac.binary")

if (!"ecmwfr" %in% installed.packages()) renv::install("ecmwfr")

if (!"ncdf4" %in% installed.packages()) renv::install("ncdf4")

if (!"tidyverse" %in% installed.packages()) renv::install("tidyverse")

if (!"purrr" %in% installed.packages()) renv::install("purrr")

if (!"fs" %in% installed.packages()) renv::install("fs")

if (!"lubridate" %in% installed.packages()) renv::install("lubridate")

if (!"tidync" %in% installed.packages()) renv::install("tidync")

if (!"stars" %in% installed.packages()) renv::install("stars")

if (!"maps" %in% installed.packages()) renv::install("maps")

if (!"ggmap" %in% installed.packages()) renv::install("ggmap")

if (!"mapview" %in% installed.packages()) renv::install("mapview")

if (!"spData" %in% installed.packages()) renv::install("spData")

if (!"ggplot2" %in% installed.packages()) renv::install("ggplot2")

if (!"hrbrthemes" %in% installed.packages()) renv::install("hrbrthemes")

if (!"plotly" %in% installed.packages()) renv::install("plotly")

if (!"gapminder" %in% installed.packages()) renv::install("gapminder")

if (!"ggtext" %in% installed.packages()) renv::install("ggtext")

if (!"svglite" %in% installed.packages()) renv::install("svglite")

if (!"yaml" %in% installed.packages()) renv::install("yaml@2.3.5")

if (!"here" %in% installed.packages()) renv::install("here")

renv::snapshot()