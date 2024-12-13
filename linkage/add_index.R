# Will innerjoin lopnr and index_date to .data and remove visits before index by default.
# If you want to add more variables ,add to vars
add_index <- function(.data, rhs, vars = c("lopnr", "index_date"), by = "lopnr", remove_before_index = TRUE, date_var = "INDATUM") {
  vars <- unique(c(by, vars))
  colnames(.data)[grepl("LopNr", colnames(.data))] <- "lopnr"
  # inner join to cohort
  d <- merge(.data, rhs[, ..vars], all = FALSE, by = by, allow.cartesian = TRUE)
  message(nrow(d) / nrow(.data))
  if (remove_before_index) {
    d <- d[get(date_var) <= index_date]
    message(nrow(d) / nrow(.data))
  }
  return(d)
}
