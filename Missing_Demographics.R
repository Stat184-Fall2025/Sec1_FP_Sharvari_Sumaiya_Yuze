library(tidyverse)

MissingPersons <- read_csv("MissingPersons.csv")

eda_df <- MissingPersons |>
  # keep only PA + OH
  filter(State %in% c("PA", "OH")) |>
  # create numeric age + age groups
  mutate(
    age_num = readr::parse_number(`Missing Age`),
    age_num = if_else(is.na(age_num), 0, age_num),
    age_group = case_when(
      age_num < 20 ~ "below 20",
      age_num < 40 ~ "between 20-40",
      age_num < 60 ~ "between 40-60",
      TRUE         ~ "above 60"
    )
  )


### age distribution by state (PA vs OH)
age_state <- eda_df |>
  count(State, age_group, name = "Number of Missing People")

ggplot(
  data = age_state,
  aes(x = age_group,
      y = `Number of Missing People`,
      fill = State)
) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Age Distribution of Missing People (PA vs OH)",
    x = "Age Group",
    y = "Number of Missing People"
  )


### sex distribution by state 
sex_state <- eda_df |>
  count(State, `Biological Sex`, name = "Number of Missing People")

ggplot(
  data = sex_state,
  aes(x = `Biological Sex`,
      y = `Number of Missing People`,
      fill = State)
) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Biological Sex Distribution (PA vs OH)",
    x = "Biological Sex",
    y = "Number of Missing People"
  )


### race distribution by state - lolipop plot
library(ggplot2)

ggplot(race_state,
       aes(x = reorder(`Race / Ethnicity`, `Number of Missing People`),
           y = `Number of Missing People`,
           color = State)) +
  geom_segment(aes(xend = `Race / Ethnicity`,
                   y = 0,
                   yend = `Number of Missing People`),
               linewidth = 0.8) +
  geom_point(size = 3) +
  coord_flip() +
  labs(
    title = "Race / Ethnicity Distribution (PA vs OH)",
    x = "Race / Ethnicity",
    y = "Number of Missing People"
  )






