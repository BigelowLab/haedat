#' Fetch HAEDAT data using the specified URL
#'
#' @export
#' @param x character, URL defining resource to download
#' @param save_file character, the filename to download to
#' @param ... other arguments for \code{\link[utils]{download.file}}
#' @return the output of \code{\link[utils]{download.file}}
fetch_haedat <- function(x = "https://ipt.iobis.org/hab/archive.do?r=haedat&v=3.2",
                         save_file = haedat_path("dwca-haedat-v3.2.zip"),
    #x="http://haedat.iode.org/eventSearch.php?listAll=1&sortby=name&csv=1",
    #save_file = c(tempfile(), haedat_path("haedat.csv"))[2],
                         ...){
  
  # IOC-UNESCO. The Harmful Algal Event Database (HAEDAT). Accessed via https://obis.org.
  # https://ipt.iobis.org/hab/resource?r=haedat
  # https://ipt.iobis.org/hab/archive.do?r=haedat&v=3.2
  download.file(x[1], save_file[1], ...)
}
