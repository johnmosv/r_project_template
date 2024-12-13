kep_folder <- function(path = NULL, folder = NULL) {
  if (is.null(folder) && exists("config")) {
    folder <- pt(config$folder)
  }
  if (is.null(folder)) {
    stop("must provide 'folder' or set it in ./config.R 'config$folder'")
  }
  if (is.null(path)) {
    print(paste("no path provided. listing files in :", folder))
    return(list.files(pt(folder)))
  }
  if (!grepl("/$", folder)) {
    folder <- paste0(folder, "/")
  }
  file_path <- paste0(pt(folder), path)
  # check if is file or dir
  info <- file.info(file_path)
  if (!is.na(info$isdir) && info$isdir) {
    print(paste("is a directory:", file_path))
    print(list.files(file_path), collapse = "\n")
    return(file_path)
  }
  if (!file.exists(file_path)) {
    file_path_no_file <- sub("/[^/]*$", "", file_path)
    listed_files <- list.files(pt(file_path_no_file))
    warning(file_path)
    stop(paste("cannot find file among:", paste(listed_files, collapse = "\n")))
  }
  return(file_path)
}
read_scb <- function(path = NULL) {
  folder <- paste0(config$folder, config$scb_folder)
  kep_folder(path = path, folder = folder)
}
# read_scb("scb_iot_2000.sas7bdat")

read_sos <- function(path = NULL) {
  folder <- paste0(config$folder, config$sos_folder)
  kep_folder(path = path, folder = folder)
}
# read_sos("sos_dodsorsak9121.sas7bdat")
