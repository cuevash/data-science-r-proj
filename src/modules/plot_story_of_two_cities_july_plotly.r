import::here(here, here)
import::here(tidync, hyper_filter, hyper_tibble, .from = tidync)
import::here(select, slice, pull, bind_rows, mutate, filter, arrange, distinct, group_by,summarise, ungroup, rename,  .from = dplyr)
import::here(sf, st_as_sf, st_nearest_feature, st_crs, st_set_crs)
import::here(add_column, .from = tibble)
import::here(map, .from = purrr)
import::here(read_yaml, .from = yaml)
import::here(read_csv,write_csv, write_file, .from = readr)
import::here(process_e_obs.r, extract_sf_tibble_from_e_obs_for_coords, .directory=here("src/modules/"))
import::here(dir_create, path, path_join, path_split, .from = fs)
import::here(ggplot, aes, theme, element_text, labs, geom_point, geom_line, geom_smooth, geom_label, .from = ggplot2)
import::here(tibble, .from = tibble)
import::here(svglite, .from = svglite)
import::here(ggplotly, add_annotations, .from = plotly)
import::here(str_interp, .from = stringr)

plotting_plotly <- function() {
  # Configuration
  config <- read_yaml(here("params.yaml"))
  print(config)

  # Load data
  climatologies_europe_eobs_1950_2022_dat_tbbl <- read_csv(here(config$data$plot_set_path))
  
  # Create out directories
  graph_path_plotly <- path(here("out/cds_e_obs_spain_cities_story_of_two_cities_july") , ext = "html")

  #
  cities_in_study = c("Sevilla", "Burgos")
  month_in_study = 7

  year_in_middle = climatologies_europe_eobs_1950_2022_dat_tbbl |>
    select(year) |>
    distinct() |>
    arrange(year) |> 
    {\(dat) round(median(dat$year))}()

  # Summarize by month and prepare Name of columns (for tooltips)
  climatologies_monthly_ext_dat <- climatologies_europe_eobs_1950_2022_dat_tbbl |>
    group_by(id, year, month) |>
    summarise(temp_month_mean = mean(t2m_c)) |>
    ungroup() |>
    mutate(City = id, Year = year, "Temp Avgr." = temp_month_mean )

  labels_dat <- cities_in_study |> map(function(city_name) {
      climatologies_monthly_ext_dat |> 
      filter(id == city_name, year == year_in_middle, month == month_in_study) |>
      pull(temp_month_mean)
    }) |> 
    unlist() |>
    (\(y_values) {
      print(y_values)
     tibble( city = cities_in_study, x = year_in_middle, y = y_values)
  })()


  story_of_two_cities_july_base_plot <- climatologies_monthly_ext_dat |>
    filter(id %in% cities_in_study, month == 7) |>
    ggplot(aes(x = Year, y = `Temp Avgr.`, group = City)) + 
    theme(plot.title = element_text(size = 14)) +
     labs(
      x = "Year", 
      y = "Average temperature Cº", 
      title = "Average Temperature in July - Tale of two Cities? or the same story..",
      caption = "Data from: CDS - ERA5 monthly averaged data on single levels from 1959 to present[1959-2022]"
    )

  story_of_two_cities_july_plot = story_of_two_cities_july_base_plot +
    geom_point() +
    geom_line(stat = "identity") +
    geom_smooth(method = "lm", se = FALSE)   +
    geom_label(data = labels_dat, alpha = 0.75, inherit.aes = FALSE, aes(x, y, label = city))


  # Same graph interactive Plotly
  story_of_two_cities_july_plotly <- ggplotly(story_of_two_cities_july_plot) |> 
    add_annotations(
      x = labels_dat$x,
      y = labels_dat$y,
      text = labels_dat$city,
      xref = "x",
      yref = "y",
      showarrow = TRUE,
      arrowhead = 1,
      arrowsize = 0.5,
      arrowside = "none",
      ax = 20,
      ay = -40,
      bgcolor="white",
      opacity=0.8
    )

  htmlwidgets::saveWidget(
    story_of_two_cities_july_plotly, 
    here(graph_path_plotly)
  )

  story_of_two_cities_july_plotly
}

