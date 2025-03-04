source("config.R")

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE,
  # stop if error in dev, TRUE -> continues despite errors
  error = config$dev,
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
}

# init results
results <- list()

# Libraries
# library(tidyverse)
library(dplyr)
library(readr)
library(tidyr)
library(stringr)
library(ggplot2)
library(lubridate)
library(janitor)
library(rio)
library(knitr) # for kable
library(data.table) # for kable
library(johnmosvr) # remotes::install_github("johnmosv/johnmosvr"), for table_dt and truethy
# tryCatch(detach("package:dplyr"), error = function(e) invisible(NULL))

source("utils/utils.R")
source("utils/render.R")

source("kep/contents.R")
source("kep/pt.R")
source("kep/kep_folder.R")

source("linkage/create_dates.R")
source("linkage/create_lisa.R")
source("linkage/create_pdr.R")
source("linkage/create_rtb.R")
source("linkage/add_index.R")




DT <- `[`
PT <- `[[`
filter <- dplyr::filter
mutate <- dplyr::mutate
# options
options(pillar.print_max = 1)
options(tibble.print_max = 1)
options(dplyr.print_max = 1)
options(datatable.print.nrows = 1)
options(max.print = 500)
options(width = 300)

# mask table_dt
table_dt <- function(...) {
  johnmosvr::table_dt(..., title_row_names = FALSE, title_col_names = FALSE)
}
# ggplot2
theme_set(theme_classic(base_size = 18))

# Define a custom palette with 15 colors
custom_palette <- c(
  "#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e",
  "#e6ab02", "#a6761d", "#666666", "#8dd3c7", "#ffffb3",
  "#bebada", "#fb8072", "#80b1d3", "#fdb462", "#b3de69"
)

# discrete
scale_colour_custom_d <- function(...) {
  scale_colour_manual(..., values = custom_palette)
}

scale_fill_custom_d <- function(...) {
  scale_fill_manual(..., values = custom_palette)
}

options(
  ggplot2.discrete.colour = scale_colour_custom_d,
  ggplot2.discrete.fill = scale_fill_custom_d
)

# continuous
scale_colour_custom_c <- function(...) {
  scale_colour_gradientn(..., colors = custom_palette)
}

scale_fill_custom_c <- function(...) {
  scale_fill_gradientn(..., colors = custom_palette)
}

options(
  ggplot2.continuous.colour = scale_colour_custom_c,
  ggplot2.continuous.fill = scale_fill_custom_c
)

