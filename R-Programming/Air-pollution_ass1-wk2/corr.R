corr <- function(directory, thresold = 0){
    data <- data.frame()
    cor_vec <- vector()
    for (id in 1:332){
        
        datafile_name <- paste(sprintf("%03d",id),'csv',sep = '.')   # Format file name: 1 to '001.csv'
        
        data <- read.csv(paste(directory,datafile_name,sep = '/'))
        data <- data[complete.cases(data),]                          # Remove NAs
        
        if (nrow(data) > thresold){
            cor_vec <- c(cor_vec, cor(data[,2],data[,3]))
        }
    }
    cor_vec
    
}