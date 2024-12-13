# from iris code found in ibd_academics/qc/create casses controls...
# Function for imputing and converting dates
create_dates <- function(dates, imputation_method = "first") {
  # should only accept character in date format
  if ("Date" %in% class(dates)) {
    message("already in date format. Returning as is")
    return(dates)
  }

  # Convert to character
  dates <- as.character(dates)
  if (any(nchar(dates) < 4)) {
    n_lt4 <- sum(nchar(dates) < 4)
    p_lt4 <- mean(nchar(dates) < 4)
    warning(glue::glue(
      "There are dates with less than 4 characters coded as NA.
n={n_lt4} ({scales::percent(p_lt4)})"
    ))
  }

  # If imputation_method = "first"/"middle"
  if (imputation_method == "first" | imputation_method == "middle") {
    imp_day <- ifelse(imputation_method == "middle", "15", "01")
    imp_month <- ifelse(imputation_method == "middle", "06", "01")

    # Impute month
    dates <- ifelse(substr(dates, 5, 6) == "00" | substr(dates, 5, 6) == "",
      paste(substr(dates, 1, 4), imp_month, substr(dates, 7, 8), sep = ""),
      dates
    )

    # Impute day
    dates <- ifelse(substr(dates, 7, 8) == "00" | substr(dates, 7, 8) == "",
      paste(substr(dates, 1, 6), imp_day, sep = ""),
      dates
    )

    # If imputation_method = "last"
  } else if (imputation_method == "last") {
    # Function for computing last day of month
    last_day_of_month <- function(month, year) {
      last_day <- ifelse(month %in% c("01", "03", "05", "07", "08", "10", "12"), "31",
        ifelse(month != "02", "30",
          ifelse(month == "02" & year %in% as.character(seq(4, 2024, 4)), "29", "28")
        )
      )

      return(last_day)
    }

    # Impute month
    dates <- ifelse(substr(dates, 5, 6) == "00",
      paste(substr(dates, 1, 4), "12", substr(dates, 7, 8), sep = ""),
      dates
    )

    # Impute day
    dates <- ifelse(substr(dates, 7, 8) == "00" | substr(dates, 7, 8) == "",
      paste(substr(dates, 1, 6),
        last_day_of_month(
          month = substr(dates, 5, 6),
          year = substr(dates, 1, 4)
        ),
        sep = ""
      ),
      dates
    )
  } else {
    stop("Incorrect specification of imputation method.")
  }

  # Transform DodDatum to a date variable
  dates <- as.Date(dates, format = "%Y%m%d")

  return(dates)
}
