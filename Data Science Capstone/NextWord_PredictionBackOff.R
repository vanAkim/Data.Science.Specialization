#===============================================================================
## NEXT WORD PREDICTION

## Prediction function
predict_nextword <- function(sentence){
      
      require(readr)
      require(dplyr)
      require(stringr)
      require(data.table)
      
      #----
      ## Load ngrams dict
      ngrams_dict <- fread(file = "./data/final-pruned-dict_234.csv")
      
      setkeyv(ngrams_dict, c( "num_gram", "last_wrt", "word_n1", "word_n2"))
      
      
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
      if(is.null(result)){
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
predict_nextword("You shall not")
