import::here(process_e_obs.R, extract_sf_tibble_from_e_obs_for_coords, .directory=here::here("src/modules/"))

myargs = commandArgs(trailingOnly=TRUE)

params_file = myargs[1]

extract_e_obs_points_for_coords <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here(params_file))
  
  # Cities as the locations to be explored
  coords_sf <- readr::read_csv(here::here(config$coords_file)) |>
    sf::st_as_sf(coords = c("lng", "lat"), remove = FALSE) |>
    sf::st_set_crs(4326)

  # E-OBS data
  climatologies_europe_dat <- extract_sf_tibble_from_e_obs_for_coords(here::here(config$e_obs_file), coords_sf)

  ##### OUTPUT
  # fs::dir_create(here::here(config$process$climatology_data))
  readr::write_csv(
    climatologies_europe_dat,
    file = here::here(config$out_file)
  )

}

extract_e_obs_points_for_coords()

