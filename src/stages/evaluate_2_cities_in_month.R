evaluate_2_cities_in_month <- function() {
  # Configuration
  config <- yaml::read_yaml(here::here("params.yaml"))

  # Load data
  climatologies_europe_eobs_1950_2022_dat_tbbl <- readr::read_csv(here::here(config$process$climatology_data))
  
  cities_in_study = config$evaluate_2_cities_in_month$the_2_cities
  month_in_study = config$evaluate_2_cities_in_month$month

  year_in_middle = climatologies_europe_eobs_1950_2022_dat_tbbl |>
    dplyr::select(year) |>
    dplyr::distinct() |>
    dplyr::arrange(year) |> 
    {\(dat) round(median(dat$year))}()

  # Summarize by month and prepare Name of columns (for tooltips)
  climatologies_monthly_ext_dat <- climatologies_europe_eobs_1950_2022_dat_tbbl |>
    dplyr::group_by(id, year, month) |>
    dplyr::summarise(temp_month_mean = mean(t2m_c)) |>
    dplyr::ungroup() |>
    dplyr::mutate(City = id, Year = year, "Temp Avgr." = temp_month_mean ) 

  labels_dat <- cities_in_study |> purrr::map(function(city_name) {
      climatologies_monthly_ext_dat |> 
      dplyr::filter(id == city_name, year == year_in_middle, month == month_in_study) |>
      dplyr::pull(temp_month_mean)
    }) |> 
    unlist() |>
    (\(y_values) {
      print(y_values)
     tibble::tibble( city = cities_in_study, x = year_in_middle, y = y_values)
  })()


  story_of_two_cities_july_base_plot <- climatologies_monthly_ext_dat |>
    dplyr::filter(id %in% cities_in_study, month == month_in_study) |>
    ggplot2::ggplot(ggplot2::aes(x = Year, y = `Temp Avgr.`, group = City)) + 
    ggplot2::theme(plot.title = ggplot2::element_text(size = 14)) +
    ggplot2::labs(
      x = "Year", 
      y = "Average temperature Cº", 
      title = "Average Temperature in July - Tale of two Cities? or the same story..",
      caption = "Data from: CDS - ERA5 monthly averaged data on single levels from 1959 to present[1959-2022]"
    )

  story_of_two_cities_july_plot = story_of_two_cities_july_base_plot +
    ggplot2::geom_point() +
    ggplot2::geom_line(stat = "identity") +
    ggplot2::geom_smooth(method = "lm", se = FALSE)   +
    ggplot2::geom_label(data = labels_dat, alpha = 0.75, inherit.aes = FALSE, ggplot2::aes(x, y, label = city))

  # Save to svg
  # Create dir if it does not exist
  dir.create(here::here(dirname(config$evaluate_2_cities_in_month$out$graph_file_svg)), showWarnings = FALSE, recursive = TRUE)
  
  svglite::svglite(here::here(config$evaluate_2_cities_in_month$out$graph_file_svg))
  plot(story_of_two_cities_july_plot)
  invisible(
        dev.off()
  )

  # Same graph interactive Plotly
  story_of_two_cities_july_plotly <- plotly::ggplotly(story_of_two_cities_july_plot) |> 
    plotly::add_annotations(
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

  # Save plotly graph
  # Create dir if it does not exist
  dir.create(here::here(config$evaluate_2_cities_in_month$out$graph_dir_plotly), showWarnings = FALSE, recursive = TRUE)
  
  htmlwidgets::saveWidget(
    story_of_two_cities_july_plotly, 
    here::here(paste0(config$evaluate_2_cities_in_month$out$graph_dir_plotly, "/index.html")),
    selfcontained = FALSE
  )

  saveRDS(story_of_two_cities_july_plotly, here::here(config$evaluate_2_cities_in_month$out$graph_r_obj_plotly))
}

evaluate_2_cities_in_month()


