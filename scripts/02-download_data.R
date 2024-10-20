#### Preamble ####
# Purpose: Downloads the data from the FiveThirtyEight website and saves it
# Author: Sameeck Bhatia
# Date: 20 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - The `tidyverse` package must be installed and loaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)


#### Download data ####
raw_data <- read_csv("https://projects.fivethirtyeight.com/polls/data/president_polls.csv")


#### Save data ####
write_csv(raw_data, "data/raw_data/raw_data.csv") 
