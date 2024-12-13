# argumets = cohort
source("linkage/add_index.R")
source("kep/pt.r")

# just lopnr atc ,edatum
# pdr_cases_raw <- rio::import(pt("data/data-raw/pdr_cases_raw.rds"), trust = TRUE, setclass = "data.table")
colnames(pdr_cases_raw) <- stringr::str_to_lower(colnames(pdr_cases_raw))

# atcs
atc_regex <- paste(unlist(config$atc), collapse = "|")
pdr_anemi <- pdr_cases_raw[atc %like% atc_regex]

rio::export(pdr_anemi, pt("data/data-processed/pdr_anemi.rds"))

# filter on year atc
pdr_anemi[, yr := year(edatum)]

pdr_anemi[atc %in% config$atc$targeted_therapies$before_2008, .N, by = c("yr", "atc")]



# make sure all are present
study_drugs <- purrr::imap_dfr(config$atc, function(value, name) {
  # print(name)
  # print(value)
  data.frame(group = rep(name, length(value)), atc = value)
})

atc_count <- pdr_anemi |>
  group_by(atc, yr) |>
  count() |>
  pivot_wider(values_from = n, names_from = yr) |>
  ungroup()

atc_count2 <- full_join(study_drugs, atc_count, by = "atc")

# create group pattern
for (group_name in names(config$atc)) {
  atcs <- config$atc[[group_name]]
  pattern <- paste(atcs, collapse = "|")
  atc_count2 <- atc_count2 |> mutate(group = fifelse(grepl(pattern, atc), group_name, group))
}

rio::export(atc_count2, "outfiles/atc_count.csv")



# remove drugs after 2008 for some drugs
# anemi_pdr2 = anemi_pdr[!atc %in% config$atc$targeted_therapies$before_2008 & yr > 2008]
