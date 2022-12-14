
#'
#' From a list of worlwide cities chooses some of them. The locations of these cities will be used
#' to explore climate around those points.
#'


prepare_points <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here("params.yaml"))
  
  # Cities as the locations to be explored
  cities_df <- readr::read_csv(config$prepare_points$cities_in_file) |>
    dplyr::filter(iso2 == "ES", population > 30000, !is.na(capital) ) |>
    dplyr::mutate(id = city) |>
    dplyr::filter(!id %in%  config$prepare_points$cities_exclude)

  # Out
  readr::write_csv(
    cities_df,
    file = here::here(config$prepare_points$cities_out_file)
  )
}

prepare_points()

