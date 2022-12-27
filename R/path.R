#' Create or retrieve the root data directory
#' 
#' First search for ~/.haedat which may contain the desired path
#' If absent search for rappdirs::user_data_dir("haedat")
#' If absent search for rappdirs::site_data_dir("haedat")
#' If absent create the path specified by new_dir argument
#' 
#' If you want to specify a non-rappdirs standard path, then create a
#' ~/.haedat file with one line specifying the desired data path. You must
#' create this path yourself.
#' 
#' @export
#' @param new_dir char, used to create a new directory the first time this is
#'   run
#' @return the root data path
haedat_root <- function(new_dir = rappdirs::user_data_dir("haedat")){
  if (file.exists("~/.haedat")){
    root <- readLines("~/.haedat")
  } else if(dir.exists(rappdirs::user_data_dir("haedat"))){
    root <- rappdirs::user_data_dir("haedat")
  } else if (dir.exists(rappdirs::site_data_dir("haedat"))){
    root <- rappdirs::site_data_dir("haedat")
  } else {
    ok <- dir.create(new_dir[1], recursive = TRUE)
    root <- new_dir[1]
  }
  root
}

#' Retrieve the haedat data path
#' 
#' @export
#' @param ... char, path segments
#' @param root char, the root directory specification
#' @param create logical, if TRUE create the path if it doesn't exist
#' @return path specification, possibly untested for existence
haedat_path <- function(..., 
                          root = haedat_root(), 
                          create = FALSE){
  path <- file.path(root[1], ...)
  if (create[1]){
    if (!dir.exists(path[1])) ok <- dir.create(path[1], recursive = TRUE)
  }
  path
}


#' List files/directories in the haedat root directory
#' 
#' This is a wrapper around \code{\link[base]{list.files}}
#' @export
#' @param path char, the path to list
#' @return character vector
list_haedat <- function(source = c("obis", "iode"), 
                        path = haedat_path(), ...){
  switch(source[1],
         "obis" = list_obis(path = path),
         "iode" = list_iode(path = path),
         c(list_obis(path = path), list_iode(path = path))) # all
}

#' List IODE CSV resources, in order of most recent to oldest
#' 
#' @export
#' @param path char, the path to list
#' @return character vector of full filenames ordered by verion
list_iode <- function(path = haedat_path()){
  list.files(path, pattern = "^.*haedat_search\\.csv$", full.names = TRUE) |>
    sort(decreasing = TRUE)
}

#' List OBIS DWCA resources, in order of most recent to oldest
#' 
#' @export
#' @param path char, the path to list
#' @return character vector of full filenames ordered by verion
list_obis <- function(path = haedat_path()){
  list.files(path, pattern = "^dwca-haedat-.*\\.zip$", full.names = TRUE) |>
    sort(decreasing = TRUE)
}
