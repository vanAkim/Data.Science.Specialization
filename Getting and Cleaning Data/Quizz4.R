# Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\comu2006_quizz4.csv"
download.file(url = url, destfile = path)
data <- read.csv(path)

strsplit(names(data), "wgtp")[123]


# Question 2
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\domprod_quizz4.csv"
download.file(url = url, destfile = path)
data <- read.csv(path,skip = 3)

mean(as.numeric(gsub(",", "", data[1:217,5])), na.rm = T)

# Question 3
grep("^United", data[,4])


# Question 4
gross_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edu_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
gross_path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\domesticProduct_quizz4.csv"
edu_path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\educational_quizz4.csv"
download.file(gross_url, gross_path)
download.file(edu_url, edu_path)
domProd <- read.csv(gross_path, skip = 3)
edu <- read.csv(edu_path)
# ----
mergedData <- merge(domProd, edu, by.x = "X", by.y = "CountryCode")

notesData <- mergedData[mergedData$Special.Notes != "",]
length(grep("([Ff]iscal year end)(.*)[Jj]une", notesData$Special.Notes))


# Question 5
library(quantmod)
library(lubridate)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

length(grep("2012", sampleTimes))

twotwelve = sampleTimes[grep("2012", sampleTimes)]
length(grep("Mon", wday(twotwelve, label=T)))
