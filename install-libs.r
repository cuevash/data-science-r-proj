if (!"conflicted" %in% installed.packages()) install.packages("conflicted")
library(conflicted)

if (!"styler" %in% installed.packages()) install.packages("styler")
library(styler)

# When installing the sf packagae I Get some errors..
# To try to solve the erros I installe dthe binary packages of some libs 

if (!"rgdal" %in% installed.packages()) install.packages("rgdal", type = "mac.binary")
if (!"sf" %in% installed.packages()) install.packages("sf", type = "mac.binary")
if (!"raster" %in% installed.packages()) install.packages("raster", type = "mac.binary")
if (!"spDataLarge" %in% installed.packages()) install.packages("spDataLarge", repos = "https://nowosad.r-universe.dev")
if (!"tmap" %in% installed.packages()) install.packages("tmap", type = "mac.binary")

library(sf)

if (!"ecmwfr" %in% installed.packages()) install.packages("ecmwfr")
library(ecmwfr)

if (!"ncdf4" %in% installed.packages()) install.packages("ncdf4")
library(ncdf4)

if (!"tidyverse" %in% installed.packages()) install.packages("tidyverse")
library(tidyverse)

if (!"purrr" %in% installed.packages()) install.packages("purrr")
library(purrr)

if (!"fs" %in% installed.packages()) install.packages("fs")
library(fs)

if (!"lubridate" %in% installed.packages()) install.packages("lubridate")
library(lubridate)

if (!"tidync" %in% installed.packages()) install.packages("tidync")
library(tidync)

if (!"stars" %in% installed.packages()) install.packages("stars")
library(stars)

if (!"maps" %in% installed.packages()) install.packages("maps")
library(maps)

if (!"ggmap" %in% installed.packages()) install.packages("ggmap")
library(ggmap)

if (!"mapview" %in% installed.packages()) install.packages("mapview")
library(mapview)

if (!"spData" %in% installed.packages()) install.packages("spData")
library(spData)

if (!"ggplot2" %in% installed.packages()) install.packages("ggplot2")
library(ggplot2)

if (!"hrbrthemes" %in% installed.packages()) install.packages("hrbrthemes")
library(hrbrthemes)

if (!"plotly" %in% installed.packages()) install.packages("plotly")
library(plotly)

if (!"gapminder" %in% installed.packages()) install.packages("gapminder")
library(gapminder)

if (!"ggtext" %in% installed.packages()) install.packages("ggtext")
library(ggtext)

if (!"svglite" %in% installed.packages()) install.packages("svglite")
library(svglite)

conflict_prefer("map", "purrr")
conflict_prefer("filter", "dplyr")

renv::snapshot()