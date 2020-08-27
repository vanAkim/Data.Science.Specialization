rankall <- function(outcome, num){
      hos_df <- read.csv("Hospital-data-overview_ass3-wk4/data/outcome-of-care-measures.csv", colClasses = "character")
      hos_df <- hos_df[, c(2,7,11,17,23)]
      colnames(hos_df) <- c("Hospital name", "State", "heart attack", "heart failure", "pneumonia")
      
      if ( !(outcome %in% names(hos_df)) ){
            return( print("invalid outcome"))
      }
      
      filt <- is.na(as.numeric(hos_df[,outcome]))
      hos_df <- hos_df[!filt,]
      hos_df["Rank"] <- 1:length(hos_df$State)
      hos_df <- hos_df[order(hos_df$State),]
      ranked_df <- hos_df[0,]
      
      for (st in unique(hos_df$State)){
            bystate <- hos_df[hos_df$State == st,]
            bystate <- bystate[ order(as.numeric(bystate[,outcome]), bystate[,"Hospital name"]),]
            bystate["Rank"] <- 1:table(hos_df$State)[[st]]
            ranked_df[length(ranked_df$State)+1:length(bystate$State),] <- bystate
      }
      
      
      
      if (num == "best"){
            numf <- function() {1}
      } else if (num == "worst"){
            numf <- function() {max(ranked_df$Rank[ranked_df$State == st])}
      } else {
            numf <- function() {num}
      }
      
      result <- ranked_df[0,c("Hospital name", "State")]
      for (st in unique(hos_df$State)){
         if (numf() > table(hos_df$State)[[st]]){
            result[length(result$State)+1,] <- c(NA, st)
         } else {
            result[length(result$State)+1,] <- ranked_df[ranked_df$State == st & numf() == ranked_df[,"Rank"], c("Hospital name","State")]
         }
         
      }
      colnames(result) <- c("hospital", "state")
      result
}
