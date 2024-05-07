library(ggplot2)

setwd("/home/vojta/KSU/CIS890/8_FEMA/Wrangled/")

bright1 <- "#E53F71"
bright2 <- "#F89F5B"

ihpData <- read.csv("IndividualsAndHouseholdsProgramValidRegistrations-Sample5000.csv")

# Incident Type
incidentTypeDf <- as.data.frame(prop.table(table(ihpData$incidentType)))
ggplot(incidentTypeDf, aes(x = reorder(Var1, Freq, decreasing = T), y = Freq)) +
  geom_bar(stat = "identity", fill = bright1) +
  labs(x = "Incident type", y = "Density") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 1))

# Applicant Age
applicantAgeTable <- table(ihpData$applicantAge) / length(ihpData$applicantAge)
names(applicantAgeTable)[1] <- "unknown"
applicantAgeTable <- c(applicantAgeTable[-1], applicantAgeTable[1])
barplot(applicantAgeTable, ylim = c(0, 1), xlab = "Applicant age", ylab = "Density", col = bright1)

# Household Composition
householdCompositionTable <- table(ihpData$householdComposition) / length(ihpData$householdComposition)
householdCompositionTable <- c(householdCompositionTable[-1], householdCompositionTable[1])
barplot(householdCompositionTable, ylim = c(0, 1), xlab = "Household composition", ylab = "Density", col = bright1)

# Gross Income
grossIncomeDf <- as.data.frame(prop.table(table(ihpData$grossIncome)))
incomeOrder <- c("0", "<$15,000", "$15,000-$30,000", "$30,001-$60,000", "$60,001-$120,000", "$120,001-$175,000", ">$175,000")
grossIncomeDf <- grossIncomeDf[match(incomeOrder, grossIncomeDf$Var1),]
grossIncomeDf$Var1 <- factor(grossIncomeDf$Var1, levels = unique(grossIncomeDf$Var1))
ggplot(grossIncomeDf, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity", fill = bright1) +
  labs(x = "Gross income", y = "Density") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 1))

# Owner / Renter
ownRentTable <- table(ihpData$ownRent) / length(ihpData$ownRent)
barplot(ownRentTable, ylim = c(0, 1), xlab = "Applicant status", ylab = "Density", col = bright1)

# IHP Eligibility - irrelevant, chosen to be 1:1

# IHP Amount
hist(ihpData$ihpAmount, xlim = c(0, 20000), ylim = c(0, 0.0005), freq = F, main = NULL, xlab = "IHP assistance given", col = bright2)

# RPFVL
hist(ihpData$rpfvl, xlim = c(0, 20000), ylim = c(0, 0.0005), breaks = 160, freq = F, main = NULL, xlab = "Real property damage", col = bright2)

# PPFVL
hist(ihpData$ppfvl, xlim = c(0, 20000), ylim = c(0, 0.0005), breaks = 40, freq = F, main = NULL, xlab = "Personal property damage", col = bright2)

