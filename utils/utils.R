format_scale <- function(x, scale = 1e5, round_n = 1, big_mark = ",", ...) {
  stringr::str_trim(format(round(x * scale, round_n),
    digtis = round_n,
    nsmall = round_n,
    big.mark = big_mark,
    justify = "none",
    ...
  ))
}

formatr <- function(x) {
  format(round(x, 0), nsmall = 0, big.mark = ",")
}

# ggplot helpers
theme <- function(...) {
  ggplot2::theme(axis.text = ggplot2::element_text(face = "bold"), ...)
}

hms_to_ymd <- function(x) {
  date_string <- stringr::str_extract(x, "\\d{4}-?\\d{2}-?\\d{2}")
  lubridate::ymd(date_string)
}

clean_string <- function(x) {
  new <- stringr::str_to_lower(x)
  # remove , . and paranthesis and multiple whitespaces
  new <- stringr::str_remove_all(new, ",|\\.|\\(|\\)")
  new <- stringr::str_replace_all(new, "\\s+", " ")
  # remove leading and trailing whitespaces and tabs
  new <- stringr::str_remove_all(new, "^\\s|$\\s")
  return(new)
}
# clean_string("   This, does not. Look   good   at all   ")

convert_tableone <- function(tabone, ...) {
  x <- print(tabone, showAllLevels = FALSE, printToggle = FALSE)
  row_names <- rownames(x)
  df_rn <- data.frame(var = row_names)
  mtx <- as.data.frame.matrix(x)
  df <- bind_cols(df_rn, mtx)
  rownames(df) <- NULL
  return(df)
}
