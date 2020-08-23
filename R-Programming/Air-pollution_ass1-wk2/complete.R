complete <- function(directory, id= 1:332){
    data <- data.frame()
    for (datafile_id in id){
        
        datafile_name <- paste(sprintf("%03d",datafile_id),'csv',sep = '.')  # Format file name: 1 to '001.csv'
        datafile_df <- read.csv(paste(directory,datafile_name,sep = '/'))
        
        
        nobs <- nrow(datafile_df[complete.cases(datafile_df),])
        
        data <- rbind(data, data.frame(datafile_id,nobs))
        
    }
    colnames(data) <- c("id","nobs")
    data
}