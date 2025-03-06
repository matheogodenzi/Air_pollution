
## -----------------------------------------------------------------------------
## load libraries
library(tidyverse)
library(readxl)

## -----------------------------------------------------------------------------
## user-defined functions
read_met <- function(path, sheet) {
  headr <- suppressMessages(read_xlsx(path, sheet = sheet, n_max = 1, col_names = FALSE))
  read_xlsx(path, sheet = sheet, skip = 6, col_names = replace(unlist(headr, use.names = FALSE), 1, "datetime"))
}

get_met <- function(path, sites) {
  spd <- read_met(path, "Wind speed")
  dir <- read_met(path, "Wind direction")
  
  full_join(
    pivot_longer(spd, -datetime, names_to = "site", values_to = "WIGE"),
    pivot_longer(dir, -datetime, names_to = "site", values_to = "WIRI"),
    by = c("datetime", "site")
  ) %>%
    filter(site %in% !!sites) %>%
    arrange(site, datetime)
}

## -----------------------------------------------------------------------------
## apply functions to get met dataframe
met <- get_met("data/2024/Data_wind_2024_direction_speed.xlsx",
               sites = c("LAU", "ZUE"))

## inspect
head(met)
