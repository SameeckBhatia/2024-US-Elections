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
library(MLmetrics)

model_data <- read_parquet("data/analysis_data/analysis_data.parquet")

model_data <- model_data |>
  mutate(pollster = as.factor(pollster),
         state = as.factor(state),
         population = as.factor(population),
         weight = numeric_grade * (sample_size / min(sample_size)),
         days_to_election = as.numeric(election_date - end_date))

set.seed(12)

training_index <- createDataPartition(model_data$state, p = 0.7, list = FALSE)

training_data <- model_data[training_index,]
testing_data <- model_data[-training_index,]

testing_data <- testing_data |> filter(pollster %in% unique(training_data$pollster))

priors <- normal(0.5, 2.5, autoscale = TRUE)
formula <- candidate_trump ~ (1 | pollster) + (1 | state) + sample_size + pct + days_to_election

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
  seed = 12
)

pp_check(model)

set.seed(12)

predicted_data <- testing_data |>
  select(pollster, state, candidate_trump, pct) |>
  mutate(predicted_pct =  100 * posterior_predict(model, newdata = testing_data, 
                                                  draws = 2000, type = "response") |> colMeans(),
         winner_trump = ifelse(predicted_pct > 50, 1, 0))

predicted_data |>
  group_by(state) |> 
  summarise(mean_pct = round(mean(pct), 2), 
            mean_predicted = round(mean(predicted_pct), 2), 
            .groups = "drop") |>
  mutate(predicted_winner = ifelse(mean_predicted > 50, "Trump", "Harris"))

F1_Score(predicted_data$candidate_trump, predicted_data$winner_trump)

RMSE(predicted_data$pct, predicted_data$predicted_pct)

#### Save model ####
saveRDS(
  election_model,
  file = "models/election_model.rds"
)
