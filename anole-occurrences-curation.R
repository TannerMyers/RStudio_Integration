
# Code obtained and modified from https://github.com/townpeterson/vespa/tree/master/Rcode


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
write_csv(gbif_occs, "GBIF/Anolis_cybotes_GBIF_download.csv")

## saving initial data with various columns from GBIF
colnames(gbif_occs)
columns <- c("name", "longitude", "latitude", "issues", "scientificName", 
             "coordinateUncertaintyInMeters", "year", "month", "day", 
             "countryCode", "locality", "elevation")

occs <- gbif_occs[, columns]

# Plot occurrence points
hispaniola <- map_data("world")%>%subset(region == c("Haiti", "Dominican Republic"))
ggplot() +
  geom_polygon(data=hispaniola, aes(x=long, y=lat, group=group), color='lightgrey', fill=NA) +
  geom_point(data=occs, aes(x=longitude, y=latitude), shape=1, size=2, alpha=0.85, color="green") + 
  coord_fixed(xlim=c(-75,-67.5), ylim=c(17,20), ratio=1.3) + theme_nothing()

#---------------------------------------------------------------------------------

#--------------------- Data cleaning ---------------------------------------------
## subset columns of interest
occ <- occs[, c("scientificName", "longitude", "latitude")]
occ <- na.omit(occ) # exclude NAs here after reducing number of fields in dataframe

## excluding 0, 0 coordinates 
occ <- occ[occ$longitude != 0 & occ$latitude != 0, ]

## excluding duplicates
occ <- occ[!duplicated(paste(occ$longitude, occ$latitude)), ]

maps::map()
points(occ[, 2:3], col = "red", pch = 19)
axis(side = 2)
axis(side =1)

# excluding records outside Caribbean
occ <- occ[occ$longitude < 0,]
occ <- occ[occ$latitude < 30,]

maps::map(xlim=c(-100,-60),ylim=c(-0,30), interior=TRUE)
points(occ[, 2:3], col = "red", pch = 19)
axis(side=2)
axis(side=1)

write.csv(occ, paste0(output_dir, "/A_cybotes_clean.csv"), row.names=FALSE)
