#### Preamble ####
# Purpose: Cleans raw polling data to prepare for testing and analysis.
# Author: Sameeck Bhatia
# Date: 20 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - The `tidyverse` package must be installed and loaded
#   - The `arrow` package must be installed and loaded
#   - gather.R must have been run
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_data.csv")

analysis_data <- raw_data |>
  mutate(start_date = mdy(start_date),
         end_date = mdy(end_date),
         election_date = mdy(election_date)) |>
  filter(start_date >= as.Date("2024-07-21")) |>
  select(poll_id, pollster, numeric_grade, state,start_date, 
        end_date, sample_size, population, election_date, party, 
        answer, candidate_name, pct) |>
  drop_na()

#### Save data as parquet file ####
write_parquet(x = analysis_data, sink = "data/analysis_data/analysis_data.parquet")
