% Generated by roxygen2: do not edit by hand
% Please edit documentation in
%   R/c14_date_list_spatial_standardize_country_name.R
\name{find_correct_name_by_stringdist_comparison}
\alias{find_correct_name_by_stringdist_comparison}
\title{find_correct_name_by_stringdist_comparison}
\usage{
find_correct_name_by_stringdist_comparison(db_word, country_df, codes, ...)
}
\arguments{
\item{db_word}{individual term for which to find a better name}

\item{country_df}{reference table}

\item{codes}{which country codesets are included in country_df}

\item{...}{additional arguments are passed to stringdist::stringdist()}
}
\value{
a correct english country name
}
\description{
find_correct_name_by_stringdist_comparison
}
\keyword{internal}
