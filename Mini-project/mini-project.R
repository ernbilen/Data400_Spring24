# Mini-project: number of trips and political events
# Author: Han Nguyen 
# Version: 1.0.0 
# Date created: 2/5/2024
# Date last modified: 2/5/2024

# Set working directory ----
setwd("C:/Users/Student/OneDrive - Dickinson College/Documents/Dickinson/Spring 2024/DATA 400/Data400_Spring24/Mini-project")
# setwd("~/Dickinson/Spring 2024/DATA 400/Data400_Spring24/Mini-project")
# Install packages ----
#install.packages("tidyr")
#install.packages("lubridate")
#install.packages("usmap")
library(usmap)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(geofacet)
library(viridis)
library(hrbrthemes)

# Import states data
states <- data.frame(state.abb, state.name)

states[nrow(states) + 1,] = c("DC","District of Columbia")

## Import number of trips data ----
#state_trips <- read.csv("number_of_trips.csv")

# state_trips_2 <- state_trips %>% filter(Level == "State") %>% select(-c(Level, County.FIPS, County.Name, Row.ID)) %>%
#   rename(Fips = State.FIPS, State = State.Postal.Code, Stay_home = Population.Staying.at.Home,
#          Not_stay_home = Population.Not.Staying.at.Home, Trips = Number.of.Trips,
#          Trips_under1 = Number.of.Trips..1, Trips_1to3 = Number.of.Trips.1.3,
#          Trips_3to5 = Number.of.Trips.3.5, Trips_5to10 = Number.of.Trips.5.10,
#          Trips_10to25 = Number.of.Trips.10.25, Trips_25to50 = Number.of.Trips.25.50,
#          Trips_50to100 = Number.of.Trips.50.100, Trips_100to250 = Number.of.Trips.100.250,
#          Trips_250to500 = Number.of.Trips.250.500, Trips_above500 = Number.of.Trips...500) %>%
#   mutate(Date = ymd(Date))

# # Check missing values
# state_trips_2[is.na(state_trips_2),]
# 
# # Summarize data
# summary(state_trips_2)
# 
# # Filter data from Jan 2020 to Feb 2024
# state_trips_2 <- state_trips_2 %>% filter(Date >= "2020-01-01")
# 
# summary(state_trips_2)
# 
# write.csv(state_trips_2, "State-level trips made.csv", row.names=FALSE)

state_trips_3 <- read.csv("State-level trips made.csv")

state_trips_3 <- inner_join(state_trips_3, states, by = c("State" = "state.abb"))

state_trips_4 <- state_trips_3 %>% rename(Abb = State, State = state.name) %>% mutate(Date = ymd(Date))

summary(state_trips_4)

# Columns to be converted to million units
columns_to_convert <- c("Stay_home", "Not_stay_home", "Trips", "Trips_under1", "Trips_1to3", 
                        "Trips_3to5", "Trips_5to10", "Trips_10to25", "Trips_25to50", 
                        "Trips_50to100", "Trips_100to250", "Trips_250to500", "Trips_above500")

# Convert columns to thousands units
state_trips_5 <- mutate_at(state_trips_4, vars(columns_to_convert), .funs = list(~ ./1000))

summary(state_trips_5)

# Define the order of metrics based on the order of the columns
metric_order <- colnames(state_trips_5)[grep("^Trips_", colnames(state_trips_5))]

# Reshape the data into long format
state_trips_long <- state_trips_5 %>% 
  gather(key = "Metric", value = "Trips", starts_with("Trips_")) %>%
  mutate(Metric = factor(Metric, levels = metric_order))

# Create a boxplot with facets for each metric
short_trips <- state_trips_long %>% filter(!(Metric %in% c("Trips_50to100", "Trips_100to250", "Trips_250to500", "Trips_above500")))
long_trips <- state_trips_long %>% filter(Metric %in% c("Trips_50to100", "Trips_100to250", "Trips_250to500", "Trips_above500"))

ggplot(short_trips, aes(x = Metric, y = Trips)) +
  geom_boxplot(aes(fill = Metric, alpha = 0.3)) +
  labs(x = "Metric", y = "Number of Trips (thousands)", title = "Boxplot of Trips by Distance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none")

ggplot(long_trips, aes(x = Metric, y = Trips)) +
  geom_boxplot(aes(fill = Metric, alpha = 0.3)) +
  labs(x = "Metric", y = "Number of Trips (thousands)", title = "Boxplot of Trips by Distance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position="none")

# Create a violin plots for each state for each metric
ggplot(state_trips_5, aes(x = State, y = Trips_under1)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips under 1 miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_1to3)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 1-3 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_3to5)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 3-5 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_5to10)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 5-10 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_10to25)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 10-25 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_25to50)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 25-50 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_50to100)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 50-100 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_100to250)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 100-250 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_250to500)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips 250-500 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

