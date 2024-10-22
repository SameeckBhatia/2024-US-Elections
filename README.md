# 2024 US Elections

## Overview

This repository contains an end-to-end analysis for predicting the popular vote and winner of the 2024 U.S. election cycle. It uses polling estimates, demographic data, and other relevant factors. The project includes data collection, cleaning, and modeling, primarily conducted through R scripts. The final report compiles the predictions and analysis from a Bayesian model, providing insights into potential election outcomes.

## File Structure

The repo is structured as:

-   `data` contains all data (simulation, raw, analysis) relevant to the research.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in other/llm_usage/usage.txt.

## TO-DO:
- [ ] R citation - properly cite R in data section and references
- [ ] Data citation - cite 538 data
- [ ] Does not look like class paper - repo name, readme, paper, comments
- [ ] LLM usage - add txt in llm folder
- [x] Title
- [x] Author, date, and repo
- [ ] Abstract - need to write result/finding
- [ ] Introduction - need to write what was found and why its important; update model used
- [x] Estimand
- [ ] Data
- [ ] Measurement
- [ ] Model
- [ ] Results
- [ ] Discussion
- [ ] Prose
- [ ] Cross-references
- [ ] Captions
- [ ] Graphs/tables/etc
- [ ] Idealized methodology
- [ ] Idealized survey
- [ ] Pollster methodology overview and evaluation
- [ ] Referencing
- [ ] Commits
- [x] Sketches
- [x] Simulation
- [x] Simulation tests
- [ ] Actual tests
- [ ] Parquet
- [ ] Reproducibility
- [ ] Miscellaneous
- [ ] finalize readme
- [ ] remove this to-do
