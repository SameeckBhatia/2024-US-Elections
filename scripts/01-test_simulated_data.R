#### Preamble ####
# Purpose: Tests whether the simulated data is valid and is the required size.
# Author: Sameeck Bhatia
# Date: 14 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
#   - The `testthat` packages must be installed and loaded
#   - 00-simulate_data.R must have been run
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
test_that("The dataset has 1000 observations", {
  expect_equal(nrow(simulated_data), 1000)
})

test_that("Each state has at least 1 congressional district and at most 52", {
  expect_in(range(simulated_data$district), c(1, 52))
})

test_that("There are three parties in the dataset", {
  expect_length(unique(simulated_data$party), 3)
})

test_that("All surveyor IDs are unique", {
  expect_length(unique(simulated_data$id), 1000)
})

test_that("At least one reponse of each race is in the dataset", {
  expect_contains(unique(simulated_data$race), c("w", "b", "h", "a", "n", "o"))
})
