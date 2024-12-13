config <- list(
  read_raw = FALSE,
  dev = FALSE,
  folder = "",
  scb_path = "",
  sos_path = "",
  inc_years = NULL,
  pre_year = NULL,
  study_start = lubridate::ymd(NULL),
  # for both incidence and prevalence
  icd = list(
    example = ""
  ),
  atc = list(
    "example" = c()
  )
)
