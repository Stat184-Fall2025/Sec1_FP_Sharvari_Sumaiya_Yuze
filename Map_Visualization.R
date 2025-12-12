library(tidyverse)
library(maps)

#Filter by County
county_summary <- MissingPersons %>%
  filter(State %in% c("PA", "OH")) %>%   
  group_by(State, County) %>%
  summarise(
    NumberMissing = n(),                 
    .groups = "drop"
  )

View(county_summary)

#Extract states and counties data
states   <- map_data("state")
counties <- map_data("county")

ohpa_states   <- states   %>% filter(region %in% c("pennsylvania", "ohio"))
ohpa_counties <- counties %>% filter(region %in% c("pennsylvania", "ohio"))

#Attach every point of polygon to missing persons numbers by county
county_summary_for_join <- county_summary %>%
  mutate(
    region    = recode(State,
                       "PA" = "pennsylvania",
                       "OH" = "ohio"),
    subregion = tolower(County)
  )

#Redefine data by region (state) and subregion (county) -> for working with map package
ohpa_map_df <- ohpa_counties %>%
  left_join(county_summary_for_join,
            by = c("region", "subregion"))

#Plot missing persons data by county 
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


#BarChart for State vs State Comparison 

library(tidyverse)

state_summary <- MissingPersons %>% 
  filter(State %in% c("PA", "OH")) %>% 
  count(State, name = "NumberMissing")

ggplot(state_summary, aes(x=State, y=NumberMissing, fill=State)) +
  geom_col(width=0.6)+
  theme_minimal()+
  labs(
    title = "Total Number of Missing Persons by State",
    subtitle = "Pennsylvania vs Ohio",
    x = "State",
    y = "Number of Missing Persons"
  )+
  guides(fill="none")


#Dotplot for Counties Comparison 

state_summary <- MissingPersons %>% 
  filter(State %in% c("PA", "OH")) %>% 
  count(State, County, name = "NumberMissing")

ggplot(county_summary,
       aes(x=reorder(County, NumberMissing,),
           y = NumberMissing,
           color = State))+
  geom_point(size=4, alpha=0.8)+
  coord_flip()+
  theme_minimal()+
  labs(
    title="Missing Persons Cases by County",
    subtitle="Pennsylvania vs Ohio",
    x = "County",
    y = "Number of Missing Persons"
  )
