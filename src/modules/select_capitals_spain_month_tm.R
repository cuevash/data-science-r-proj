myargs = commandArgs(trailingOnly=TRUE)

params_file = myargs[1]

select_capitals_spain_month_tm <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here(params_file))

  # Load data
  climatologies_dat_tbbl <- readr::read_csv(here::here(config$e_obs_coords_file))
  month_in_study = config$month

  # Summarize by month
  climatologies_monthly_ext_dat <- climatologies_dat_tbbl |>
    dplyr::group_by(id, year, month) |>
    dplyr::summarise(temp_month_mean = mean(t2m_c)) |>
    dplyr::ungroup() 

  ##### OUTPUT
  readr::write_csv(
    climatologies_monthly_ext_dat,
    file = here::here(config$out_file)
  )
}

select_capitals_spain_month_tm()




