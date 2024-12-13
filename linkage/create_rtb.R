source("load_ibd_data.R")
source("utils/pt.R")

create_rtb <- function(
    rtb_years = 1968:2022,
    lopnrs = NULL,
    rtb_path = "K:/ibd_2023/Data/Raw data/scb/",
    n_max = Inf, ...) {
  paths <- pt(rtb_path) |> list.files(pattern = "rtb", full.names = TRUE)
  rtb_source <- purrr::map_dfr(rtb_years, function(rtb_year) {
    print(rtb_year)
    path <- paths[grepl(paste(rtb_year), paths)]
    if (length(path) == 0) stop("no file found for ", rtb_year)

    col_select <- c("LopNr", "Lan", "Kommun", "Civil")
    if (rtb_year >= 2016) {
      col_select <- c("LopNr", "Lan", "Kommun", "Civil")
    }

    rtb_source <- rio::import(path, setclass = "data.table", col_select = col_select, n_max = Inf)
    # only source_pop
    if (!is.null(lopnrs)) {
      rtb_source <- rtb_source[LopNr %in% lopnrs]
    }
    rtb_source <- rtb_source[!duplicated(LopNr)]

    # I dont think distriktskod is available in ibd2023
    if ("DistriktsKod" %in% colnames(rtb_source)) {
      rtb_source <- rtb_source |> mutate(DistriktsKod = NA)
    }
    if ("Forsamling" %in% colnames(rtb_source)) {
      rtb_source <- rtb_source |> mutate(Forsamling = NA_character_)
    }
    rtb_source <- rtb_source |> mutate(rtb_year = rtb_year)
    return(rtb_source)
  })
  return(rtb_source)
}

# data <- load_ibd_data()
# rtb <- create_rtb(n_max = Inf)

# rio::export(rtb, "data/data-raw/rtb.rds")

#
# # #### Create lan (region), if only forsasmling and distriktkod are availalble
# # - mapping forsamling - distrikt: **lantmateriet_referenstabell_distrikt_forsamling2015.xlsx** so we can get forsamling
# # -
# # - the two first digits of forsamlingskod = lan kod
# # - befolkningsdata then have the mapping for lan kod and region
#
# distrikt_forsamling <- readxl::read_xlsx("resources/lantmateriet_referenstabell_distrikt_forsamling2015.xlsx")
# distrikt_forsamling <- janitor::clean_names(distrikt_forsamling)
# distrikt_forsamling <- distrikt_forsamling |>
#   select(distriktskod, lkf_forsamlingskod_2015) |>
#   rename(distrikts_kod = distriktskod, forsamling = lkf_forsamlingskod_2015)
#
#
# rtb_distrikt <- filter(rtb_source, !is.na(distrikts_kod))
#
# rtb_distrikt_forsamling <- left_join(
#   select(rtb_distrikt, -forsamling),
#   distrikt_forsamling,
#   by = "distrikts_kod",
#   # as the same distrikt can include multiple forsamlingar must set many to many and remove duplicates (handled at the end)
#   relationship = "many-to-many"
# )
#
#
# # drop distrikt
# rtb_distrikt_forsamling <- rtb_distrikt_forsamling |> select(-distrikts_kod)
#
# # combine the data again
# rtb_forsamling <- rtb_source |>
#   filter(is.na(distrikts_kod))
# # one row per lpnr and rbt_year with forsamling for all (mapped from distriktskod after 2016)
# rtb_lan_source <- bind_rows(rtb_forsamling, rtb_distrikt_forsamling)
#
# # get the latest row each year (if they have moved in that year there are multiple rows)
# rtb_lan_source <- rtb_lan_source |>
#   group_by(lopnr, rtb_year) |>
#   # most precise way to get the latest row from the year.
#   # this assumes scb have ordered the data corretly. at least we have done
#   # the best we can.
#   summarise(forsamling = unique(forsamling)[length(unique(forsamling))], .groups = "drop")
#
#
# # extract first two digits from forsamling which = lan
# rtb_lan_source <- rtb_lan_source |>
#   mutate(lan = stringr::str_extract(forsamling, ".{2}"))
#
# tabyl(rtb_lan_source, lan)
# # the ones that are missing simply dont have forsamling or distrikt for that year
# # missing_lan_lopnr = filter(rtb_lan_source, is.na(lan)) |> head(1) |> pull(lopnr)
# # rtb_lan_source |> filter(lopnr == missing_lan_lopnr)
# # rtb_source |> filter(lopnr == missing_lan_lopnr)
#
# # all lan exist for all years
# tabyl(rtb_lan_source, lan, rtb_year)
#
# # add region from befolkning
# region_lan_mapping <- scb_befolkning |>
#   group_by(lan, region) |>
#   count() |>
#   select(-n)
#
# rtb_lan_source <- rtb_lan_source |>
#   full_join(region_lan_mapping, by = c("lan" = "lan"))
#
# rtb_lan_source |>
#   group_by(region, lan) |>
#   count() |>
#   table_dt(caption = paste(
#     "Number of rows (one row per lopnr and year) in RTB between ",
#     paste(range(rtb_lan_source$rtb_year), collapse = "-")
#   ))
#
# message_data(rtb_lan_source)
