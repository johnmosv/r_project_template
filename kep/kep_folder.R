kep_folder <- function(path, folder = NULL) {
  if (is.null(folder) && exists("config")) {
    folder <- config$folder
  } else {
    stop("must provide 'folder' or set it in ./config.R 'config$folder'")
  }
  file_path <- paste0(pt(folder), path)
  if (!file.exists(file_path)) {
    file_path_no_file <- stringr::str_remove(file_path, "/.+$")
    listed_files <- list.files(pt(file_path_no_file))
    stop(paste("cannot find file among:", paste(listed_files, collapse = "\n")))
  }
  return(file_path)
}
