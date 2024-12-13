render_fun <- function(file, output_dir = "reports", inter_dir = "reports/cache/", format_out = "html", publication = FALSE, ...) {
  output_file <- paste0(
    gsub(".rmd", "", file),
    "_",
    format(Sys.Date(), "%Y%m%d")
  )
  source("config.R")
  if (config$dev) {
    output_file <- paste0(output_file, "-dev")
  }
  if (!dir.exists(inter_dir)) {
    dir.create(inter_dir)
  }
  # the default is always html
  document_function <- function() {
    rmarkdown::html_document(
      toc = TRUE,
      toc_depth = 4,
      toc_float = FALSE,
      theme = "sandstone",
      code_folding = "hide",
      css = "style.css",
      number_sections = TRUE
    )
  }
  if (format_out == "docx") {
    print("word")
    document_function <- function() rmarkdown::word_document()
  }
  if (format_out == "md") {
    print("markdown")
    document_function <- function() rmarkdown::md_document()
  }
  # if (format_out == "html") {
  #   format_out = "html_document"
  # }

  params_in <- list(format_out = format_out)

  rmarkdown::render(file,
    output_format = document_function(),
    output_dir = output_dir,
    output_file = output_file,
    intermediates_dir = inter_dir, # this might not be working?
    clean = FALSE,
    run_pandoc = TRUE,
    # params = params_in,
    ...
  )
}

# render_report <- function(...) {
#   render_fun(file = "report.rmd", output_dir = "study_reports", ...)
# }

render_create_cases_controls <- function(...) {
  render_fun(file = "report.rmd", ...)
}
