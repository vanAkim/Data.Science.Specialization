library(dplyr)
library(ggplot2)

# Load and store data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset data to get only Baltimore City
NEI <- subset(NEI, fips  == "24510")

# Make handling data by year
NEI.perYear <- transform(NEI, year = factor(year), type = factor(type))
data <- split(NEI.perYear, NEI.perYear$year)

# Analysis data through same source over years to enable comparison
consistentSource <- intersect(data[["1999"]]["SCC"], 
                              data[["2002"]]["SCC"], 
                              data[["2005"]]["SCC"], 
                              data[["2008"]]["SCC"])
NEI.perYear.source <- subset(NEI.perYear[4:6], NEI.perYear$SCC %in% consistentSource$SCC)

# Sum emission of all consistent sources for each year and each type.
totalEmissions.yearType <- tapply(NEI.perYear.source$Emissions,
                                  paste(NEI.perYear.source$year, NEI.perYear.source$type),
                                  sum)

# Store in a vector the different years and types
years <- sapply(strsplit(names(totalEmissions.yearType), split = " "), function(firstcol) firstcol[1])
types <- sapply(strsplit(names(totalEmissions.yearType), split = " "), function(secondcol) secondcol[2])

# Aggregate variable vectors in a dataframe
plotdf <- data.frame(Emissions = totalEmissions.yearType, years = years, types = types)
rownames(plotdf) <- c(1:length(totalEmissions.yearType))

# Plot and save total emission of all sources for each year
g <- ggplot(plotdf, aes(years, totalEmissions.yearType))
g + geom_point(pch = 19, cex = 4, col = "#248699") + facet_wrap(.~types, scales = "free") + labs(title = "Total PM2.5 emmissions in Baltimore City from 1999 to 2008 from different sources",
                                                                                                 x = "Years", y = "Total Emission [in tons]")

dev.copy(png, file="Plot3.png", width = 600, height = 600)
dev.off()
