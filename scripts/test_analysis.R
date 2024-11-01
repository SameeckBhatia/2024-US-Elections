#### Preamble ####
# Purpose: Tests whether the analysis data is valid and has the required variables.
# Author: Sameeck Bhatia
# Date: 21 October 2024
# Contact: sameeck.bhatia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - The `tidyverse` package must be installed and loaded
#   - The `testthat` packages must be installed and loaded
#   - cleaning.R must have been run
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

data <- read_parquet("data/analysis_data/analysis_data.parquet")

# Test if the data was successfully loaded
if (exists("data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####
test_that("Critical fields have no missing values", {
  expect_false(any(is.na(data$poll_id)))
  expect_false(any(is.na(data$pollster)))
  expect_false(any(is.na(data$pct)))
})

test_that("Percentage values are within valid range", {
  expect_true(all(data$pct >= 0 & data$pct <= 100))
})

test_that("Sample sizes are positive", {
  expect_true(all(na.omit(data$sample_size) > 0))
})

test_that("Start date is before end date", {
  expect_true(all(as.Date(data$start_date) <= as.Date(data$end_date, format="%m/%d/%y")))
})

