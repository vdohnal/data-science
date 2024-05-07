library(ggplot2)

setwd("/home/vojta/KSU/CIS890/8_FEMA/Wrangled/")

dark1 <- "#3F1651"
middle <- "#9C3587"
bright1 <- "#E53F71"
bright2 <- "#F89F5B"

ihpData <- read.csv("IndividualsAndHouseholdsProgramValidRegistrations-Eligible2000.csv")
reg <- ihpData[, c("ppfvl", "ihpAmount")]

# remove outliers by z-score
z_scores <- as.data.frame(sapply(reg, function(reg) (abs(reg - mean(reg)) / sd(reg))))
no_outliers <- z_scores[!rowSums(z_scores > 3),]
reg <- reg[rownames(no_outliers),]

ggplot(reg, aes(x = ppfvl, y = ihpAmount)) +
  geom_point(col = dark1) +
  geom_smooth(method = "lm", se = T, col = bright1, fill = middle) +
  labs(title = "Relation between personal property damage and IHP amount") +
  theme_minimal()
