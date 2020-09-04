## Github

library(httr)
library(httpuv)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "97a1c9f63753599ebb33",
                   secret = "dd6149123b6a84301939357aa70e582e8c37e258"
)

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)

json1 = content(req)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[json2$name == "datasharing","created_at"]


## SQL
library(sqldf)

acs = read.csv("C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\getdata_data_ss06pid.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")
sqldf("select distinct AGEP from acs")


## HTML
library(XML)
library(httr)

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])


## Fixed width file format : .for
wind = read.fwf("C:\\Users\\Akim Van Eersel\\R_Projects\\Data_Science_Specialization-John_Hopkins\\Getting and Cleaning Data\\data\\getdata_wksst8110.for", widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)

sum(c(wind[,4],wind[,9]))
sum(wind[,4] + wind[,9])
