rankhospital <- function(state, outcome, num){
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
      state_df <- state_df[order(state_df[,"Hospital name"]),]
      state_df <- state_df[ order(as.numeric(state_df[,outcome])),]
      state_df["Rank"] <- 1:length(state_df$State)
      
      
      if (num == "best"){
            num <- 1
      }
      if (num == "worst"){
            num <- max(state_df[,"Rank"])
      }
      if (num > max(state_df[,"Rank"])){
            return(NA)
      }
      state_df[num == state_df[,"Rank"], "Hospital name"]
}
