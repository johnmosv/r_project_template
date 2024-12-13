# normalize server path
# path <- "K:/IBD_2023/Data/Processed Data/02 Data/Diagnoses/cd_oppen.csv"
pt <- function(path) {
  # test if can access path in r, must return true or false
  can_access <- file.exists(path)
  if (can_access) {
    return(path)
  }

  drive_reg <- "^[A-Z, a-z]:"
  is_absolute_path <- stringr::str_detect(path, drive_reg)
  if (!is_absolute_path) {
    return(path)
  }

  # convert to wsl path
  if (is_absolute_path) {
    drive <- stringr::str_extract(path, "^[A-Z, a-z]{1}")
    path_wsl <- stringr::str_replace(path, drive_reg, glue::glue("/mnt/{drive}")) |>
      stringr::str_to_lower()
    wsl_works <- file.exists(path_wsl)
    if (!wsl_works) {
      stop(paste("Path does not exist in Windows or WSL/n", path_wsl))
    }
    return(path_wsl)
  }
}
