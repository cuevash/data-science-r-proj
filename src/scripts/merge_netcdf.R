
# To print the command and its result in the output.
options(echo=TRUE)

myargs = commandArgs(trailingOnly=TRUE)
myargs

merge_netcdf <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here("params.yaml"))
  
  # Cities as the locations to be explored
  cities_sf <- readr::read_csv(here::here(config$prepare_points$cities_out_file)) |>
    sf::st_as_sf(coords = c("lng", "lat"), remove = FALSE) |>
    sf::st_set_crs(4326)

  # E-OBS Latest official release
  climatologies_europe_eobs_1950_2021_dat <- extract_sf_tibble_from_e_obs_for_coords(here::here(config$process$main_e_obs_netcdf), cities_sf)

  # E-OBS data Latest data not yet in the official release
  climatologies_europe_eobs_2022_dat <- extract_sf_tibble_from_e_obs_for_coords(here::here(config$process$cds_e_obs_europe_01_2022_01_01__2022_07_31_netcdf), cities_sf)

  # All Data together
  climatologies_europe_eobs_1950_2022_dat <-
    dplyr::bind_rows(climatologies_europe_eobs_1950_2021_dat, climatologies_europe_eobs_2022_dat)

  ##### OUTPUT
  # fs::dir_create(here::here(config$process$climatology_data))
  readr::write_csv(
    climatologies_europe_eobs_1950_2022_dat,
    file = here::here(config$process$climatology_data)
  )

}


