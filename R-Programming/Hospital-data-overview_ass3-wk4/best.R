setwd(paste(getwd(), "Hospital-data-overview_ass3-wk4", sep = '/'))
outcome <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")

head(outcome)
str(outcome)
dim(outcome)
names(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])

best <- function(state, outcome){
      hos_df <- read.csv("Hospital-data-overview_ass3-wk4/data/outcome-of-care-measures.csv", colClasses = "character")
      hos_df <- hos_df[, c(2,7,11,17,23)]
      colnames(hos_df) <- c("Hospital name", "State", "heart attack", "heart failure", "pneumonia")
      
      if ( !(outcome %in% names(hos_df)) ){
            return( print("invalid outcome"))
      }
      if (!(state %in% unique(hos_df$State))){
            return((print("invalid state")))
      }
      
      filt <- is.na(as.numeric(hos_df[,outcome]))
      state_df <- hos_df[!filt & hos_df$State == state,]

      result <- state_df[which(min(as.numeric(state_df[,outcome])) == as.numeric(state_df[,outcome])), "Hospital name"]
      
      if (length(result) > 1){
         return(sort(result)[1])
      }
      result
}
