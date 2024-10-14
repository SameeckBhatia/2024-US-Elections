#### Preamble ####
# Purpose: Simulates a mock dataset of surveyed individuals.
# Author: Sameeck Bhatia
# Date: 14 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
set.seed(12)


#### Simulate data ####
states <- c("AL", "AK", "AR", "AZ", "CA")
num_districts <- setNames(c(7, 1, 9, 4, 52), states)
races <- c("w", "b", "h", "a", "n", "o")
parties <- c("d", "r", "i")
voter_types <- c("registered", "likely")

n <- 1000

simulated_data <- data.frame(
  "id" = sample(10000:99999, n, replace = FALSE),
  "state" = sample(states, n, replace = TRUE),
  "race" = sample(races, n, replace = TRUE, prob = c(60, 13, 19, 6, 1, 1)),
  "party" = sample(parties, n, replace = TRUE, prob = c(51, 47, 2)),
  "last_election" = sample(parties, n, replace = TRUE, prob = c(48, 46, 6)),
  "voter_type" = sample(voter_types, n, replace = TRUE, prob = c(66, 34))
)

simulated_data$district <- mapply(function(state) sample(1:num_districts[state], 1), 
                                  simulated_data$state)

#### Save data ####
write_csv(simulated_data, "data/simulated_data/simulated_data.csv")
