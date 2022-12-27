HAEDAT in R
================

Simple access to downloading and reading
[HAEDAT](https://ipt.iobis.org/hab/resource?r=haedat) data in R

### Requirements

- [R v4.1+](https://www.r-project.org/)

- [rlang](https://CRAN.R-project.org/package=rlang)

- [dplyr](https://CRAN.R-project.org/package=dplyr)

- [readr](https://CRAN.R-project.org/package=readr)

- [rappdirs](https://CRAN.R-project.org/package=rappdirs)

- [finch](https://CRAN.R-project.org/package=finch)

- [sf](https://CRAN.R-project.org/package=sf)

### Installation

``` r
remotes::install_github("BigelowLab/haedat")
```

### Initial Usage

#### Establish a root data directory

Please establish the storage directory with `haedat_root()`. You can
store data where ever you would like, but we suggest that you accept the
default and ignore of all of details and mayhem that ensue with custom
installations.

``` r
library(haedat)
haedat::haedat_root()
```

    ## [1] "~/Dropbox/data/haedat"

#### Fetch the data

The following will fetch and store the haedat data in DWCA format
(Darwin Core Archive) from
[OBIS](https://ipt.iobis.org/hab/resource?r=haedat). You only need to do
this occasionally as the data is updated online.

``` r
fetch_haedat(where = "obis")
```

You can also download the data as a single CSV from
[IODE](http://haedat.iode.org/advancedSearch.php). Like the DWCA, you
only need to refresh this occasionally.

``` r
fetch_haedat(where = "iode")
```

### List your data

Listings of locally stored data are returned in reverse sort order
(since the files are version named).

``` r
list_haedat(source = "obis")
```

    ## [1] "/Users/ben/Dropbox/data/haedat/dwca-haedat-v3.6.zip"
    ## [2] "/Users/ben/Dropbox/data/haedat/dwca-haedat-v3.2.zip"

``` r
list_haedat(source = "iode")
```

    ## [1] "/Users/ben/Dropbox/data/haedat/2022-12-27_haedat_search.csv"

``` r
list_haedat(source = "all")
```

    ## [1] "/Users/ben/Dropbox/data/haedat/dwca-haedat-v3.6.zip"        
    ## [2] "/Users/ben/Dropbox/data/haedat/dwca-haedat-v3.2.zip"        
    ## [3] "/Users/ben/Dropbox/data/haedat/2022-12-27_haedat_search.csv"

### Usage

### OBIS data as DWCA

Read the OBIS data into a list or three elements: `events`,
`occurrences` and `extendedmeasurementorfact`. Each of the tables has an
`id` which can be used for merging.

``` r
suppressPackageStartupMessages({
  library(haedat)
  library(dplyr)
  library(sf)
  library(maps)
})

obis <- read_haedat(source = "obis")
lapply(obis, head)
```

    ## $event
    ## Simple feature collection with 6 features and 10 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: -125.9 ymin: 44.67 xmax: -56.19 ymax: 50.55
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 6 × 11
    ##   id     eventID event…¹ event…² highe…³ country local…⁴ geode…⁵ coord…⁶ footp…⁷
    ##   <chr>  <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>     <dbl> <chr>  
    ## 1 HAEDA… HAEDAT… 1992    HAEDAT… Scotia… CANADA  "Halif… EPSG:4…  100000 ""     
    ## 2 HAEDA… HAEDAT… 1992    HAEDAT… Gulf R… CANADA  "Easte… EPSG:4…  100000 ""     
    ## 3 HAEDA… HAEDAT… 1992    HAEDAT… Gulf R… CANADA  "North… EPSG:4…  100000 ""     
    ## 4 HAEDA… HAEDAT… 1992    HAEDAT… Gulf R… CANADA  "Miram… EPSG:4…  100000 ""     
    ## 5 HAEDA… HAEDAT… 1987    HAEDAT… Pacifi… CANADA  "uknow… EPSG:4…  100000 ""     
    ## 6 HAEDA… HAEDAT… 1987    HAEDAT… Newfou… CANADA  "South… EPSG:4…  100000 ""     
    ## # … with 1 more variable: geometry <POINT [°]>, and abbreviated variable names
    ## #   ¹​eventDate, ²​eventRemarks, ³​higherGeography, ⁴​locality, ⁵​geodeticDatum,
    ## #   ⁶​coordinateUncertaintyInMeters, ⁷​footprintWKT
    ## 
    ## $occurrence
    ## # A tibble: 6 × 13
    ##   id     insti…¹ colle…² datas…³ basis…⁴ occur…⁵ occur…⁶ organ…⁷ organ…⁸ occur…⁹
    ##   <chr>  <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  
    ## 1 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      "30,00… "cells… present
    ## 2 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      ""      ""      present
    ## 3 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      ""      ""      present
    ## 4 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      ""      ""      present
    ## 5 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      ""      ""      present
    ## 6 HAEDA… IOC-UN… HAEDAT  HAEDAT  HumanO… HAEDAT… ""      ""      ""      present
    ## # … with 3 more variables: eventID <chr>, scientificNameID <chr>,
    ## #   scientificName <chr>, and abbreviated variable names ¹​institutionCode,
    ## #   ²​collectionCode, ³​datasetName, ⁴​basisOfRecord, ⁵​occurrenceID,
    ## #   ⁶​occurrenceRemarks, ⁷​organismQuantity, ⁸​organismQuantityType,
    ## #   ⁹​occurrenceStatus
    ## 
    ## $extendedmeasurementorfact
    ## # A tibble: 6 × 7
    ##   id                     occurrenceID    measu…¹ measu…² measu…³ measu…⁴ measu…⁵
    ##   <chr>                  <chr>           <chr>   <chr>   <chr>   <chr>   <chr>  
    ## 1 HAEDAT:CA-22:CA-92-002 HAEDAT:CA-22:C… abunda… http:/… 10,400  cells … http:/…
    ## 2 HAEDAT:CA-22:CA-92-003 HAEDAT:CA-22:C… abunda… http:/… 7,000   cells … http:/…
    ## 3 HAEDAT:CA-22:CA-97-001 HAEDAT:CA-22:C… abunda… http:/… 151,776 cells … http:/…
    ## 4 HAEDAT:NL-01:NL-89-001 HAEDAT:NL-01:N… abunda… http:/… 20-800  cells … http:/…
    ## 5 HAEDAT:NL-01:NL-89-002 HAEDAT:NL-01:N… abunda… http:/… 100 - … cells … http:/…
    ## 6 HAEDAT:NL-01:NL-89-003 HAEDAT:NL-01:N… abunda… http:/… 30-300  cells … http:/…
    ## # … with abbreviated variable names ¹​measurementType, ²​measurementTypeID,
    ## #   ³​measurementValue, ⁴​measurementUnit, ⁵​measurementUnitID

### event

Let’s take a look at the spatial distribution.

``` r
event <- obis$event
maps::map()
plot(sf::st_geometry(event),
     col = "orange",
     add = TRUE)
```

![](README_files/figure-gfm/plot_obis-1.png)<!-- -->

What about the distribution through time? Hmmm. The `eventDate` variable
is character which gives one that ‘oh, dear’ feeling. Let’s see about
how long the strings are; if they are all the same it should be easy to
convert to a usable Date or numeric class.

``` r
lens <- nchar(event$eventDate)
tlens <- table(lens)
tlens
```

    ## lens
    ##    4    7    8    9   10   15   16   17   19   20   21 
    ## 3324    6    3    4 6372   34    2   16    6    4 3599

Oh, nuts! What do some of the different lengths look like?

``` r
sapply(names(tlens),
       function(len){
         ix <- lens == as.numeric(len)
         sprintf("len=%s: %s", as.character(len),
                     paste(head(event$eventDate[ix]), collapse = ", "))
       })
```

    ##                                                                                                                                                  4 
    ##                                                                                                        "len=4: 1992, 1992, 1992, 1992, 1987, 1987" 
    ##                                                                                                                                                  7 
    ##                                                                                      "len=7: 1988-05, 88-8-18, 88-4-26, 88-5-26, 88-4-25, 88-7-22" 
    ##                                                                                                                                                  8 
    ##                                                                                                              "len=8: 88-07-28, 88-06-15, 2005-8-5" 
    ##                                                                                                                                                  9 
    ##                                                                                                "len=9: 2007-6-11, 2007-8-28, 2004-8-17, 2004-8-29" 
    ##                                                                                                                                                 10 
    ##                                                                   "len=10: 1991-10-31, 1991-09-27, 1991-06-25, 1991-07-21, 1992-07-21, 1992-05-19" 
    ##                                                                                                                                                 15 
    ##                                     "len=15: 2003-10/2003-10, 2003-09/2003-09, 2004-06/2004-12, 2004-07/2004-07, 2004-08/2004-08, 2004-08/2004-08" 
    ##                                                                                                                                                 16 
    ##                                                                                                       "len=16: 88-10-5/88-10-14, 88-07-13/88-12-6" 
    ##                                                                                                                                                 17 
    ##                         "len=17: 21-07-08/28-07-08, 88-05-16/88-05-17, 88-07-21/88-09-12, 88-06-02/88-07-07, 88-06-02/88-07-07, 88-06-02/88-07-07" 
    ##                                                                                                                                                 19 
    ##             "len=19: 004-02-18/004-03-02, 1988-8-23/1988-8-25, 1988-5-16/1988-5-17, 1988-6-24/1988-7-25, 1988-6-24/1988-7-25, 2011may24/2011may30" 
    ##                                                                                                                                                 20 
    ##                                                   "len=20: 2001/09/10/2001/0916, 2004/11/1/2004/11/07, 2007-06-29/2007-07-6, 2004-06-3/2004-06-16" 
    ##                                                                                                                                                 21 
    ## "len=21: 1990-06-01/1990-06-30, 1990-09-01/1990-09-30, 1992-06-02/1992-09-16, 1992-07-15/1992-07-16, 1995-06-01/1995-08-31, 1998-07-07/1998-08-10"

Groan.

Maybe we just take the one with 4-digits in the first four positions,
call that `eventYear` and drop what doesn’t convert.

``` r
event <- dplyr::mutate(event,
                       eventYear = as.numeric(substring(eventDate, 1,4))) |>
  dplyr::filter(!is.na(eventYear) & eventYear > 1990)
```

    ## Warning in mask$eval_all_mutate(quo): NAs introduced by coercion

``` r
hist(event$eventYear, main = "OBIS HAEDAT events since 1990",
     xlab = 'Year',
     breaks = seq(from = min(event$eventYear), to = max(event$eventYear)))
```

![](README_files/figure-gfm/eventYear_obis-1.png)<!-- -->

### IODE data as CSV

``` r
iode <- read_haedat(source = "iode")
glimpse(iode)
```

    ## Rows: 1,890
    ## Columns: 83
    ## $ eventName                   <chr> "ZAF-99-003", "ZAF-99-002", "ZAF-99-001", …
    ## $ eventYear                   <dbl> 1999, 1999, 1999, 1998, 1998, 1998, 1997, …
    ## $ region                      <chr> "West coast", "West coast", "West Coast", …
    ## $ originalGridCode            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ monitoringProgramme         <chr> "0", "1", "0", "0", "0", "0", "0", "0", "0…
    ## $ programmeName               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ occurredBefore              <chr> "1", "1", "1", "1", "1", "1", "NULL", "NUL…
    ## $ occurredBeforeText          <chr> "1994", NA, "Feb/March 1998", "1997", "Feb…
    ## $ waterDiscoloration          <chr> "1", "0", "1", "1", "1", "1", "1", "0", "0…
    ## $ highPhyto                   <chr> "1", "0", "1", "1", "1", "1", "1", "1", "0…
    ## $ seafoodToxin                <chr> "0", "1", "0", "0", "0", "0", "0", "1", "1…
    ## $ massMortal                  <chr> "1", "1", "0", "1", "0", "0", "1", "0", "0…
    ## $ foamMucil                   <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ otherEffect                 <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ otherEffectText             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "m…
    ## $ days                        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ months                      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ locationText                <chr> "Elands Bay", "Paternoster", "Saldanha Bay…
    ## $ additionalLocationInfo      <chr> NA, "Abalones were tested from St Helena B…
    ## $ eventDate                   <date> 1999-04-01, 1999-04-01, 1999-02-01, 1998-…
    ## $ initialDate                 <chr> "1999-04-01", NA, "1999-02-16", "1998-04-2…
    ## $ finalDate                   <chr> "1999-04-26", NA, "1999-03-04", "1998-05-0…
    ## $ quarantineStartDate         <chr> NA, NA, NA, NA, NA, NA, NA, "1997-12-01", …
    ## $ quarantineEndDate           <chr> NA, NA, NA, NA, NA, NA, NA, "1998-05-30", …
    ## $ additionalDateInfo          <chr> "The event lasted 25 days", NA, NA, "The e…
    ## $ causativeKnown              <chr> "1", "1", "1", "1", "1", "1", "0", "1", "1…
    ## $ pigmentAnalysisInfo         <chr> NA, NA, "7.29-13.65", NA, "5.33", "21.3-41…
    ## $ additionalAlgaeInfo         <chr> NA, NA, NA, NA, "Unidentified Chrysochromu…
    ## $ toxicityDetected            <chr> "0", "1", "0", "0", "0", "0", "0", "1", "1…
    ## $ toxicityRange               <chr> NA, "1609 \xb5g STX eq 100g", NA, NA, NA, …
    ## $ humansAffected              <chr> "1", "1", "0", "1", "0", "0", "1", "1", "1…
    ## $ fishAffected                <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ naturalFishAffected         <chr> "0", "0", "0", "0", "1", "0", "0", "0", "0…
    ## $ aquacultureFishAffected     <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ planktonicAffected          <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ benthicAffected             <chr> "1", "0", "0", "1", "0", "0", "1", "0", "0…
    ## $ shellfishAffected           <chr> "0", "1", "1", "0", "1", "1", "0", "1", "0…
    ## $ birdsAffected               <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ otherTerrestrialAffected    <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ aquaticMammalsAffected      <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0…
    ## $ seaweedAffected             <chr> "0", "0", "0", "0", "1", "0", "0", "0", "0…
    ## $ freshwater                  <chr> "0", NA, NA, "0", "0", NA, "0", "1", NA, N…
    ## $ effectsComments             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, "Marke…
    ## $ unexplainedToxicity         <chr> "NULL", "0", "0", "NULL", "0", "0", "NULL"…
    ## $ toxicityComments            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ transvectors                <chr> NA, NA, NA, NA, NA, NA, NA, "Mytilus merid…
    ## $ eventBiblio                 <chr> "30 t rock lobster walkout", "Pitcher G. C…
    ## $ syndromeText                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ active                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ created_at                  <chr> "2019-12-18 06:17:39", "2019-12-06 02:42:4…
    ## $ updated_at                  <chr> NA, NA, NA, NA, "2019-12-06 03:45:36", "20…
    ## $ checked_at                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ countryName                 <chr> "SOUTH AFRICA", "SOUTH AFRICA", "SOUTH AFR…
    ## $ syndromeName                <chr> NA, "PSP", "OTHER", NA, "OTHER", "OTHER", …
    ## $ speciesContaining           <chr> NA, "Alexandrium catenella", NA, NA, NA, N…
    ## $ additionalHarmfulEffectInfo <chr> NA, "large number of detached or paralyzed…
    ## $ toxinAssayComments          <chr> NA, "large number of detached or paralyzed…
    ## $ assaytype                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ concentration               <chr> NA, "LC-UV", NA, NA, NA, NA, NA, NA, NA, N…
    ## $ toxinType                   <chr> NA, "1609 \xb5g STX eq 100g", NA, NA, NA, …
    ## $ toxin                       <chr> NA, "Saxitoxins", NA, NA, NA, NA, NA, NA, …
    ## $ causativeSpeciesName0       <chr> "Alexandrium catenella", "Alexandrium cate…
    ## $ cellsPerLitre0              <chr> NA, NA, "4.06-8.41x10e8", NA, "0.24x10e8",…
    ## $ comments0                   <chr> NA, NA, "between 16 Feb and 4 March 1999",…
    ## $ additionalSpeciesName0      <chr> NA, NA, NA, NA, NA, NA, NA, NA, "Ceratium …
    ## $ additionalCellsPerLitre0    <chr> NA, NA, NA, NA, NA, NA, NA, NA, "20000000"…
    ## $ additionalComments0         <chr> NA, NA, NA, NA, NA, NA, NA, NA, "by April …
    ## $ causativeSpeciesName1       <chr> NA, NA, NA, "Ceratium lineatum", NA, NA, N…
    ## $ cellsPerLitre1              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ comments1                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ causativeSpeciesName2       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ cellsPerLitre2              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ comments2                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ causativeSpeciesName3       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ cellsPerLitre3              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ comments3                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ additionalSpeciesName1      <chr> NA, NA, NA, NA, NA, NA, NA, NA, "Dinophysi…
    ## $ additionalCellsPerLitre1    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ additionalComments1         <chr> NA, NA, NA, NA, NA, NA, NA, NA, "cells/L n…
    ## $ additionalSpeciesName2      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ additionalCellsPerLitre2    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ additionalComments2         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ geometry                    <POINT [°]> POINT (18.31667 32.3), POINT (17.883…

``` r
maps::map()
plot(sf::st_geometry(iode),
     col = "orange",
     add = TRUE)
```

![](README_files/figure-gfm/plot_iode-1.png)<!-- -->

``` r
hist(dplyr::filter(iode, !is.na(eventYear) & eventYear > 1990) |>
       dplyr::pull(eventYear), 
     main = "IODE HAEDAT events since 1990",
     xlab = 'Year',
     breaks = seq(from = 1990, to = max(iode$eventYear)))
```

![](README_files/figure-gfm/eventYear_iode-1.png)<!-- -->
