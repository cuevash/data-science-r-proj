climatologies <- tidync::tidync("./remote-data/tg_0.1deg_day_2022_grid_ensmean_v2.nc")

lonlat_sf <- climatologies |>
  tidync::hyper_filter(time = index == 1) |> 
  tidync::hyper_tibble()

climatologies_old <- tidync::tidync("./remote-data/tg_0.1deg_day_2022_grid_ensmean.nc")

lonlat_sf_old <- climatologies |>
  tidync::hyper_filter(time = index == 1) |> 
  tidync::hyper_tibble()
