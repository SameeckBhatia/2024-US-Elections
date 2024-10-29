#### Preamble ####
# Purpose: Models popular vote for Trump from election data.
# Author: Sameeck Bhatia
# Date: 21 October, 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
#   - The `tidyverse` package must be installed and loaded
#   - The `rstanarm` package must be installed and loaded
#   - The `arrow` package must be installed and loaded
#   - cleaning.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(caret)

analysis_data <- read_parquet("analysis_data.parquet")

model_data <- analysis_data |> 
  select(pollster, numeric_grade, state, sample_size, pct, candidate_trump) |>
  mutate(pollster = as.factor(pollster),
         state = as.factor(state),
         weight = numeric_grade * (sample_size / min(sample_size)))

set.seed(12)
training_index <- createDataPartition(model_data$candidate_trump, p = 0.7, list = FALSE)

training_data <- model_data[training_index,]
testing_data <- model_data[-training_index,]

priors <- normal(0.5, 2.5, autoscale = TRUE)
formula <- candidate_trump ~ (1 | pollster) + (1 | state) + sample_size + pct

model <- stan_glmer(
  formula = formula,
  data = training_data,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  weights = weight,
  cores = 4,
  iter = 2000,
  adapt_delta = 0.95,
)

pp_check(model)

testing_data |> 
  mutate(predicted_prob = 
           posterior_predict(model, newdata = testing_data, draws = 1) %>% rowMeans()) |>
  select(pollster, state, pct, candidate_trump, predicted_prob)

#### Save model ####
saveRDS(
  election_model,
  file = "models/election_model.rds"
)
