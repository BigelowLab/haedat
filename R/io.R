#' Read haedat data in DWCA form
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
read_haedat_dwca <- function(what = c("event","occurrence", "extendedmeasurementorfact"),
                        filename = list_dwca()[1],
                        form = c("tibble", "sf")[2]){
  
  what = match.arg(what, 
                   c("event","occurrence", "extendedmeasurementorfact"),
                   several.ok = TRUE)
  x <- finch::dwca_read(filename[1], read = TRUE)
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


#' Read haedat data in original form
#' 
#' @seealso \href{http://haedat.iode.org/eventSearch.php?listAll=1&sortby=name}{HAEDAT IODE}
#' @export
#' @param filename character, the name of the file to read
#' @param form charcater, one of 'tibble' or 'sf' specify the output class type
#' @return a tibble or sf object
read_haedat_original <- function(filename = haedat_path("haedat.csv"),
                        form = c("tibble", "sf")[2]){
  
  x <- readr::read_csv(filename[1],
    col_types = readr::cols(
      eventName = readr::col_character(),
      eventYear = readr::col_double(),
      region = readr::col_character(),
      originalGridCode = readr::col_character(),
      monitoringProgramme = readr::col_character(),
      programmeName = readr::col_character(),
      occurredBefore = readr::col_character(),
      occurredBeforeText = readr::col_character(),
      waterDiscoloration = readr::col_character(),
      highPhyto = readr::col_character(),
      seafoodToxin = readr::col_character(),
      massMortal = readr::col_character(),
      foamMucil = readr::col_character(),
      otherEffect = readr::col_character(),
      otherEffectText = readr::col_character(),
      days = readr::col_double(),
      months = readr::col_double(),
      locationText = readr::col_character(),
      latitude = readr::col_double(),
      longitude = readr::col_double(),
      additionalLocationInfo = readr::col_character(),
      eventDate = readr::col_date(),
      initialDate = readr::col_character(),
      finalDate = readr::col_character(),
      quarantineStartDate = readr::col_character(),
      quarantineEndDate = readr::col_character(),
      additionalDateInfo = readr::col_character(),
      causativeKnown = readr::col_character(),
      pigmentAnalysisInfo = readr::col_character(),
      additionalAlgaeInfo = readr::col_character(),
      toxicityDetected = readr::col_character(),
      toxicityRange = readr::col_character(),
      humansAffected = readr::col_character(),
      fishAffected = readr::col_character(),
      naturalFishAffected = readr::col_character(),
      aquacultureFishAffected = readr::col_character(),
      planktonicAffected = readr::col_character(),
      benthicAffected = readr::col_character(),
      shellfishAffected = readr::col_character(),
      birdsAffected = readr::col_character(),
      otherTerrestrialAffected = readr::col_character(),
      aquaticMammalsAffected = readr::col_character(),
      seaweedAffected = readr::col_character(),
      freshwater = readr::col_character(),
      effectsComments = readr::col_character(),
      unexplainedToxicity = readr::col_character(),
      toxicityComments = readr::col_character(),
      transvectors = readr::col_character(),
      eventBiblio = readr::col_character(),
      syndromeText = readr::col_character(),
      active = readr::col_character(),
      created_at = readr::col_character(),
      updated_at = readr::col_character(),
      checked_at = readr::col_character(),
      countryName = readr::col_character(),
      syndromeName = readr::col_character(),
      speciesContaining = readr::col_character(),
      additionalHarmfulEffectInfo = readr::col_character(),
      toxinAssayComments = readr::col_character(),
      assaytype = readr::col_character(),
      concentration = readr::col_character(),
      toxinType = readr::col_character(),
      toxin = readr::col_character(),
      causativeSpeciesName0 = readr::col_character(),
      cellsPerLitre0 = readr::col_character(),
      comments0 = readr::col_character(),
      additionalSpeciesName0 = readr::col_character(),
      additionalCellsPerLitre0 = readr::col_character(),
      additionalComments0 = readr::col_character(),
      causativeSpeciesName1 = readr::col_character(),
      cellsPerLitre1 = readr::col_character(),
      comments1 = readr::col_character(),
      causativeSpeciesName2 = readr::col_character(),
      cellsPerLitre2 = readr::col_character(),
      comments2 = readr::col_character(),
      causativeSpeciesName3 = readr::col_character(),
      cellsPerLitre3 = readr::col_character(),
      comments3 = readr::col_character(),
      additionalSpeciesName1 = readr::col_character(),
      additionalCellsPerLitre1 = readr::col_character(),
      additionalComments1 = readr::col_character(),
      additionalSpeciesName2 = readr::col_character(),
      additionalCellsPerLitre2 = readr::col_character(),
      additionalComments2 = readr::col_character()
    ))
  
  if (tolower(form[1]) == "sf") {
    x <- sf::st_as_sf(x, 
                      coords = c("longitude", "latitude"),
                      crs = 4326)
  }
  x
}


#' Read haedat data in original or DWCA form
#' 
#' @export
#' @param source character, one of 'orginal' or 'dwca'
#' @param ... other arguments passed to \code{\link{read_haedat_original}} or \code{\link{read_haedat_dwca}}
#' @return see \code{\link{read_haedat_original}} or \code{\link{read_haedat_dwca}}
read_haedat <- function(source = c("dwca", "original"), ...){
  switch(match.arg(source),
         "dwca" = read_haedat_dwca(...),
         "original" = read_haedat_original(...),
         stop("source not known:", source[1]))
}