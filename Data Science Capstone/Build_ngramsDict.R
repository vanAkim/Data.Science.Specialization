library(readr)
library(dplyr)
library(stringr)
library(quanteda)
library(tokenizers)
library(caret)
library(data.table)


#===============================================================================
# Set appropriate working directory with data files

if (!file.exists("data")){
      dir.create("data")
}

if (!file.exists("building-dict")){
   dir.create("building-dict")
}

if (!file.exists("./data/Coursera-SwiftKey.zip")){
      fileURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
      download.file(fileURL, destfile = "./data/Coursera-SwiftKey.zip")
}


if (!file.exists("./data/final")){
      library(zip)
      unzip("./data/Coursera-SwiftKey.zip", exdir = "./data")
} 


#----
# Read data

twitdata <- readLines("./data/final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
blogdata <- readLines("./data/final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
newsdata <- readLines("./data/final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
raw_texts <- c(twitdata, blogdata, newsdata)
rm(blogdata, twitdata, newsdata)

#===============================================================================
## Make ngrams and stored them in file step-by-step


#----
# Cleaning by removing punctuation characters as well as numbers
raw_trn <- raw_texts %>% str_to_lower() %>% str_trim() %>%
      str_remove_all("[_$&+,:;=?@#~{}|`'\\<>.^*°()%!\\-\\[\\]/0-9]")
rm(raw_texts)


#----
## Function: tokenization => ngrams => frequency table 
ngrams_freqTable <- function(textdata, ngram_min = 2L, ngram_max = 2L,
                             freq_trim = 1L, choosen_SW = character()){
   
   ## 1.81 mins with 2:6 ngrams and 0.1 of texts
   ## 1.91 mins with 2:4 ngrams and 0.1,0.2,0.2 of texts
   ## 2.51 mins with 2:5 ngrams and 0.1,0.2,0.2 of texts
   ## 3.52 mins with 2:6 ngrams and 0.1,0.2,0.2 of texts
   # train.tokens <- tokenize_ngrams(
   #    x = textdata,
   #    lowercase = TRUE,
   #    n = ngram_max,
   #    n_min = ngram_min,
   #    ngram_delim = " ",
   #    stopwords = choosen_SW,
   #    simplify = FALSE
   # ) %>% as.tokens()

   train.tokens <- tokens(
      textdata,
      what = "word",
      remove_punct = TRUE,
      remove_symbols = TRUE,
      remove_numbers = TRUE,
      remove_url = TRUE,
      remove_separators = TRUE,
      split_hyphens = FALSE,
      include_docvars = FALSE,
      padding = FALSE
   )
   ## keep only tokens that contain at least one letter
   train.tokens <- tokens_select(
      train.tokens,
      "[a-z]+",
      valuetype = "regex",
      selection = "keep",
      case_insensitive = TRUE)
   print("Tokenized. Next: ngrams")

   #----
   train.tokens <- tokens_ngrams(train.tokens,
                                 n = ngram_min:ngram_max,
                                 concatenator = " ")
   print("Ngrams created. Next: dfm")
   
   #----
   ## Bag-of-words model.
   train.tokens <- dfm(train.tokens, tolower = FALSE)
   print("Frequency matrix done. Next: freq table")
   
   #----
   ## Trying to eliminate some sparsity by removing rare ngrams (i.e. reducing col)
   train.tokens <- dfm_trim(train.tokens,
                            min_docfreq = freq_trim,
                            min_termfreq = freq_trim,
                            verbose = TRUE)
   
   #----
   ## Create a DF with cumulative freq for all ngrams
   train.tokens <- textstat_frequency(train.tokens)[,1:2] %>%
      as.data.table()
   
   train.tokens
}


#----
## 1st batch: 2grams with all words included
trn_sumdfm <- ngrams_freqTable(raw_trn, 2L, 2L, 2L)

.rs.restartR()


#----
## 2nd batch: 3grams with all words included
trn_sumdfm <- ngrams_freqTable(raw_trn, 3L, 3L, 2L)

## Save in a file the ngrams freq table
write_csv(x = trn_sumdfm, file = "./data/building-dict/trn_sumdfm_1.0_3.csv")

rm(trn_sumdfm)
.rs.restartR()


#----
## 3rd batches a & b: 4-grams with half the data

### Split data
set.seed(101)
part_ind <- createDataPartition(y = 1:length(raw_trn), p = 0.5, list=FALSE)


### Get the ngrams
trn_sumdfm <- ngrams_freqTable(raw_trn[part_ind], 4L, 4L, 1L)
write_csv(x = trn_sumdfm, file = "./data/building-dict/trn_sumdfm_0.5_4.csv")

trn_sumdfm <- ngrams_freqTable(raw_trn[-part_ind], 4L, 4L, 1L)
write_csv(x = trn_sumdfm, file = "./data/building-dict/trn_sumdfm_-0.5_4.csv")

rm(raw_trn, part_ind)


### Merge the results
add_merge = function(freqTab1, freqTab2){
   
   # Merge all values by full join
   comb <- full_join(freqTab1,freqTab2, by = "feature")
   
   # Change NA into 0
   filt <-  is.na(comb)
   comb[filt[,2],2] <- 0
   comb[filt[,3],3] <- 0
   rm(filt)
   
   # Add frequencies for ngrams
   comb[,frequency := (frequency.x + frequency.y)] 
   comb[,c(1,4)]
}

trn_sumdfm <- add_merge(fread(file = "./data/building-dict/trn_sumdfm_0.5_4.csv"),
                        fread(file = "./data/building-dict/trn_sumdfm_-0.5_4.csv"))

N_freq <- length(unique(trn_sumdfm$frequency))
setkeyv(trn_sumdfm, "frequency")
trn_sumdfm <- trn_sumdfm[.(unique(frequency)[2:N_freq]),]

write_csv(x = trn_sumdfm, file = "./data/building-dict/trn_sumdfm_1.0_4.csv")


#----
trn_sumdfm <- fread(file = "./data/building-dict/trn_sumdfm_1.0_2.csv") %>%
   rbind(fread(file = "./data/building-dict/trn_sumdfm_1.0_3.csv")) %>%
   rbind(fread(file = "./data/building-dict/trn_sumdfm_1.0_4.csv"))

write_csv(x = trn_sumdfm, file = "./data/building-dict/trn_sumdfm_1.0_234.csv")


#_______________________________________________________________________________
## LOAD ALL NGRAMS FILES

trn_sumdfm <- fread(file = "./data/building-dict/trn_sumdfm_1.0_234.csv")

# .rs.restartR()


#----
## Create a col indicating the numbers of grams in each row
trn_sumdfm[,num_gram := sapply(strsplit(feature, " "), length)]
setkeyv(trn_sumdfm, "num_gram")


#----
### Split ngrams into individual words each stored in a col

split_grams <- function(freqTab, nmbr_grams){
   
   colwords.names <- c("pred_word", "last_wrt", "word_n1", "word_n2")
   i <- nmbr_grams
   
   for(inames in 1:nmbr_grams){
      freqTab[.(nmbr_grams), 
              colwords.names[inames] := str_split(feature, pattern = " ", simplify = T)[,i]]
      i <- i - 1
   }
   
}

split_grams(trn_sumdfm, 2)
split_grams(trn_sumdfm, 3)
split_grams(trn_sumdfm, 4)

write_csv(x = trn_sumdfm, file = "./data/building-dict/final-dict_234.csv")


#----
## Remove some ngrams with same structure but different predicted word

## Get top 3 predictions for each different grams
setkeyv(trn_sumdfm, c("num_gram", "last_wrt", "word_n1", "word_n2", "frequency"))
trn_sumdfm_top3 <- trn_sumdfm[,tail(.SD,3), 
                              by=c("num_gram", "last_wrt", "word_n1", "word_n2")]


write_csv(x = trn_sumdfm_top3, file = "./data/final-pruned-dict_234.csv")