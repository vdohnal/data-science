library(dplyr)
library(factoextra)
library(cluster)

#define function to calculate mode
mode <- function(codes){
  which.max(tabulate(codes))
}

setwd("/home/vojta/KSU/CIS890/8_FEMA/Wrangled/")
disasters <- read.csv("DisasterDeclarationsSummaries.csv")

# get rid of missing values
disasters <- subset(disasters, select = -c(disasterCloseoutDate, lastIAFilingDate))
disasters[disasters == ""] <- NA
disasters <- na.omit(disasters)

# filter out disasters with too few instances
incidentTypes <- as.data.frame(table(disasters$incidentType))
incidentTypes <- subset(incidentTypes, Freq > 500)
disasters <- subset(disasters, incidentType %in% incidentTypes$Var1)

# convert date columns
dateCols <- c("declarationDate", "incidentBeginDate", "incidentEndDate", "lastRefresh")
disasters <- disasters %>% mutate_at(dateCols, as.Date) %>% mutate_at(dateCols, as.numeric)
disasters$duration <- disasters$incidentEndDate - disasters$incidentBeginDate

disasterSum <- disasters %>% group_by(incidentType) %>% summarize(
  mean(declarationDate),
  mean(duration),
  mean(ihProgramDeclared),
  mean(iaProgramDeclared),
  mean(paProgramDeclared),
  mean(hmProgramDeclared),
  mean(tribalRequest),
  mode(fipsStateCode),
  mode(fipsCountyCode),
  mode(placeCode),
  mean(lastRefresh)
)
disasterSum <- as.data.frame(disasterSum)

# scale the values
rownames(disasterSum) <- disasterSum$incidentType
disasterSum$incidentType <- NULL
disasterSumScaled <- scale(disasterSum)

# get the optimal number of clusters
fviz_nbclust(disasterSumScaled, kmeans, method = "wss", k.max = 8)

# cluster and visualize
km <- kmeans(disasterSumScaled, centers = 4, nstart = 25)
fviz_cluster(km, data = disasterSumScaled, main = "Disaster Clusters")