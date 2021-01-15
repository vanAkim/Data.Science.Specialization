#===============================================================================
## NEXT WORD PREDICTION

#----
## Load ngrams dict
# ngrams_dict <- fread(file = "./data/dict_top3_minfreq2_234grams.csv")
ngrams_dict <- fread(file = "./data/dict_top3_minfreq3_234grams.csv")

setkeyv(ngrams_dict, c("num_gram", "last_wrt", "word_n1", "word_n2"))

## Prediction function
predict_nextword <- function(sentence){
      
      require(readr)
      require(dplyr)
      require(stringr)
      require(data.table)
      
      
      #====
      ## Clean sentence to predict
      to_pred <- sentence %>%
            str_to_lower() %>%
            str_trim() %>%
            str_remove_all("[_$&+,:;=?@#~{}|`\\<>.^*°()%!\\-\\[\\]/0-9]")
      
      n_words_wrt <- sapply(strsplit(to_pred, " "), length)
      words_wrt <- str_split(to_pred, " ", simplify = TRUE)
      
      
      #====
      result <- NULL
      # Search for matching bigrams
      if(n_words_wrt >= 1){
            one_match <- ngrams_dict[.(2, word(to_pred,-1)),
                                     .(num_gram, feature, frequency, pred_word)]
            result <- one_match
      }
      
      #----
      # Search for matching trigrams
      if(n_words_wrt >= 2){
            two_match <- ngrams_dict[.(3, word(to_pred,-1), word(to_pred,-2)),
                                     .(num_gram, feature, frequency, pred_word)]
            result <- rbind(two_match, result)
      }
      
      #----
      # Search for matching fourgrams
      if(n_words_wrt >= 3){
            three_match <- ngrams_dict[.(4, word(to_pred,-1), word(to_pred,-2), word(to_pred,-3)),
                                       .(num_gram, feature, frequency, pred_word)]
            result <- rbind(three_match, result)
      }
      
      #----
      # Remove missing values
      filt <- is.na(result$pred_word)
      result <- result[!filt,]
      
      #----
      if(is.null(result) || dim(result)[1] == 0){
            result <- ngrams_dict[.(2),
                                  .(num_gram, feature, frequency, pred_word)] %>%
                  setkeyv(c("frequency", "pred_word"))
            
            result <- result[,tail(.SD,1),
                             by=c("pred_word")] %>% 
                  setkeyv("frequency") %>% 
                  tail(3)
      }
      
      #====
      # Gather result
      top3 = arrange(result, num_gram, frequency) %>% 
            tail(3)
      
      rev(top3$pred_word) # from most to less frequent
}


#----
## Call the prediction function to get top 3 words
predict_nextword("May the force")


# Overall top-3 score:     18.53 %
# Overall top-1 precision: 14.01 %
# Overall top-3 precision: 22.57 %
# Average runtime:         10.03 msec
# Number of predictions:   28464
# Total memory used:       373.64 MB
# 
# Dataset details
# Dataset "blogs" (599 lines, 14587 words, hash 14b3c593e543eb8b2932cf00b646ed653e336897a03c82098b725e6e1f9b7aa2)
# Score: 18.42 %, Top-1 precision: 13.75 %, Top-3 precision: 22.69 %
# Dataset "tweets" (793 lines, 14071 words, hash 7fa3bf921c393fe7009bc60971b2bb8396414e7602bb4f409bed78c7192c30f4)
# Score: 18.65 %, Top-1 precision: 14.28 %, Top-3 precision: 22.45 %