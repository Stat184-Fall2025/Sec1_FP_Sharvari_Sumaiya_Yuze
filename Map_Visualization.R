library(tidyverse)
library(maps)

county_summary <- MissingPersons %>%
  filter(State %in% c("PA", "OH")) %>%   
  group_by(State, County) %>%
  summarise(
    NumberMissing = n(),                 
    .groups = "drop"
  )

states   <- map_data("state")
counties <- map_data("county")

ohpa_states   <- states   %>% filter(region %in% c("pennsylvania", "ohio"))
ohpa_counties <- counties %>% filter(region %in% c("pennsylvania", "ohio"))

county_summary_for_join <- county_summary %>%
  mutate(
    region    = recode(State,
                       "PA" = "pennsylvania",
                       "OH" = "ohio"),
    subregion = tolower(County)
  )

ohpa_map_df <- ohpa_counties %>%
  left_join(county_summary_for_join,
            by = c("region", "subregion"))

ditch_the_axes <- theme(
  axis.text  = element_blank(),
  axis.line  = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid   = element_blank(),
  axis.title   = element_blank()
)

ohpa_base <- ggplot(ohpa_states,
                    aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray80")

elbow_room <- ohpa_base +
  geom_polygon(
    data  = ohpa_map_df,
    aes(fill = NumberMissing),          
    color = "white"
  ) +
  geom_polygon(color = "black", fill = NA) +
  theme_bw() +
  ditch_the_axes

elbow_room +
  scale_fill_gradient(
    trans = "log10",
    low = "lightblue",
    high = "darkblue",
    na.value = "grey90"
  ) +
  labs(
    title = "Number of Missing Persons per County\nPennsylvania & Ohio",
    fill  = "Missing\npeople"
  )