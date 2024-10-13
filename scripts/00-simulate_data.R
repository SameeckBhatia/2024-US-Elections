#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(12)


#### Simulate data ####
states <- c("AL", "AK", "AR", "AZ", "CA", "CO", "CT")
races <- c("w", "b", "h", "a", "n", "o")
parties <- c("d", "r", "i")
voter_types <- c("registered", "likely")

simulated_data <- data.frame(
  "id" = sample(10000:99999, 10000, replace = FALSE),
  "state" = sample(states, 10000, replace = TRUE),
  "race" = sample(races, 10000, replace = TRUE, prob = c(60, 13, 19, 6, 1, 1)),
  "party" = sample(parties, 10000, replace = TRUE, prob = c(51, 47, 2)),
  "last_election" = sample(parties, 10000, replace = TRUE, prob = c(48, 46, 6)),
  "voter_type" = sample(voter_types, 10000, replace = TRUE, prob = c(66, 34))
)


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
