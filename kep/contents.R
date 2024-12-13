content <- function(x, var_name, present_n = 5) {
  if (grepl("lopnr", stringr::str_to_lower(var_name))) {
    # if lopnr, just return the min and max str length
    sl <- stringr::str_length(paste(x))
    rt <- suppressWarnings(paste("str_length", paste(range(sl, na.rm = TRUE), collapse = " - ")))
    return(rt)
  }
  if (is.numeric(x) || is.Date(x)) {
    rt <- suppressWarnings(paste(range(x, na.rm = TRUE), collapse = " - "))
    return(rt)
  }
  if (is.character(x)) {
    un <- unique(x)
    len_unique <- length(un)
    if (len_unique > present_n) {
      pres <- paste(un[1:present_n], collapse = ", ")
      pres <- glue::glue("{pres}, (... n={len_unique})")
      return(pres)
    }
    pres <- paste(un, collapse = ", ")
    return(pres)
  }
  return(class(x))
}

contents <- function(.data) {
  purrr::imap_dfr(.data, function(var, var_name) {
    data.frame(
      variable = var_name,
      class = class(var),
      na = scales::percent(mean(is.na(var))),
      null = scales::percent(mean(paste(var) == "NULL")),
      n_unique = length(unique(var)),
      content = content(var, var_name = var_name)
    )
  })
}
