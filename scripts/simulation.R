#### Preamble ####
# Purpose: Simulates a mock dataset of polls in each state.
# Author: Sameeck Bhatia, Sean Chua, Tanmay Shinde
# Date: 30 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
set.seed(12)


#### Simulate data ####
pollsters <- c("Emerson", "Morning Consult", "Siena/NYT", "YouGov")
states <- c("AZ", "FL", "GA", "NY", "WA")
populations <- c("likely", "registered")
dates <- seq(from = as.Date("2024-07-21"), to = as.Date("2024-10-30"), by = 1)

n <- 50

simulated_data1 <- data.frame(
  "poll_id" = sample(10000:49999, n, replace = FALSE),
  "pollster" = sample(pollsters, n, replace = TRUE, prob = c(124, 272, 180, 30)),
  "state" = sample(states, n, replace = TRUE, prob = c(2, 6, 3, 6, 2)),
  "sample_size" = rpois(n, 800),
  "population" = sample(populations, n, replace = TRUE, prob = c(66, 34)),
  "end_date" = sample(dates, n, replace = TRUE),
  "candidate" = "Trump"
  ) |>
  mutate(percent = case_when(state == "AZ" ~ round(rnorm(n, 49, 2), 2),
                             state == "FL" ~ round(rnorm(n, 50, 2), 2),
                             state == "GA" ~ round(rnorm(n, 50, 2), 2),
                             state == "NY" ~ round(rnorm(n, 39, 2), 2),
                             state == "WA" ~ round(rnorm(n, 41, 2), 2)))

simulated_data2 <- data.frame(
  "poll_id" = sample(50000:99999, n, replace = FALSE),
  "pollster" = sample(pollsters, n, replace = TRUE, prob = c(124, 272, 180, 30)),
  "state" = sample(states, n, replace = TRUE, prob = c(2, 6, 3, 6, 2)),
  "sample_size" = rpois(n, 800),
  "population" = sample(populations, n, replace = TRUE, prob = c(66, 34)),
  "end_date" = sample(dates, n, replace = TRUE),
  "candidate" = "Harris"
) |>
  mutate(percent = case_when(state == "AZ" ~ round(rnorm(n, 51, 2), 2),
                             state == "FL" ~ round(rnorm(n, 50, 2), 2),
                             state == "GA" ~ round(rnorm(n, 50, 2), 2),
                             state == "NY" ~ round(rnorm(n, 61, 2), 2),
                             state == "WA" ~ round(rnorm(n, 59, 2), 2)))

simulated_data <- rbind(simulated_data1, simulated_data2)

#### Save data ####
write_csv(simulated_data, "data/simulated_data/simulated_data.csv")
