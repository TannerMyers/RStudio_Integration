
###############

# load packages

library(devtools)
library(spocc)
library(rgbif)
library(rvertnet)
library(maps)
library(ellipsenm) #devtools::install_github("marlonecobos/ellipsenm")
library(rgdal)
library(sp)
library(raster)
library(spThin)
library(dplyr)
library(purrr)
library(ggplot2)
library(ggmap)
library(httpgd)
library(tidyverse)

# Directories
working_dir <- getwd()
setwd(working_dir)

output_dir <- paste0(working_dir, "/GBIF")
dir.create(output_dir)

#-------------------------------------------------------------------------------

#----------------------------Downloading occurrences----------------------------
cyb <- spocc::occ("Anolis cybotes", limit = 100000)
gbif_occs <- cyb$gbif$data$Anolis_cybotes
head(gbif_occs)

## write gbif_occs to file to create a derived dataset – this gives us a citable DOI for the GBIF data we're using
write_csv(gbif_occs, "data/GBIF/Anolis_cybotes_GBIF_download.csv")

## saving initial data with various columns from GBIF
colnames(gbif_occs)
columns <- c("name", "longitude", "latitude", "issues", "scientificName", 
             "coordinateUncertaintyInMeters", "year", "month", "day", 
             "countryCode", "locality", "elevation")

occs <- gbif_occs[, columns]
