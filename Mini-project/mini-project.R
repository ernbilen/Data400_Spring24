# Mini-project: number of trips and political events
# Author: Han Nguyen 
# Version: 1.0.0 
# Date created: 2/5/2024
# Date last modified: 2/5/2024

# Set working directory ----
setwd("C:/Users/Student/OneDrive - Dickinson College/Documents/Dickinson/Spring 2024/DATA 400/Data400_Spring24/Mini-project")

# Install packages ----
install.packages("tidyr")
install.packages("lubridate")
library(dplyr)
library(tidyr)
library(lubridate)

# Import number of trips data ----
state_trips <- read.csv("number_of_trips_state_level.csv")

state_trips_2 <- state_trips %>% select(-c(Level, County.FIPS, County.Name, Row.ID)) %>%
  rename(Fips = State.FIPS, State = State.Postal.Code, Stay_home = Population.Staying.at.Home, 
         Not_stay_home = Population.Not.Staying.at.Home, Trips = Number.of.Trips, 
         Trips_under1 = Number.of.Trips..1, Trips_1to3 = Number.of.Trips.1.3, 
         Trips_3to5 = Number.of.Trips.3.5, Trips_5to10 = Number.of.Trips.5.10, 
         Trips_10to25 = Number.of.Trips.10.25, Trips_25to50 = Number.of.Trips.25.50, 
         Trips_50to100 = Number.of.Trips.50.100, Trips_100to250 = Number.of.Trips.100.250, 
         Trips_250to500 = Number.of.Trips.250.500, Trips_above500 = Number.of.Trips...500) %>%
  mutate(Date = mdy(Date))

# Summarize data
summary(state_trips_2)

# Check missing values
state_trips_2[is.na(state_trips_2),]

# Import political events data ----
events <- read.csv("events.csv")

events_2 <- events %>% select(-c(event_id_cnty, region, country, admin3)) %>% 
  rename(Date = event_date) %>%
  mutate(Date = dmy(Date), timestamp = stamp_time(timestamp))

# Import states data
states <- data.frame(state.abb, state.name)
