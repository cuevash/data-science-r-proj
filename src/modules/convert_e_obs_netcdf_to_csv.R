
myargs = commandArgs(trailingOnly=TRUE)

netcdf_file = myargs[1]
out_file = myargs[2]

convert_e_obs_netcdf_to_csv <- function(netcdf_file, out_file) {
# Info from file 
e_obs_nc <- tidync::tidync(netcdf_file) 

# Build a minimum sf for the lon/lat values in the e_obs dataset
e_obs_lonlat_sf <- 
  e_obs_nc |>
  tidync::hyper_filter(time = index == 1) |>
  tidync::hyper_tibble() |> 
  # add date_time as proper datetime column from the original time column
  dplyr::mutate(date_time = lubridate::as_datetime(c(time * 60 * 60 * 24), origin="1950-01-01")) |>
  # Separate date parts to help with query processing
  dplyr::mutate(year = lubridate::year(date_time)) |>
  dplyr::mutate(month = lubridate::month(date_time)) |>
  dplyr::mutate(month_name = lubridate::month(date_time, label = TRUE)) |>
  dplyr::mutate(decade = as.character(as.integer((year %/% 10) * 10))) # Add decade class

  readr::write_csv2(e_obs_lonlat_sf, out_file)
}

print(out_file)

#convert_e_obs_netcdf_to_csv(netcdf_file, out_file)
