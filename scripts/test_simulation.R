#### Preamble ####
# Purpose: Tests whether the simulated data is valid and is the required size.
# Author: Sameeck Bhatia, Sean Chua, Tanmay Shinde
# Date: 30 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
#   - The `testthat` packages must be installed and loaded
#   - simulation.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
test_that("poll_id values are unique", {
  expect_equal(any(duplicated(simulated_data$poll_id)), FALSE)
})

test_that("State, population, and candidate contain expected values only", {
  expected_states <- c("AZ", "FL", "GA", "NY", "WA")
  expected_populations <- c("likely", "registered")
  expected_candidates <- c("Trump", "Harris")
  
  expect_true(all(simulated_data$state %in% expected_states))
  expect_true(all(simulated_data$population %in% expected_populations))
  expect_true(all(simulated_data$candidate %in% expected_candidates))
})

test_that("end_date is within the expected date range", {
  expect_true(all(simulated_data$end_date >= as.Date("2024-07-21")))
  expect_true(all(simulated_data$end_date <= as.Date("2024-10-30")))
})

test_that("sample_size is within a reasonable range", {
  expect_true(all(simulated_data$sample_size > 100))
  expect_true(all(simulated_data$sample_size < 2000))
})

test_that("percent is within the range 0-100", {
  expect_true(all(simulated_data$percent >= 0 & simulated_data$percent <= 100))
})

test_that("mean percent aligns with state-specific expectations", {
  state_means <- simulated_data %>%
    group_by(state, candidate) %>%
    summarise(mean_percent = mean(percent), .groups = "drop")
  
  expected_means <- tibble(
    state = c("AZ", "FL", "GA", "NY", "WA"),
    Trump = c(49, 50, 50, 39, 41),
    Harris = c(51, 50, 50, 61, 59)
  )
  
  for (s in unique(state_means$state)) {
    trump_mean <- state_means$mean_percent[state_means$state == s & state_means$candidate == "Trump"]
    harris_mean <- state_means$mean_percent[state_means$state == s & state_means$candidate == "Harris"]
    expect_true(abs(trump_mean - expected_means$Trump[expected_means$state == s]) < 3)
    expect_true(abs(harris_mean - expected_means$Harris[expected_means$state == s]) < 3)
  }
})

test_that("There are no missing values in the data", {
  expect_equal(sum(is.na(simulated_data)), 0)
})