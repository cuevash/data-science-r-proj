
#'
#' From a list of worlwide cities chooses some of them. The locations of these cities will be used
#' to explore climate around those points.
#'

myargs = commandArgs(trailingOnly=TRUE)

params_file = myargs[1]

select_provinces_capital_spain <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here(params_file))
  
  # Cities as the locations to be explored
  cities_df <- readr::read_csv(config$cities_all_file) |>
    dplyr::filter(iso2 == "ES", population > 30000, !is.na(capital) ) |>
    dplyr::mutate(id = city) |>
    dplyr::filter(!id %in%  config$cities_exclude)

  # Out
  readr::write_csv(
    cities_df,
    file = here::here(config$cities_out_file)
  )
}

select_provinces_capital_spain()

