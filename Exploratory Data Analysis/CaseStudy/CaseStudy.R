setwd('C:\\Users\\Akim Van Eersel\\R_Projects\\DataScienceSpecialization-JohnsHopkins\\Exploratory Data Analysis\\CaseStudy')

pm0 <- read.table("RD_501_88101_1999-0.txt", sep = "|", comment.char = "#", na.strings = "", header = FALSE)
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
cnames <- strsplit(cnames, "|", fixed = T)
names(pm0) <- make.names(cnames[[1]])


pm1 <- read.table("RD_501_88101_2012-0.txt", sep = "|", comment.char = "#", na.strings = "", header = FALSE)
cnames <- readLines("RD_501_88101_2012-0.txt", 1)
cnames <- strsplit(cnames, "|", fixed = T)
names(pm1) <- make.names(cnames[[1]])


summary(pm1$Sample.Value)
summary(pm0$Sample.Value)
