setwd("C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data")

if (!file.exists("data")){
      dir.create("data")
}

## CSV file
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv", method = "curl")

cameraData <- read.table("./data/cameras.csv", header = TRUE, sep = ',')

## XLSX file with xlsx package and JAVA installed
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD&bom=true&format=true"
download.file(fileURL, destfile = "./data/camerasX.csv", method = "auto")

library(xlsx)
cameraData <- read.xlsx("./data/camerasX.csv", header = TRUE, sheetIndex = 1) # don't work cause .csv and baltimore gives only csv not xlsx


dateDownloaded <- date()

dateDownloaded
list.files("./data")

