#library(tidyverse)
MissingPersons <- read_csv("MissingPersons.csv")

#Simple summary tables 

# 1) Sort by sex
gender_table <- MissingPersons %>%
  count(`Biological Sex`, name = "Number of Missing People")

View(gender_table)


# 2) Sort by race/ethnicity
race_table <- MissingPersons %>%
  count(`Race / Ethnicity`, name = "Number of Missing People")

View(race_table)


# 3) Sort by age group
age_table <- MissingPersons %>%
  mutate(
    age_num = parse_number(`Missing Age`),
    age_num = if_else(is.na(age_num), 0, age_num),
    age_group = case_when(
      age_num < 20 ~ "below 20",
      age_num < 40 ~ "between 20-40",
      age_num < 60 ~ "between 40-60",
      TRUE         ~ "above 60"
    )
  ) %>%
  count(age_group, name = "Number of Missing People")

View(age_table)


# 4) Sort by location 
location_table <- MissingPersons %>%
  count(State, County, City, name = "Number of Missing People") %>%
  arrange(State, County, City)

View(location_table)


# 5) Sort by date of last contact
date_table <- MissingPersons %>%
  count(DLC, name = "Number of Missing People") %>%
  arrange(DLC)

View(date_table)


#-----------------------------------------------------------------------------------------------------


# Complex summary tables 

# 1) Sort by gender, race/ethnicity and age group
missing_table_1 <- MissingPersons %>%
  mutate(
    age_num = readr::parse_number(`Missing Age`),
    age_num = if_else(is.na(age_num), 0, age_num),
    age_group = case_when(
      age_num < 20 ~ "below 20",
      age_num < 40 ~ "between 20-40",
      age_num < 60 ~ "between 40-60",
      TRUE         ~ "above 60"
    )
  ) %>%
  count(
    `Race / Ethnicity`, 
    `Biological Sex`, 
    age_group, 
    name = "Number of Missing People") %>%
  complete(
    `Race / Ethnicity`,
    `Biological Sex`,
    age_group,
    fill = list("Number of Missing People" = 0)
  )

View(missing_table_1)




# 2) Sort by gender, race/ethnicity and age group by location, drop missing counts
missing_table_2 <- MissingPersons %>%
  mutate(
    age_num = parse_number(`Missing Age`),
    age_num = if_else(is.na(age_num), 0, age_num),
    age_group = case_when(
      age_num < 20 ~ "below 20",
      age_num < 40 ~ "between 20-40",
      age_num < 60 ~ "between 40-60",
      TRUE         ~ "above 60"
    )
  ) %>%
  count(
    State,
    County,
    City,
    `Race / Ethnicity`,
    `Biological Sex`,
    age_group,
    name = "Number of Missing People"
  ) %>%
  complete(
    State,
    County,
    City,
    `Race / Ethnicity`,
    `Biological Sex`,
    age_group,
    fill = list(`Number of Missing People` = 0)
  ) %>%
  filter(`Number of Missing People` > 0) %>%   # NOTE: column name, not string
  arrange(State, County, City)

View(missing_table_2)




# 3) Sort by gender, race/ethnicity and age group by date of last contact, drop missing counts
missing_table_3 <- MissingPersons %>%
  mutate(
    age_num = parse_number(`Missing Age`),
    age_num = if_else(is.na(age_num), 0, age_num),
    age_group = case_when(
      age_num < 20 ~ "below 20",
      age_num < 40 ~ "between 20-40",
      age_num < 60 ~ "between 40-60",
      TRUE         ~ "above 60"
    )
  ) %>%
  count(
    DLC,
    `Race / Ethnicity`,
    `Biological Sex`,
    age_group,
    name = "Number of Missing People"
  ) %>%
  complete(
    DLC,
    `Race / Ethnicity`,
    `Biological Sex`,
    age_group,
    fill = list(`Number of Missing People` = 0)
  ) %>%
  arrange(DLC, 
          `Race / Ethnicity`,
          `Biological Sex`,
          age_group
  ) %>%
  filter(`Number of Missing People` > 0)

View(missing_table_3)
