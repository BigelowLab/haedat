#' Fetch HAEDAT iOBIS data as DWCA using the specified URL
#'
#' @export
#' @param version character, version number
#' @param base_uri charcater, the base URI upon which to build query
#' @param save_file character, the filename to download to
#' @param ... other arguments for \code{\link[utils]{download.file}}
#' @return the output of \code{\link[utils]{download.file}}
fetch_haedat_obis <- function(version = "3.6",
      base_uri = "https://ipt.iobis.org/hab/archive.do",
      save_file = haedat_path(sprintf("dwca-haedat-v%s.zip", version[1])),
      ...){
  
  # IOC-UNESCO. The Harmful Algal Event Database (HAEDAT). Accessed via https://obis.org.
  # https://ipt.iobis.org/hab/resource?r=haedat
  # https://ipt.iobis.org/hab/archive.do?r=haedat&v=3.2
  filename = file.path(base_uri[1], sprintf("?r=haedat&v=%s", version[1]))
  download.file(filename, save_file[1], ...)
}


#' Hides the messy URI for the HAEDAT csv table behind a function
#' 
#' @return url for CSV download
haedat_iode_uri <- function(){
  paste0("http://haedat.iode.org/eventSearch.php?searchtext%5Bspecies%5D%5B0%5D%5B",
         "taxonomy%5D=0&searchtext%5Bspecies%5D%5B0%5D%5Bspecies%5D=0&searchtext%5B",
         "addspecies%5D%5B0%5D%5Btaxonomy%5D=0&searchtext%5Baddspecies%5D%5B0%5D%5B",
         "species%5D=0&searchtext%5Btoxins%5D%5B0%5D%5BtoxinTypes%5D=0&searchtext%5B",
         "toxins%5D%5B0%5D%5BtoxinDetails%5D=0&sortby=name&csv=1",
         collapse = "")
}

#' Fetch HAEDAT iOBIS data as DWCA using the specified URL
#'
#' @export
#' @param save_file character, the filename to download to
#' @param ... other arguments for \code{\link[utils]{download.file}}
#' @return the output of \code{\link[utils]{download.file}}
#' 
fetch_haedat_iode <- function(
    save_file = haedat_path(sprintf("%s_haedat_search.csv", format(Sys.Date(), "%Y-%m-%d"))),
                               ...){
 
  otime <- getOption("timeout")
  on.exit(options(timeout = otime))
  options(timeout = max(300, getOption("timeout")))
  download.file(haedat_iode_uri(), save_file[1], ...)
}



#' Fetch HAEDAT data as DWCA from iOBIS or CSV from HADAET directly
#' 
#' @export
#' @param where char, one of 'obis' or 'haedat'
#' @param ... other arguments
#' @return 0 for success, not-0 for failure
fetch_haedat <- function(where = c("obis", "iode")[1], ...){
  switch(tolower(where[1]),
         'obis' = fetch_haedat_obis(...),
         fetch_haedat_iode(...))
}
