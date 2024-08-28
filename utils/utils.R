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
