#### Preamble ####
# Purpose: Cleans raw polling data to prepare for testing and analysis.
# Author: Sameeck Bhatia
# Date: 20 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - The `tidyverse` package must be installed and loaded
#   - gather.R must have been run
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_data.csv")

analysis_data <- raw_data |>
                 mutate(start_date = mdy(start_date)) |>
                 filter(candidate_name == "Donald Trump", 
                        numeric_grade >= 2.8, 
                        pollscore < 0, 
                        start_date >= as.Date("2024-07-21"),
                        pollster %in% c("Emerson", "Siena/NYT", "YouGov")) |>
                 select(poll_id, pollster, numeric_grade, pollscore, methodology,
                        state, start_date, end_date, sample_size, population, 
                        election_date, party, answer, candidate_name, pct) 

#### Save data ####
write_csv(analysis_data, "data/analysis_data/analysis_data.csv")
