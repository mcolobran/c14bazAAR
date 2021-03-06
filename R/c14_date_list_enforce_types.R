#### enforce variable types ####

#' @name enforce_types
#' @title Enforce variable types in a \strong{c14_date_list}
#'
#' @description Enforce variable types in a \strong{c14_date_list} and remove
#' everything that doesn't fit (e.g. text in a number field).
#' See \code{c14bazAAR::variable_reference()} for a documenation of the variable
#' types. \code{enforce_types()} is called in \code{c14bazAAR::as.c14_date_list()}.
#'
#' @param x an object of class c14_date_list
#' @param suppress_na_introduced_warnings suppress warnings caused by data removal in
#' type transformation due to wrong database entries (surch as text in a number column)
#'
#' @return an object of class c14_date_list
#' @export
#'
#' @rdname enforce_types
#'
enforce_types <- function(x, suppress_na_introduced_warnings = TRUE) {
  UseMethod("enforce_types")
}

#' @rdname enforce_types
#' @export
enforce_types.default <- function(x, suppress_na_introduced_warnings = TRUE) {
  stop("x is not an object of class c14_date_list")
}

#' @rdname enforce_types
#' @export
enforce_types.c14_date_list <- function(x, suppress_na_introduced_warnings = TRUE) {

  # define variable type lists
  chr_cols <- c(
    "sourcedb", "method", "labnr", "site", "sitetype", "feature", "period",
    "culture", "material", "material_the", "species", "region", "country",
    "country_coord", "country_thes", "country_final", "shortref",
    "comment", "duplicate_remove_log"
  )
  int_cols <- c("c14age", "c14std", "calage", "calstd", "duplicate_group")
  dbl_cols <- c("c13val", "lat", "lon", "coord_precision")

  # transform (invalid values become NA)
  if (suppress_na_introduced_warnings) {
    withCallingHandlers({
      x <- x %>%
        dplyr::mutate_if(colnames(.) %in% chr_cols, as.character) %>%
        dplyr::mutate_if(colnames(.) %in% int_cols, as.integer) %>%
        dplyr::mutate_if(colnames(.) %in% dbl_cols, as.double)
      },
      warning = na_introduced_warning_handler
    )
  } else {
    x <- x %>%
      dplyr::mutate_if(colnames(.) %in% chr_cols, as.character) %>%
      dplyr::mutate_if(colnames(.) %in% int_cols, as.integer) %>%
      dplyr::mutate_if(colnames(.) %in% dbl_cols, as.double)
  }

  x %<>% `class<-`(c("c14_date_list", class(.)))

  return(x)
}

#### helpers ####

na_introduced_warning_handler <- function(x) {
  if(any(
    grepl("NAs introduced by coercion", x)
  )) {
    invokeRestart("muffleWarning")
  }
}
