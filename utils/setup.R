source("config.R")

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE,
  echo = TRUE,
  include = TRUE,
  cache = FALSE, # set to false for prod
  cache.lazy = FALSE,
  fig.height = 12,
  fig.width = 16,
  fig.align = "center"
)
if (!exists("params")) {
  params <- config
  params <- list(format_out = "html")
}

# Libraries
library(readr)
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)
library(ggplot2)
library(lubridate)
library(rio)

source("utils/utils.R")
