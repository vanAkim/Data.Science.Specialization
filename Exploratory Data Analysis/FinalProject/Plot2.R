library(dplyr)

# Load and store data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subset data to get only Baltimore City
NEI <- subset(NEI, fips  == "24510")

# Make handling data by year
NEI.perYear <- transform(NEI, year = factor(year))
data <- split(NEI.perYear, NEI.perYear$year)

# Analysis data through same source over years to enable comparison
consistentSource <- intersect(data[["1999"]]["SCC"], 
                              data[["2002"]]["SCC"], 
                              data[["2005"]]["SCC"], 
                              data[["2008"]]["SCC"])
NEI.perYear.source <- subset(NEI.perYear, NEI.perYear$SCC %in% consistentSource$SCC)


# Sum emission of all consistent sources for each year
totalEmission.source <- tapply(NEI.perYear.source$Emissions, NEI.perYear.source$year, sum)


# Plot and save total emission of all sources for each year
plot(levels(NEI.perYear.source$year), totalEmission.source, ylim = c(0,4e3), 
     main = "Total emmissions from PM2.5 in Baltimore CIty from 1999 to 2008",
     xlab = "Year", ylab = "Total Emission [in tons]",
     pch = 19, cex = 2, col = "#248699")

dev.copy(png, file="Plot2.png", width = 600, height = 600)
dev.off()
