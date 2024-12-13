source("kep/pt.R")
create_lisa <- function(
    years = 1990:2022,
    lopnrs = NULL,
    cols = c("arblos$", "sun.+niva_old"),
    lisa_path = NULL, ...) {
  if (is.null(lisa_path) && exists("config")) {
    lisa_path <- config$lisa_path
  } else {
    stop("must set lisa_path or set in config$lisa_path")
  }
  # get all the paths
  lisa_files <- pt(lisa_path) |> list.files(pattern = "lisa", full.names = TRUE)

  # read all lisa files and combine them
  lisa_long <- purrr::map_dfr(years, function(yr) {
    print(yr)
    path <- lisa_files[grepl(paste(yr), lisa_files)]
    print(path)
    stopifnot(length(path) == 1)

    # because the naming os so inconsistent, i start of by reading just the first row
    # and then using some rx to find the correct column names
    # apparently scb have renamed sun2000 variable for 2019-2021 to sun2020
    # but  for ibd_2023 they are the same?
    d1row <- rio::import(path,
      setclass = "data.table",
      n_row = 1
    )
    cn <- colnames(d1row)
    cn_select <- cn[grepl(paste(c("lopnr", cols), collapse = "|"), stringr::str_to_lower(cn))]

    message(paste("reading", path, "for year", yr, "with columns\n", paste(cn_select, collapse = ", ")))

    lisa <- rio::import(path,
      setclass = "data.table",
      # might be Sun2000niva_old in some cases
      col_select = cn_select,
      ...
    )

    LopNr <- NULL
    lisa <- lisa |>
      mutate(lisa_year = yr)

    if (!is.null(lopnrs)) {
      lisa <- lisa[LopNr %in% ..lopnrs]
    }

    colnames(lisa) <- stringr::str_to_lower(colnames(lisa))

    return(lisa)
  })

  lisa_raw_path <- "data/data-raw/lisa_raw.rds"
  rio::export(lisa_long, lisa_raw_path)
  return(lisa_long)
}



# data_cases <- load_ibd_data_cases()
# lopnrs <- unique(data_cases$fall_kontroller_raw$LopNr)

if (FALSE) {
  # lisa_raw = lisa_long
  lopnrs <- unique(lisa_raw$lopnr)
  lopnrs_sample <- sample(length(lopnrs), 1000)
  lisa_long <- lisa_raw[lopnr %in% lopnrs_sample]
}

process_lisa <- function(lisa_raw) {
  # the levels are still the same for the different version according to:
  # https://www.scb.se/contentassets/aeeedec0e28c465aa524429407dcd5ba/sun-2020_manual_190628.pdf
  lisa_raw <- lisa_raw |>
    mutate(sun = case_when(
      !is.na(sun2020niva_old) ~ sun2020niva_old,
      !is.na(sun2000niva_old) ~ sun2000niva_old,
      .default = NA
    ))

  tabyl(lisa_raw, sun)
  colnames(lisa_raw) <- stringr::str_to_lower(colnames(lisa_raw))

  # remove old sun niva old
  lisa_raw <- select(lisa_raw, lopnr, lisa_year, arblos, sun)

  lisa_processed <- lisa_long |>
    mutate(
      edu = case_when(
        sun %in% 0:1 ~ 1,
        sun %in% 2:3 ~ 2,
        sun >= 4 ~ 3,
        .default = NA
      )
    )

  lisa_processed <- lisa_processed |>
    mutate(edu_fac = factor(edu, levels = 1:3, labels = c("<9", "10-12", ">12")))

  tabyl(lisa_processed, sun, edu_fac)
  message("writing lisa_processed.rds")
  rio::export(lisa_processed, pt("data/data-processed/lisa_processed.rds"))
  return(lisa_processed)
}

if (FALSE) {
  lisa_long <- create_lisa()
  rio::export(lisa_long, "./data/data-raw/lisa_raw.rds")
  lisa_raw <- rio::import("./data/data-raw/lisa_raw.rds", trust = TRUE)
  lisa <- process_lisa(lisa_raw)
}
