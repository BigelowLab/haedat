#' extract a guess of the first year of even
#'
#' @export
#' @param x dwca list or table of events
#' @return the input with eventYear added
add_event_first_year <- function(x){
  eventYear <- event_first_year(x)
  if (inherits(x, "list") && "event" %in% names(x)){
    x$event <- dplyr::mutate(x$event, eventYear = eventYear)
  } else {
    x <- dplyr::mutate(x, eventYear = eventYear)
  }
  x
}

#' extract a guess of the first year of even
#'
#' @export
#' @param x dwca list or table of events
#' @return numeric guess of the first year of an event
event_first_year <- function(x){
  if (inherits(x, "list") && "event" %in% names(x)){
    x <- x$event
  }
  as.numeric(substring(x$eventDate, 1,4))
}