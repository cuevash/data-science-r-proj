import::here(tidync, hyper_filter, hyper_tibble, .from = tidync)
import::here(between, select, slice, pull, bind_rows, mutate, .from = dplyr)
import::here(st_set_crs, st_as_sf, st_nearest_feature, st_crs, .from = sf)
import::here(add_column, .from = tibble)
import::here(map, .from = purrr)
import::here(as_datetime, year, month, .from = lubridate)

#' Process an e_obs netcdf file, plucking all data related to a list of (latitude, longitude).
#'
#' Returns a tibble of all the data. There is not processing of the data beyond the filtering out of data 
#' and the conversion of the main netcdf axis into a tibble. 
#'
#' @param file_name e-obs netcdf file name
#' @param coords_sf an sf with points that will be used to filter the data from the e-obs dataset
#'  columns:
#'    latitude
#'    longitude
#'    id          // id that identifies the point (eg: a city name)
#'
#' @return a sf tibble with the data extracted and id of the coords_sf added to each coordinate point
#'
#' @md

extract_sf_tibble_from_e_obs_for_coords <- function(file_name, coords_sf) {

# Info from file 
e_obs_nc <- tidync(file_name) 

# Build a minimum sf for the lon/lat values in the e_obs dataset
e_obs_lonlat_sf <- 
  e_obs_nc |>
  hyper_filter(time = index == 1) |>
  hyper_tibble() |> 
  select(longitude, latitude)  |> 
  st_as_sf(coords = c("longitude", "latitude"),remove = FALSE) |>
  st_set_crs(4326)

# Find out closest coordinates indexes
nearest_coords <- st_nearest_feature(coords_sf, e_obs_lonlat_sf)

# Get the values and reverting the longitudes to the original format. Because we will use them to filter the # whole original file
lon_lat_values <- e_obs_lonlat_sf  |>  
  slice(nearest_coords) |>
  select(longitude,latitude) |> 
  (\(x) list( lon = pull(x,longitude), lat = pull(x,latitude)))()
  
# Add closest coords in original format to our set of cities

coords_ex_sf <- add_column(coords_sf, lon_in_eobs = lon_lat_values$lon, lat_in_eobs = lon_lat_values$lat)

# Extract all values for the exact coords choosen
e_obs_processed_sf <- coords_ex_sf$id |> 
    map(function(id) {
          lon = coords_ex_sf |> filter(id == id) |> pull(lon_in_eobs) 
          lat = coords_ex_sf |> filter(id == id) |> pull(lat_in_eobs)
          print(id)
          e_obs_nc |> 
            # The values are to avoid errors of comparing exact real values.
            hyper_filter( longitude = dplyr::between(longitude, lon - 0.01, lon + 0.01), latitude =  dplyr::between(latitude, lat - 0.01, lat + 0.01)) |>
            hyper_tibble() |>
            add_column(id = id)
        }) |>
    bind_rows() |>
    mutate(t2m_c = tg) |> 
    # add date_time as proper datetime column from the original time column
    mutate(date_time = as_datetime(c(time * 60 * 60 * 24), origin="1950-01-01")) |>
    # Separate date parts to help with query processing
    mutate(year = year(date_time)) |>
    mutate(month = month(date_time)) |>
    mutate(month_name = month(date_time, label = TRUE)) |>
    mutate(decade = as.character(as.integer((year %/% 10) * 10))) |> # Add decade class
    st_as_sf(coords = c("longitude", "latitude"),remove = FALSE) |>
    st_set_crs(4326)

  e_obs_processed_sf
}
