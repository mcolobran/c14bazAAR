#' get AustArch: A Database of 14C and Luminescence Ages from Archaeological Sites in Australia
#'
#' See:
#' - AustArch: A Database of 14C and Non-14C Ages from Archaeological Sites in Australia - Composition, Compilation and Review (Data Paper) http://intarch.ac.uk/journal/issue36/6/williams.html
#' - AustArch: A Database of 14C and Luminescence Ages from Archaeological Sites in Australia http://archaeologydataservice.ac.uk/archives/view/austarch_na_2014/
#'
#' @param db_url string with weblink to c14 archive file
#'
#' @examples
#'
#' \dontrun{
#'   AustArch <- get_AustArch()
#' }
#'
#' @export
get_AustArch <- function(db_url = get_db_url("AustArch")) {

  # check connection
  if (!RCurl::url.exists(db_url)) {stop(paste(db_url, "is not available. No internet connection?"))}

  # read data
  AustArch <- withCallingHandlers(
      readr::read_csv(
        db_url,
        trim_ws = TRUE,
        col_types = readr::cols(
          ADSID = "_",
          IBRA_REGION = readr::col_character(),
          LONGITUDE = readr::col_character(),
          LATITUDE = readr::col_character(),
          SITE = readr::col_character(),
          SITE_TYPE = readr::col_character(),
          LAB_CODE = readr::col_character(),
          AGE = readr::col_character(),
          ERROR = readr::col_character(),
          C13_AGE = readr::col_character(),
          C13_ERROR = "_",
          MATERIAL = readr::col_character(),
          MATERIAL_TOP_LEVEL = "_",
          CONTEXT = readr::col_character(),
          DEPTH_FROM_SURFACE_CM = "_",
          METHOD = readr::col_character(),
          TECHNIQUE = "_",
          'Data pertinent for time-series analysis or calibration' = "_",
          'Open or Closed Site' = "_",
          'Directly Related to occupation? Yes/Unknown' = "_",
          SOURCE = readr::col_character(),
          NOTES = readr::col_character(),
          RECORD_SOURCE = "_",
          DATE_ISSUES = "_",
          AGE_NORM = "_",
          ADDITIONAL_DATA_ISSUES = "_"
        )
      ),
      warning = function(w){
        if(any(grepl("Missing column names filled", w))) {
          invokeRestart("muffleWarning")
        }
      }
    ) %>%
    dplyr::transmute(
      labnr = .data[["LAB_CODE"]],
      c14age = .data[["AGE"]],
      c14std = .data[["ERROR"]],
      c13val = .data[["C13_AGE"]],
      material = .data[["MATERIAL"]],
      site = .data[["SITE"]],
      lat = .data[["LATITUDE"]],
      lon = .data[["LONGITUDE"]],
      feature = .data[["CONTEXT"]],
      shortref = .data[["SOURCE"]],
      region = .data[["IBRA_REGION"]],
      sitetype = .data[["SITE_TYPE"]],
      method = .data[["METHOD"]],
      comment = .data[["NOTES"]]
    ) %>% dplyr::mutate(
      sourcedb = "AustArch"
    ) %>%
    as.c14_date_list()

  return(AustArch)
}