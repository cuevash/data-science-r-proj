  import::here(process_e_obs_temp.r, extract_sf_tibble_from_e_obs_for_coords, .directory=here::here("src/modules/"))

  # Configuration
  config <- yaml::read_yaml(here::here("params.yaml"))
  
  # Cities as the locations to be explored
  cities_sf <- readr::read_csv(here::here(config$prepare_points$cities_out_file)) |>
    sf::st_as_sf(coords = c("lng", "lat"), remove = FALSE) |>
    sf::st_set_crs(4326) # |>
    # dplyr::filter(city %in% c("Madrid", "Burgos"))

  # E-OBS data Latest data not yet in the official release
  climatologies_europe_eobs_2022_dat <- extract_sf_tibble_from_e_obs_for_coords(here::here(config$process$cds_e_obs_europe_01_2022_01_01__2022_07_31_netcdf), cities_sf)

  
  df <- tibble(id = 1:4, w = runif(4), x = runif(4), y = runif(4), z = runif(4))
  df |>
    rowwise() |>
    summarise(
      sum = sum(c_across(where(is.logical)))
    )
  
  
  df <- tibble(x = 1:3, y = 3:1)
  
  df %>% add_column(z = -1:1, w = 0)
  
  