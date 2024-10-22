#### Preamble ####
# Purpose: Models popular vote for Trump from election data.
# Author: Sameeck Bhatia
# Date: 21 October, 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - The `tidyverse` package must be installed and loaded
#   - The `rstanarm` package must be installed and loaded
#   - cleaning.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####
priors <- normal(50, 2)

election_model <- stan_glm(
  formula = pct ~ pollster + numeric_grade + pollscore + sample_size + population,
  data = analysis_data,
  family = gaussian(),
  prior = priors,
  prior_intercept = priors,
  cores = 4,
  iter = 2000,
  adapt_delta = 0.95,
  seed = 12
)


#### Save model ####
saveRDS(
  election_model,
  file = "models/election_model.rds"
)
