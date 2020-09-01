library(XML)
library(httr)

fileURL <- "https://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlParse(rawToChar(GET(fileURL)$content))
scores <- xpathSApply(doc,"//div[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//div[@class='game-info']",xmlValue)
scores
teams
