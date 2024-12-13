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

# discrete
scale_colour_brewer_d <- function(..., palette = "Dark2") {
  scale_colour_brewer(..., palette = palette)
}

scale_fill_brewer_d <- function(..., palette = "Dark2") {
  scale_fill_brewer(..., palette = palette)
}

options(
  ggplot2.discrete.colour = scale_colour_brewer_d,
  ggplot2.discrete.fill = scale_fill_brewer_d
)
# continuous
scale_colour_brewer_c <- function(..., palette = "Dark2") {
  scale_colour_distiller(..., palette = palette)
}

scale_fill_brewer_c <- function(..., palette = "Dark2") {
  scale_fill_distiller(..., palette = palette)
}

options(
  ggplot2.continuous.colour = scale_colour_brewer_c,
  ggplot2.continuous.fill = scale_fill_brewer_c
)

# the defult fill color
default_colors <- RColorBrewer::brewer.pal(name = "Dark2", n = 3)
default_col <- default_colors[1]
update_geom_defaults("col", list(fill = default_col))
update_geom_defaults("bar", list(fill = default_col))
