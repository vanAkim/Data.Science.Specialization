# setwd correctly before use

if (!file.exists("data")){
      dir.create("data")
}

if (!file.exists("./data/Coursera-SwiftKey.zip")){
      fileURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
      download.file(fileURL, destfile = "./data/Coursera-SwiftKey.zip")
}


if (!file.exists("./data/final")){
      library(zip)
      unzip("./data/Coursera-SwiftKey.zip", exdir = "./data")
} 


# Quizz 1

# The en_US.blogs.txt file is how many megabytes?
file.info("./data/final/en_US/en_US.blogs.txt")$size/1e6

# The en_US.twitter.txt has how many lines of text?
twitdata <- readLines("./data/final/en_US/en_US.twitter.txt")
length(twitdata)/1e6

# What is the length of the longest line seen in any of the three en_US data sets?
blogdata <- readLines("./data/final/en_US/en_US.blogs.txt")
newsdata <- readLines("./data/final/en_US/en_US.news.txt")

max(nchar(twitdata))
max(nchar(blogdata))
max(nchar(newsdata))

# In the en_US twitter data set, if you divide the number of lines where the word "love"
# (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
sum(grepl(twitdata, pattern = "(love)")) / sum(grepl(twitdata, pattern = "(hate)"))

# The one tweet in the en_US twitter data set that matches the word "biostats" says what?
grep(twitdata, pattern = "(biostats)", value = T)

# How many tweets have the exact characters 
# "A computer once beat me at chess, but it was no match for me at kickboxing".
# (I.e. the line matches those characters exactly.)
grep(twitdata, pattern = "A computer once beat me at chess, but it was no match for me at kickboxing")


#===============================================================================

# ETL

library(quanteda)
library(caret)

## Split data into test/train data sets
inTrain <- createDataPartition(y = 1:length(blogdata), p = 0.15, list=FALSE)

train <- blogdata[inTrain]
test <- blogdata[-inTrain]


#----
## Tokenization
train.tokens <- tokens(train, what = "word", 
                       remove_numbers = TRUE, remove_punct = TRUE,
                       remove_symbols = TRUE, split_hyphens = TRUE)


#----
## Data cleaning

### Set tokens to lower case
train.tokens <- tokens_tolower(train.tokens)

### Stop words removal
train.tokens <- tokens_select(train.tokens, stopwords(), 
                              selection = "remove")


#----
## Perform stemming on the tokens.
train.tokens <- tokens_wordstem(train.tokens, language = "english")


#----
## Adding N-grams: here unigrams and bigrams
train.tokens <- tokens_ngrams(train.tokens, n = 1:2)


#----
## Bag-of-words model.
train.tokens.dfm <- dfm(train.tokens, tolower = FALSE)
train.tokens.dfm
sparsity(train.tokens.dfm)


#----
## Trying to eliminate some sparsity
train.tokens.dfm <- dfm_trim(train.tokens.dfm, min_docfreq = 100, min_termfreq = 20, verbose = TRUE)


#----
## Transform to a matrix and inspect.
train.tokens.matrix <- convert(train.tokens.dfm, to = "data.frame")


#----
## TF-IDF
train.tokens.tfidf <- dfm_tfidf(train.tokens.dfm)
train.tfidf.matrix <- convert(train.tokens.dfm, to = "data.frame")

# Our function for calculating relative term frequency (TF)
term.frequency <- function(row) {
   row / sum(row)
}

# Our function for calculating inverse document frequency (IDF)
inverse.doc.freq <- function(col) {
   corpus.size <- length(col)
   doc.count <- length(which(col > 0))
   
   log10(corpus.size / doc.count)
}

# Our function for calculating TF-IDF.
tf.idf <- function(x, idf) {
   x * idf
}


# First step, normalize all documents via TF.
train.tokens.df <- apply(train.tokens.matrix, 1, term.frequency)
dim(train.tokens.df)
View(train.tokens.df[1:20, 1:100])


# Second step, calculate the IDF vector that we will use - both
# for training data and for test data!
train.tokens.idf <- apply(train.tokens.matrix, 2, inverse.doc.freq)
str(train.tokens.idf)


# Lastly, calculate TF-IDF for our training corpus.
train.tokens.tfidf <-  apply(train.tokens.df, 2, tf.idf, idf = train.tokens.idf)
dim(train.tokens.tfidf)
View(train.tokens.tfidf[1:25, 1:25])
