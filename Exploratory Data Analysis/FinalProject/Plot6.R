library(dplyr)
library(ggplot2)

# Load and store data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subset data to get only Baltimore City and LA
NEI <- subset(NEI, fips == "24510" | fips == "06037")

# Subset data to get only motor vehicle sources
motorSource <- as.character(SCC$SCC)[grep(".*(mobile).*", tolower(SCC$EI.Sector))]
NEI <- subset(NEI, SCC %in% motorSource)

# Make handling data by year
NEI.perYear <- transform(NEI, year = factor(year), fips = factor(fips))
data <- split(NEI.perYear, NEI.perYear$year)

# Analysis data through same source over years to enable comparison
consistentSource <- intersect(data[["1999"]]["SCC"], 
                              data[["2002"]]["SCC"], 
                              data[["2005"]]["SCC"], 
                              data[["2008"]]["SCC"])
NEI.perYear.source <- subset(NEI.perYear, NEI.perYear$SCC %in% consistentSource$SCC)


# Sum emission of all consistent sources for each year and each city.
totalEmissions.yearCity <- tapply(NEI.perYear.source$Emissions,
                                  paste(NEI.perYear.source$year, NEI.perYear.source$fips),
                                  sum)

# Store in a vector the different years and cities
years <- sapply(strsplit(names(totalEmissions.yearCity), split = " "), function(firstcol) firstcol[1])
fips <- sapply(strsplit(names(totalEmissions.yearCity), split = " "), function(secondcol) secondcol[2])
City <- factor(fips, labels = c("Los Angeles", "Baltimore City"))

# Aggregate variable vectors in a dataframe
plotdf <- data.frame(Emissions = totalEmissions.yearCity, years = years, City = City)
rownames(plotdf) <- c(1:length(totalEmissions.yearCity))


# Plot and save total emission of motor vehicle sources for each year and cities
qplot(years, Emissions, data = plotdf, color = City) + geom_point(pch = 19, cex = 4) + labs(title = "Total PM2.5 emmissions in LA and Baltimore from 1999 to 2008 from vehicle motor sources")

dev.copy(png, file="Plot6.png", width = 600, height = 600)
dev.off()
