#' @rdname db_getter
#' @export
get_KITEeastAfrica <- function(db_url = get_db_url("KITEeastAfrica")) {

  check_connection_to_url(db_url)

  # download data to temporary file
  tempo <- tempfile()

  writeBin(
    dataverse::get_file(
      "CARD Upload Template - KITE East Africa v2.1.csv", "doi:10.7910/DVN/NJLNRJ",
      server = "dataverse.harvard.edu"
    ),
    tempo
  )

  # read data
  KITEeastafrica <- tempo %>%
    readr::read_csv(
      skip = 3,
      trim_ws = TRUE,
      locale = readr::locale(encoding = "ISO-8859-1"),
      col_types = readr::cols(
        "Lab Number" = readr::col_character(),
        "Field Number" = "_", # `= "_"` removes/skips the column
        "Material Dated" = readr::col_character(),
        "Taxa Dated" = readr::col_character(),
        "Type of Date" = "_",
        "Locality" = "_",
        "Latitude" = readr::col_character(),
        "Longitude" = readr::col_character(),
        "Map Sheet" = "_",
        "Elevation     (m ASL)" = "_",
        "Submitter" = "_",
        "Date Submitted" = "_",
        "Collector" = "_",
        "Date Collected" = "_",
        "Updater" = "_",
        "Date Updated" = "_",
        "Measured Age" = "_",
        "MA Sigma" = "_",
        "Normalized Age" = readr::col_character(),
        "NA Sigma" = readr::col_character(),
        "Delta 13C (per mil)" = readr::col_character(),
        "Delta 13 C Source" = "_",
        "Significance" = "_",
        "Site Identifier" = readr::col_character(),
        "Site Name" = readr::col_character(),
        "Stratigraphic Component" = "_",
        "Context" = "_",
        "Associated Taxa" = "_",
        "Additional Information" = readr::col_character(),
        "Comments" = readr::col_character(),
        "References" = readr::col_character()
      )
    ) %>%
    dplyr::transmute(
      labnr = .data[["Lab Number"]],
      c14age = .data[["Normalized Age"]],
      c14std = .data[["NA Sigma"]],
      c13val = .data[["Delta 13C (per mil)"]],
      material = .data[["Material Dated"]],
      species = .data[["Taxa Dated"]],
      site = .data[["Site Identifier"]],
      lat = .data[["Latitude"]],
      lon = .data[["Longitude"]],
      shortref = .data[["References"]],
      feature = .data[["Site Name"]],
      comment = paste0(.data[["Comments"]], ",", .data[["Additional Information"]])
    ) %>% dplyr::mutate(
      sourcedb = "KITEeastafrica"
    ) %>%
    as.c14_date_list()

  return(KITEeastafrica)

}
