if (!"conflicted" %in% installed.packages()) renv::install("conflicted")
library(conflicted)

if (!"here" %in% installed.packages()) renv::install("here")

if (!"styler" %in% installed.packages()) renv::install("styler")
library(styler)

# When installing the sf packagae I Get some errors..
# To try to solve the erros I installe dthe binary packages of some libs 

if (!"rgdal" %in% installed.packages()) renv::install("rgdal", type = "mac.binary")
if (!"sf" %in% installed.packages()) renv::install("sf", type = "mac.binary")
if (!"raster" %in% installed.packages()) renv::install("raster", type = "mac.binary")
if (!"spDataLarge" %in% installed.packages()) renv::install("spDataLarge", repos = "https://nowosad.r-universe.dev")
if (!"tmap" %in% installed.packages()) renv::install("tmap", type = "mac.binary")

library(sf)

if (!"ecmwfr" %in% installed.packages()) renv::install("ecmwfr")
library(ecmwfr)

if (!"ncdf4" %in% installed.packages()) renv::install("ncdf4")
library(ncdf4)

if (!"tidyverse" %in% installed.packages()) renv::install("tidyverse")
library(tidyverse)

if (!"purrr" %in% installed.packages()) renv::install("purrr")
library(purrr)

if (!"fs" %in% installed.packages()) renv::install("fs")
library(fs)

if (!"lubridate" %in% installed.packages()) renv::install("lubridate")
library(lubridate)

if (!"tidync" %in% installed.packages()) renv::install("tidync")
library(tidync)

if (!"stars" %in% installed.packages()) renv::install("stars")
library(stars)

if (!"maps" %in% installed.packages()) renv::install("maps")
library(maps)

if (!"ggmap" %in% installed.packages()) renv::install("ggmap")
library(ggmap)

if (!"mapview" %in% installed.packages()) renv::install("mapview")
library(mapview)

if (!"spData" %in% installed.packages()) renv::install("spData")
library(spData)

if (!"ggplot2" %in% installed.packages()) renv::install("ggplot2")
library(ggplot2)

if (!"hrbrthemes" %in% installed.packages()) renv::install("hrbrthemes")
library(hrbrthemes)

if (!"plotly" %in% installed.packages()) renv::install("plotly")
library(plotly)

if (!"gapminder" %in% installed.packages()) renv::install("gapminder")
library(gapminder)

if (!"ggtext" %in% installed.packages()) renv::install("ggtext")
library(ggtext)

if (!"svglite" %in% installed.packages()) renv::install("svglite")
library(svglite)

if (!"yaml" %in% installed.packages()) renv::install("yaml@2.3.5")
library(yaml)

conflict_prefer("map", "purrr")
conflict_prefer("filter", "dplyr")

renv::snapshot()