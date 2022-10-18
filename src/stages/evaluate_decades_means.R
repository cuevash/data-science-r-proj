  evaluate_decades_means <- function() {
  
  # Configuration
  config <- yaml::read_yaml(here::here("params.yaml"))

  # Load data
  climatologies_europe_eobs_1950_2022_dat_tbbl <- readr::read_csv(here::here(config$process$climatology_data))

  month_in_study = config$evaluate_decades_means$month

  # Summarize by month and prepare Name of columns (for tooltips) 1950 - 1959
  climatologies_mean_monthly_decade_1950_11959 <- climatologies_europe_eobs_1950_2022_dat_tbbl |>
    dplyr::filter(year >= 1950 & year <= 1959) |>
    dplyr::group_by(id, month) |>
    dplyr::summarise(temp_mean_by_month_1950_1959 = mean(t2m_c)) |>
    dplyr::ungroup() # |>
    # mutate(City = city, Year = year, "Temp Avgr." = temp_month_mean )

  climatologies_mean_monthly_decade_2013_2022 <- climatologies_europe_eobs_1950_2022_dat_tbbl |>
    dplyr::filter(year >= 2013 & year <= 2022) |>
    dplyr::group_by(id, month) |>
    dplyr::summarise(temp_mean_by_month_2013_2022 = mean(t2m_c)) |>
    dplyr::ungroup() # |>

  ## Add differences by month
  climatologies_mean_diffs_between_decades_top_10 <-
    dplyr::left_join(
      climatologies_mean_monthly_decade_1950_11959, 
      climatologies_mean_monthly_decade_2013_2022, 
      by = c("id", "month")
    ) |>
    dplyr::mutate(diffs_between_decades = temp_mean_by_month_2013_2022 - temp_mean_by_month_1950_1959) |>
    dplyr::filter(month == month_in_study) |>
    dplyr::slice_max(diffs_between_decades, n = 10) |>
    dplyr::arrange(diffs_between_decades)

  # Barplot
  plot <- climatologies_mean_diffs_between_decades_top_10 |>
    dplyr::mutate(name = forcats::fct_reorder(id, diffs_between_decades)) |>
    ggplot2::ggplot(ggplot2::aes(x=name, y=diffs_between_decades)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::coord_flip()


  # Save to svg
  # Create dir if it does not exist
  dir.create(here::here(dirname(config$evaluate_decades_means$out$graph_file_svg)), showWarnings = FALSE, recursive = TRUE)
  
  svglite::svglite(here::here(config$evaluate_decades_means$out$graph_file_svg))
  plot(plot)
  invisible(
        dev.off()
  )

  # dir.create(here::here(dirname(config$evaluate_decades_means$out$graph_dir_plotly)), showWarnings = FALSE, recursive = TRUE)

  # htmlwidgets::saveWidget(
  #   story_of_two_cities_july_plotly, 
  #   here::here(paste0(config$evaluate_decades_means$out$graph_dir_plotly, "/index.html")),
  #   selfcontained = FALSE
  # )

  # saveRDS(story_of_two_cities_july_plotly, here::here(config$evaluate_decades_means$out$graph_r_obj_plotly))  
  
}

evaluate_decades_means()