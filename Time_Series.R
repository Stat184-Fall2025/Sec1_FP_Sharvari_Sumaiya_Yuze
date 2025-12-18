# Data wrangling ----
## Creating a time sensitive data frame via dates
time_sensitive_missing <- missingPersons |>
  mutate(date = as.Date(DLC, format = "%m/%d/%y")) |>
## Summarize the data frame where each case is a year and an attribute is missing count
### cut() rounds every date down to year-01-01; all dates in a year will have that label
  mutate(year = as.Date(cut(date, breaks = "year"))) |>
  group_by(year, State) |>
  summarize(missing_count = n(),
            .groups = "drop")
## Make sure there's no data from the future
  time_sensitive_missing$year <- futureDeleter(time_sensitive_missing$year)

## Pythonian caveman function that solves problems with as.Date()
### Function takes parameter dates (column of a data frame)
futureDeleter <- function(dates) {
  strings = as.character(dates)
  for (i in seq_along(strings)) {
    d = strings[i]
    if (substr(d, 1, 2) == "20" && as.numeric(substr(d, 3, 4)) > 25) {
      new_str = paste0("19", substr(d, 3, 10))
      strings[i] = new_str
    }
  }
  return(as.Date(strings))
}

# Time Series for PA ----
## Create PA only time series df
time_sensitive_missing |>
  filter( State == "PA") |>
    ggplot(
      mapping = aes(
        x = year,
        y = missing_count
      )
    ) +
    geom_line() +
    labs(
      title = "Missing People Per Year In PA",
      x = "Years (1928-2025)", 
      y = "Number of Missing People Cases"
    )

# Time Series for OH ----
## Create OH only time series df
time_sensitive_missing |>
  filter(State == "OH") |>
    ggplot(
      mapping = aes(
        x = year,
        y = missing_count
      )
    ) +
    geom_line() +
    labs(
      title = "Missing People Per Year In OH",
      x = "Years (1928-2025)",
      y = "Number of Missing People Cases"
    )

# Time Series for both ----
ggplot() +
  geom_line(
    data = time_sensitive_missing,
    mapping = aes(
      x = year,
      y = missing_count,
      color = State,
      linetype = State
    )
  ) +
  scale_color_discrete(palette = c("steelblue", "darkred")) +
  labs(
    title = "Missing People Per Year In PA and OH",
    x = "Years (1938-2025)",
    y = "Number of Missing People Cases"
  )

# Create df with difference in missing persons (PA - OH)----
difference_time_series <- time_sensitive_missing |>
  pivot_wider(names_from = State, values_from = missing_count) |>
## Change all NA Values to 0
  mutate(PA = replace_na(PA, 0)) |>
  mutate(OH = replace_na(OH, 0)) |> 
  mutate(difference = PA - OH)

# Time Series for difference (PA - OH) ----
ggplot(
  data = difference_time_series,
  mapping = aes(
    x = year,
    y = difference
  )
) +
  geom_point() +
  geom_line(linetype = "dotted") +
  geom_hline(yintercept = 0, color = "darkred", linetype = "longdash") +
  labs(
    title = "Missing Cases Difference (PA - OH)",
    x = "Years (1928-2025)",
    y = "Difference (PA - OH)"
  )
