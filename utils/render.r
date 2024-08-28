render_fun <- function(file, output_dir, inter_dir = "reports/.cache", format_out = "html", publication = FALSE, ...) {
  output_file <- paste0(
    gsub(".rmd", "", file),
    "_",
    format(Sys.Date(), "%Y%m%d")
  )
  if (!dir.exists(inter_dir)) {
    dir.create(inter_dir)
  }
  document_function <- function() {
    rmarkdown::html_document(
      toc = TRUE,
      toc_depth = 4,
      toc_float = FALSE,
      theme = "sandstone",
      code_folding = "hide",
      css = "style.css"
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

  params_in <- list(format_out = format_out)

  rmarkdown::render(file,
    output_format = document_function(),
    output_dir = output_dir,
    output_file = output_file,
    intermediates_dir = inter_dir,
    clean = FALSE,
    params = params_in,
    ...
  )
}
render_report <- function(...) {
  render_fun(file = "report.rmd", output_dir = "study_reports", ...)
}
