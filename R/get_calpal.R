#' @rdname db_getter
#' @export
get_CalPal <- function(db_url = get_db_url("CalPal")) {

  check_connection_to_url(db_url)

  # read data
  CALPAL <- db_url %>%
    readr::read_csv(
      trim_ws = TRUE,
      na = c("", "nd", "--", "n/a", "NoCountry"),
      col_types = readr::cols(
        ID = "_",
        LABNR = readr::col_character(),
        C14AGE = readr::col_character(),
        C14STD = readr::col_character(),
        C13 = readr::col_character(),
        MATERIAL = readr::col_character(),
        SPECIES = readr::col_character(),
        COUNTRY = readr::col_character(),
        SITE = readr::col_character(),
        PERIOD = readr::col_character(),
        CULTURE = readr::col_character(),
        PHASE = "_",
        LOCUS = "_",
        LATITUDE = readr::col_character(),
        LONGITUDE = readr::col_character(),
        METHOD = readr::col_character(),
        REFERENCE = readr::col_character(),
        NOTICE = readr::col_character()
      )
    ) %>%
    dplyr::transmute(
      labnr = .data[["LABNR"]],
      c14age = .data[["C14AGE"]],
      c14std = .data[["C14STD"]],
      c13val = .data[["C13"]],
      material = .data[["MATERIAL"]],
      species = .data[["SPECIES"]],
      country = .data[["COUNTRY"]],
      site = .data[["SITE"]],
      period = .data[["PERIOD"]],
      culture = .data[["CULTURE"]],
      lat = .data[["LATITUDE"]],
      lon = .data[["LONGITUDE"]],
      method = .data[["METHOD"]],
      shortref = .data[["REFERENCE"]],
      comment = .data[["NOTICE"]]
    ) %>% dplyr::mutate(
      sourcedb = "CALPAL"
    ) %>%
    as.c14_date_list()

  return(CALPAL)
}