ggplot(state_trips_5, aes(x = State, y = Trips_above500)) +
  geom_violin(trim = TRUE, scale = "width", aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips above 500 Miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

# Create a line plot for each state for each metric
aggregated_trips <- state_trips_5 %>% group_by(Date) %>% summarise(Trips = sum(Trips), Trips_under1 = sum(Trips_under1),
                                                                   Trips_100to250 = sum(Trips_100to250), 
                                                                   Trips_250to500 = sum(Trips_250to500), Trips_above500 = sum(Trips_above500))


aggregated_trips <- mutate_at(aggregated_trips, vars(Trips, Trips_under1, Trips_100to250, Trips_250to500, Trips_above500), .funs = list(~ ./1000))

ggplot(aggregated_trips, aes(x = Date, y = Trips)) +
  geom_line() +
  labs(x = "Date", y = "Total Number of Trips (millions)", title = "Number of Trips Over Time") +
  theme_minimal()

ggplot(aggregated_trips, aes(x = Date, y = Trips_under1)) +
  geom_line() +
  labs(x = "Date", y = "Total Number of Trips (millions)", title = "Number of Trips under 1 Miles Over Time") +
  theme_minimal()

ggplot(aggregated_trips, aes(x = Date, y = Trips_100to250)) +
  geom_line() +
  labs(x = "Date", y = "Total Number of Trips (millions)", title = "Number of Trips from 100 to 250 Miles Over Time") +
  theme_minimal()

ggplot(aggregated_trips, aes(x = Date, y = Trips_250to500)) +
  geom_line() +
  labs(x = "Date", y = "Total Number of Trips (millions)", title = "Number of Trips from 250 to 500 Miles Over Time") +
  theme_minimal()

ggplot(aggregated_trips, aes(x = Date, y = Trips_above500)) +
  geom_line() +
  labs(x = "Date", y = "Total Number of Trips (millions)", title = "Number of Trips above 500 Miles Over Time") +
  theme_minimal()

# Import political events data ----
events <- read.csv("events.csv")

events_2 <- events %>% select(-c(event_id_cnty, region, country, admin3)) %>% 
  rename(date = event_date, state = admin1, city = admin2) %>%
  mutate(date = dmy(date), inter1 = as.factor(inter1), inter2 = as.factor(inter2), interaction = as.factor(interaction),
         civilian_targeting = as.factor(ifelse(civilian_targeting == 'Civilian targeting', 1, 0)))

summary(events_2)

events_3 <- inner_join(events_2, states, by = c("state" = "state.name"))

events_4 <- events_3 %>% rename(Abb = state.abb, State = state) %>%
  mutate(has_event = 1)

## Analyze events data
aggregated_events <- events_4 %>% mutate(year = year(date)) %>% 
  group_by(year, event_type) %>%
  summarise(count = n())

ggplot(aggregated_events) +
  geom_line(mapping = aes(x = year, y = count, color = event_type), linewidth = 1) +
  geom_point(mapping = aes(x = year, y = count, color = event_type)) +
  labs(x = "Year", y = "Count of events", title = "Number of events over time by event type") +
  theme_minimal()

aggregated_events %>% filter(event_type != "Protests") %>%
  ggplot() +
  geom_line(mapping = aes(x = year, y = count, color = event_type), linewidth = 1) +
  geom_point(mapping = aes(x = year, y = count, color = event_type)) +
  labs(x = "Year", y = "Count of events", title = "Number of events over time by event type") +
  theme_minimal()

aggregated_state_events <- events_4 %>% mutate(year = year(date)) %>% 
  group_by(year, State) %>% summarise(count = n())

ggplot(aggregated_state_events, aes(x = year, y = count)) +
  geom_bar(aes(fill = State)) +
  geom_boxplot(width = 0.2, fill = "#FF6666", outlier.shape = NA) +
  labs(x = "State", y = "Number of Trips (thousands)", title = "Distribution of Trips under 1 miles by State") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position= "none")

aggregated_state_events <- aggregated_state_events %>% rename(state = State)

plot_usmap(data = aggregated_state_events[aggregated_state_events$year == 2020,], values = "count", labels = TRUE) +
  scale_fill_gradient(low="white", high="red", name = NULL) + 
  ggtitle("Statewise number of events (US, 2020)") 

plot_usmap(data = aggregated_state_events[aggregated_state_events$year == 2021,], values = "count", labels = TRUE) +
  scale_fill_gradient(low="white", high="red", name = NULL) + 
  ggtitle("Statewise number of events (US, 2021)") 

plot_usmap(data = aggregated_state_events[aggregated_state_events$year == 2022,], values = "count", labels = TRUE) +
  scale_fill_gradient(low="white", high="red", name = NULL) + 
  ggtitle("Statewise number of events (US, 2022)") 

plot_usmap(data = aggregated_state_events[aggregated_state_events$year == 2023,], values = "count", labels = TRUE) +
  scale_fill_gradient(low="white", high="red", name = NULL) + 
  ggtitle("Statewise number of events (US, 2023)") 

plot_usmap(data = aggregated_state_events[aggregated_state_events$year == 2024,], values = "count", labels = TRUE) +
  scale_fill_gradient(low="white", high="red", name = NULL) + 
  ggtitle("Statewise number of events (US, 2024)") 

## Merge two datasets ----
#write.csv(events_4, "Political Violence Events.csv", row.names=FALSE)
#write.csv(state_trips_5, "State Trips.csv", row.names=FALSE)

master <- read.csv("master.csv")

master <- master %>% mutate(date = ymd(date)) 

master_2 <- master %>% filter(date <= mdy("05/11/2023"))

master_2 <- master_2 %>% 
  mutate_at(c('tot_cases','new_cases', 'tot_deaths', 'new_deaths', 'new_historic_cases', 'new_historic_deaths'), ~replace_na(.,0)) %>%
  mutate(inter1 = as.factor(inter1), inter2 = as.factor(inter2), interaction = as.factor(interaction),
                   civilian_targeting = as.factor(civilian_targeting), has_event = as.factor(has_event))

