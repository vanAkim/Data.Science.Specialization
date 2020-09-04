url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\comu2006_quizz3.csv"
download.file(url = url, destfile = path)
data <- read.csv(path)
agricultureLogical <- data$ACR == 3 & data$AGS == 6

which(agricultureLogical) 


# Question 2
library(jpeg)
path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\img_quizz3.jpg"
data <- readJPEG(path, native = TRUE)

quantile(data, probs = c(.3,0.8))


# Question 3 4 5
library(dplyr)
library(Hmisc)
gross_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edu_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
gross_path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\domesticProduct_quizz3.csv"
edu_path = "C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\educational_quizz3.csv"
download.file(gross_url, gross_path)
download.file(edu_url, edu_path)
domProd <- read.csv(gross_path, skip = 3)
edu <- read.csv(edu_path)
# ----
mergedData <- merge(domProd, edu, by.x = "X", by.y = "CountryCode")
mergedData <- mergedData[mergedData$Ranking != "",]
sortedData <- arrange(mergedData, desc(as.numeric(Ranking)))

length(unique(mergedData$Ranking))
sortedData[13, "Economy"]

income_group <- sortedData %>% group_by(Income.Group)
income_group %>% summarize(mean(as.numeric(Ranking), na.rm = T))
 
cutedData <- sortedData %>% mutate(qrank = cut2(as.numeric(sortedData$Ranking), g = 5)) %>% group_by(qrank) %>% select(X, Ranking, Economy, Income.Group, qrank)
length(cutedData[cutedData$qrank == "[  1, 39)" & cutedData$Income.Group == "Lower middle income", ])
