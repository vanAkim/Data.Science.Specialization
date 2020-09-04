con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode

library(XML)
library(httr)

url <- "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(rawToChar(GET(url)$content), useInternalNodes = T)

xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@class='gsc_a_c']",xmlValue)


html2 = GET(url)
content2 = content(html2,as="text")
parsedHtml = htmlParse(content2, asText = T)
xpathSApply(parsedHtml, "//title", xmlValue)


pg1 = GET("https://httpbin.org/basic-auth/user/passwd")
pg1
pg2 = GET("https://httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
pg2


## APIs
myapp = oauth_app("twitter", key = "yourConsumerKeyHere", secret = "yourConsumerSecretHere")
sig = sign_oauth1.0(myapp, token = "yourTokenHere", token_secret = "yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)

json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]