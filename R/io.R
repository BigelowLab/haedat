#' Read OBIS haedat data in DWCA form
#' 
#' @seealso \href{https://ipt.iobis.org/hab/resource?r=haedat}{IPT OBIS}
#' @export
#' @param what character, one or more data elements to read
#' @param filename character, the name of the file to read
#' @param form charcater, one of 'tibble' or 'sf' specify the output class type. Only
#'   applies to the 'event' data source.  If form is 'sf' then the records with missing
#'   location information (no lat and/or lon) are purged. Also, all remaining locations
#'   are cropped to \code{[-180, -90, 180, 90]}.
#' @return a list or one or more tibbles or sf objects
read_haedat_obis <- function(what = c("event","occurrence", "extendedmeasurementorfact"),
                        filename = list_obis()[1],
                        form = c("tibble", "sf")[2]){
  
  what = match.arg(what, 
                   c("event","occurrence", "extendedmeasurementorfact"),
                   several.ok = TRUE)
  x <- suppressMessages(finch::dwca_read(filename[1], read = TRUE))
  r <- sapply(what,
         function(w, x = NULL){
           iw <- grep(w, names(x$data), fixed = TRUE)
           x$data[[iw[1]]] |> dplyr::as_tibble()
         }, x = x)
  if (tolower(form[1]) == 'sf' && 'event' %in% what){
    # better would be to create the sf object and then filter/crop
    # but it feels like this is more explicit for dealing with weird 
    # locations
    ix <- grep("longitude", tolower(colnames(r$event)), fixed = TRUE)
    iy <- grep("latitude", tolower(colnames(r$event)), fixed = TRUE)
    is_na <- is.na(r$event[[ix]]) | is.na(r$event[[iy]]) 
    inside <- r$event[[ix]] >= -180 & r$event[[ix]] <= 180 &
      r$event[[iy]] >= -90 & r$event[[iy]] <= 90
    r$event <- sf::st_as_sf(r$event |> dplyr::filter(!is_na & inside), 
                            coords = c(ix[1],iy[1]), 
                            crs = 4326)
  }
  r
}


#' Read IODE haedat data in CSV form
#' 
#' @seealso \href{http://haedat.iode.org/eventSearch.php?listAll=1&sortby=name}{HAEDAT IODE}
#' @export
#' @param filename character, the name of the file to read
#' @param form charcater, one of 'tibble' or 'sf' specify the output class type
#' @return a tibble or sf object
read_haedat_iode <- function(filename = list_iode()[1],
                        form = c("tibble", "sf")[2]){
  
  x <- suppressWarnings(readr::read_csv(filename[1], 
                       guess_max = 3000,
                       col_types = readr::cols(
                         eventYear = readr::col_double(),
                         days = readr::col_double(),
                         months = readr::col_double(),
                         latitude = readr::col_double(),
                         longitude = readr::col_double(),
                         eventDate = readr::col_date(),
                         .default = readr::col_character())))
  
  if (tolower(form[1]) == "sf") {
    oklon <- !is.na(x$longitude)
    oklat <- !is.na(x$latitude)
    x <- x |>
      dplyr::filter(oklon & oklat) |>
      sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
  }
  
  x
}


#' Read haedat data from IODE or OBIS
#' 
#' @export
#' @param source character, one of 'iode' or 'obis'
#' @param ... other arguments passed to \code{\link{read_haedat_iode}} or \code{\link{read_haedat_obis}}
#' @return see \code{\link{read_haedat_iode}} or \code{\link{read_haedat_obis}}
read_haedat <- function(source = c("obis", "iode"), ...){
  switch(match.arg(source),
         "obis" = read_haedat_obis(...),
         "iode" = read_haedat_iode(...),
         stop("source not known:", source[1]))
}