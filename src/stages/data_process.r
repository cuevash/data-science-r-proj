import::here(here, here)
import::here(tidync, hyper_filter, hyper_tibble, .from = tidync)
import::here(select, slice, pull, bind_rows, mutate, filter, .from = dplyr)
import::here(sf, st_as_sf, st_nearest_feature, st_crs, st_set_crs)
import::here(add_column, .from = tibble)
import::here(map, .from = purrr)
import::here(read_yaml, .from = yaml)
import::here(read_csv,write_csv, .from = readr)
import::here(process_e_obs.r, extract_sf_tibble_from_e_obs_for_coords, .directory=here("src/modules/"))
import::here(dir_create, .from = fs)

data_process <- function() {
  # Configuration
  config <- read_yaml(here("params.yaml"))
  print(config)
  
  # Cities as the locations to be explored
  cities_set_df <- read_csv(config$data$cities_csv) |>
    filter(iso2 == "ES", population > 30000, !is.na(capital) )

  cities_set_sf <- cities_set_df |>
    filter(city == "Madrid") |>
    mutate(id = city) |>
    st_as_sf(coords = c("lng", "lat"), remove = FALSE) |>
    st_set_crs(4326)

  # E-OBS data from1950 - 2021
  climatologies_europe_eobs_1950_2021_dat <- extract_sf_tibble_from_e_obs_for_coords(here(config$data$cds_e_obs_europe_0.1_v25.0e_netcdf), cities_set_sf)

  # E-OBS data 2022 2022-01-01-2022-07-31
  climatologies_europe_eobs_2022_dat <- extract_sf_tibble_from_e_obs_for_coords(here(config$data$cds_e_obs_europe_0.1_2022_01_01__2022_07_31_netcdf), cities_set_sf)

  # All Data together
  climatologies_europe_eobs_1950_2022_dat <-
    bind_rows(climatologies_europe_eobs_1950_2021_dat, climatologies_europe_eobs_2022_dat)

  ##### OUTPUT
  dir_create(here("data/processed/"))
  write_csv(
    climatologies_europe_eobs_1950_2022_dat,
    file = here(config$data$plot_set_path)
  )
}

