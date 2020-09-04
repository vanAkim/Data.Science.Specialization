setwd("C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data")

library(XML)
library(httr)

fileURL <- "https://www.w3schools.com/xml/simple.xml"
doc <- xmlParse(rawToChar(GET(fileURL)$content) )
rootNode <- xmlRoot(doc)

xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][[1]]

xpathSApply(rootNode,"//name",xmlValue)
xpathSApply(rootNode, "//price",xmlValue)
