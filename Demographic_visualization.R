# library(tidyverse)
library(kableExtra)
library(janitor)

# Biological Sex Inference ----
## Biological Sex Frequency Bar Graph ----
ggplot(
  data = gender_table,
  mapping = aes(
    x = `Biological Sex`,
    y = `Number of Missing People`,
    fill = `Biological Sex`
  )
) +
  geom_bar(stat = "identity")

### Using missing_table_3 (demographic) to wrangle biological sex sensitive information
female_demographic <- missing_table_3 |>
  group_by(`Race / Ethnicity`, age_group) |>
  filter(`Biological Sex` == "Female") |>
  ### summarize the numbers with no replacement of missing values
  summarize(
    total_missing = sum(`Number of Missing People`, na.rm = FALSE),
    .groups = "drop"
  ) |>
  ### drop all data that are one
  filter(total_missing > 1)

### Same process for males
male_demographic <- missing_table_3 |>
  group_by(`Race / Ethnicity`, age_group) |>
  filter(`Biological Sex` == "Male") |>
  ### summarize the numbers with no replacement of missing values
  summarize(
    total_missing = sum(`Number of Missing People`, na.rm = FALSE),
    .groups = "drop"
  ) |>
  ### drop all data that are one
  filter(total_missing > 1)

## Visualization for demographic for sex ----
ggplot(
  data = female_demographic,
  mapping = aes(
    x = `Race / Ethnicity`,
    y = total_missing,
    fill = `Race / Ethnicity`
  )
) +
  geom_bar(stat = "identity") +
  theme(legend.position = "none")

## Biological sex focused demographic breakdown table ----
two_way_table_female <- missing_table_3 |>
  filter(`Biological Sex` == "Female") |>
  tabyl(`Race / Ethnicity`, age_group) |>
  adorn_totals(c("row", "col")) |>
  adorn_percentages("row") |>
  adorn_pct_formatting(digits = 1) |>
  adorn_ns(position = "front")

View(two_way_table_female)

### repeat the process for male
two_way_table_male <- missing_table_3 |>
  filter(`Biological Sex` == "Male") |>
  tabyl(`Race / Ethnicity`, age_group) |>
  adorn_totals(c("row", "col")) |>
  adorn_percentages("row") |>
  adorn_pct_formatting(digits = 1) |>
  adorn_ns(position = "front")

View(two_way_table_male)
