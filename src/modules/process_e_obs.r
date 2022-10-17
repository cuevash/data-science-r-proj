
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
e_obs_nc <- tidync::tidync(file_name) 

# Build a minimum sf for the lon/lat values in the e_obs dataset
e_obs_lonlat_sf <- 
  e_obs_nc |>
  tidync::hyper_filter(time = index == 1) |>
  tidync::hyper_tibble() |> 
  dplyr::select(longitude, latitude)  |> 
  sf::st_as_sf(coords = c("longitude", "latitude"),remove = FALSE) |>
  sf::st_set_crs(4326)

# Find out closest coordinates indexes
nearest_coords <- sf::st_nearest_feature(coords_sf, e_obs_lonlat_sf)

# Get the values and reverting the longitudes to the original format. Because we will use them to filter the # whole original file
lon_lat_values <- e_obs_lonlat_sf  |>  
  dplyr::slice(nearest_coords) |>
  dplyr::select(longitude,latitude) |> 
  (\(x) list( lon = dplyr::pull(x,longitude), lat = dplyr::pull(x,latitude)))()
  
# Add closest coords in original format to our set of cities

coords_ex_sf <- tibble::add_column(coords_sf, lon_in_eobs = lon_lat_values$lon, lat_in_eobs = lon_lat_values$lat)

# Extract all values for the exact coords choosen
e_obs_processed_sf <- coords_ex_sf$id |> 
    purrr::map(function(id) {
          lon = coords_ex_sf |> dplyr::filter(id == id) |> dplyr::pull(lon_in_eobs) 
          lat = coords_ex_sf |> dplyr::filter(id == id) |> dplyr::pull(lat_in_eobs)
          print(id)
          e_obs_nc |> 
            # The values are to avoid errors of comparing exact real values.
            tidync::hyper_filter( longitude = dplyr::between(longitude, lon - 0.01, lon + 0.01), latitude =  dplyr::between(latitude, lat - 0.01, lat + 0.01)) |>
            tidync::hyper_tibble() |>
            tibble::add_column(id = id)
        }) |>
    dplyr::bind_rows() |>
    dplyr::mutate(t2m_c = tg) |> 
    # add date_time as proper datetime column from the original time column
    dplyr::mutate(date_time = lubridate::as_datetime(c(time * 60 * 60 * 24), origin="1950-01-01")) |>
    # Separate date parts to help with query processing
    dplyr::mutate(year = lubridate::year(date_time)) |>
    dplyr::mutate(month = lubridate::month(date_time)) |>
    dplyr::mutate(month_name = lubridate::month(date_time, label = TRUE)) |>
    dplyr::mutate(decade = as.character(as.integer((year %/% 10) * 10))) |> # Add decade class
    sf::st_as_sf(coords = c("longitude", "latitude"),remove = FALSE) |>
    sf::st_set_crs(4326)

  e_obs_processed_sf
}
