setwd("C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data")

if (!file.exists("data")){
      dir.create("data")
}

## Communities 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/UScommunities_2006.csv", method = "auto")

commuData <- read.table("./data/UScommunities_2006.csv", header = TRUE, sep = ',')
# How many properties are worth $1,000,000 or more?
sum(commuData$VAL == 24, na.rm = TRUE)

# Using the data.table package, which will deliver the fastest user time? 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "./data/UScommunities_2006-2.csv", method = "auto")
library(data.table)
DT <- fread("./data/UScommunities_2006-2.csv")
system.time(DT[,mean(pwgtp15),by="SEX"])

system.time(tapply(DT$pwgt15, DT$SEX, mean))
system.time(sapply(split(DT$pwgt15, DT$SEX), mean))
system.time({mean(DT[DT$SEX==1,]$pwgtp15)
      mean(DT[DT$SEX==2,]$pwgtp15)})
system.time(mean(DT$pwgtp15,by=DT$SEX))


## Natural Gas Acquisition Program
library(xlsx)
GasData <- read.xlsx("./data/GasAcq.xlsx", header = TRUE, sheetIndex = 1, colClasses = "character")
dat <- GasData[18:23,7:15]
colnames(dat) <- c("Zip","CuCurent","PaCurrent","PoCurrent","Contact","Ext","Fax","email","Status") 
sum(as.numeric(dat$Zip)*as.numeric(dat$Ext),na.rm=T)


## Batltimore restaurant
library(XML)
library(httr)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml "
doc <- xmlParse(rawToChar(GET(fileURL)$content) )
rootNode <- xmlRoot(doc)
# How many restaurants have zipcode 21231? 
sum(xpathSApply(rootNode,"//zipcode",xmlValue) == "21231")
