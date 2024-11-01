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
library(rsample)
library(MLmetrics)
library(modelsummary)

model_data <- read_parquet("data/analysis_data/analysis_data.parquet")

model_data <- model_data |>
  mutate(pollster = as.factor(pollster),
         state = as.factor(state),
         population = as.factor(population),
         candidate_trump = ifelse(answer == "Trump", 1, 0),
         candidate_harris = ifelse(answer == "Harris", 1, 0),
         swing_state = ifelse(state %in% c("Arizona", "Georgia", "Michigan",
                                           "Nevada", "North Carolina", "Pennsylvania",
                                           "Wisconsin"), 1, 0),
         weight = numeric_grade * (sample_size / min(sample_size)),
         days_to_election = as.numeric(election_date - end_date))

set.seed(12)

model_data$state_answer <- interaction(model_data$state, model_data$answer, drop = TRUE)

split <- initial_split(model_data, prop = 0.7, strata = state_answer)

training_data <- training(split)
testing_data <- testing(split)

testing_data <- testing_data |> 
  filter(pollster %in% unique(training_data$pollster)) |> 
  select(!state_answer)

write_parquet(training_data, sink = "data/analysis_data/training_data.parquet")
write_parquet(testing_data, sink = "data/analysis_data/testing_data.parquet")

priors <- normal(0.5, 0.25, autoscale = TRUE)

trump_model <- stan_glmer(
  formula = candidate_trump ~ (1 | pollster) + (1 | state) + pct,
  data = training_data,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  weights = weight,
  cores = 4,
  iter = 2000,
  adapt_delta = 0.95,
  seed = 12
)

harris_model <- stan_glmer(
  formula = candidate_harris ~ (1 | pollster) + (1 | state) + pct,
  data = training_data,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  weights = weight,
  cores = 4,
  iter = 2000,
  adapt_delta = 0.95,
  seed = 12
)

pp_check(trump_model)
pp_check(harris_model)

set.seed(12)

predicted_data_trump <- testing_data |>
  select(pollster, state, swing_state, candidate_trump, pct) |>
  mutate(predicted_pct_trump =  100 * posterior_predict(trump_model, newdata = testing_data, type = "response") |> colMeans(),
         winner_trump = ifelse(predicted_pct_trump > 50, 1, 0))

predicted_data_harris <- testing_data |>
  select(pollster, state, swing_state, candidate_harris, pct) |>
  mutate(predicted_pct_harris =  100 * posterior_predict(harris_model, newdata = testing_data, type = "response") |> colMeans(),
         winner_harris = ifelse(predicted_pct_harris > 50, 1, 0))

predicted_data <- predicted_data_harris |> merge(predicted_data_trump)

write_parquet(predicted_data, sink = "data/analysis_data/predicted_data.parquet")

F1_Score(predicted_data_trump$candidate_trump, predicted_data_trump$winner_trump)
F1_Score(predicted_data_harris$candidate_harris, predicted_data_harris$winner_harris)

AUC(predicted_data_trump$candidate_trump, predicted_data_trump$winner_trump)
AUC(predicted_data_harris$candidate_harris, predicted_data_harris$winner_harris)

RMSE(predicted_data_trump$candidate_trump, predicted_data_trump$predicted_pct_trump/100)
RMSE(predicted_data_harris$candidate_harris, predicted_data_harris$predicted_pct_harris/100)

#### Save model ####
saveRDS(
  trump_model,
  file = "models/trump_model.rds"
)

saveRDS(
  harris_model,
  file = "models/harris_model.rds"
)
