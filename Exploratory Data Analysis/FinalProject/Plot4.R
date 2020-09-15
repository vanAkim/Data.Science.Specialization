library(dplyr)

# Load and store data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subset data to get only coal combustion sources
Coal.SSCcode <- as.character(SCC$SCC)[grep(".*(coal).*", tolower(SCC$EI.Sector))]
NEI.coal <- NEI[NEI$SCC %in% Coal.SSCcode,]

# Make handling data by year
NEI.coal <- transform(NEI.coal, year = factor(year))
data <- split(NEI.coal, NEI.coal$year)

# Analysis data through same source over years to enable comparison
consistentSource <- intersect(data[["1999"]]["SCC"],
                              data[["2002"]]["SCC"],
                              data[["2005"]]["SCC"],
                              data[["2008"]]["SCC"])
NEI.coal <- subset(NEI.coal, NEI.coal$SCC %in% consistentSource$SCC)


# Sum emission of all consistent sources for each year
totalEmission.source <- tapply(NEI.coal$Emissions, NEI.coal$year, sum)


# Plot and save total emission of all sources for each year
plot(levels(NEI.coal$year), totalEmission.source, ylim = c(0,7e5), 
     main = "Total PM2.5 emmissions from coal-combustion sources in the United States from 1999 to 2008",
     xlab = "Year", ylab = "Total Emission [in tons]",
     pch = 19, cex = 2, col = "#248699")

dev.copy(png, file="Plot4.png", width = 700, height = 700)
dev.off()
