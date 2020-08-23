pollutantmean <- function(directory, polluant, id =1:332){
    data <- data.frame()
    for (datafile_id in id){
        
        datafile_name <- paste(sprintf("%03d",datafile_id),'csv',sep = '.')     # Format file name: 1 to '001.csv'
        
        data <- rbind(data, read.csv(paste(directory,datafile_name,sep = '/')))
    }

    mean(data[,polluant], na.rm = TRUE)
    
}