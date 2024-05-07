library(ggplot2)

bright1 <- "#E53F71"
bright2 <- "#F89F5B"

# IHP Eligibility

## Ranker + InfoGainAttributeEval
infoGainScores <- data.frame(
  Attr = c("damagedCity", "ppfvl", "county", "lastRefresh", "rpfvl", "inspnIssued", "inspnReturned", "floodDamageAmount", "floodDamage", "waterLevel"),
  Score = c(0.44977915, 0.24234672, 0.22518127, 0.17434418, 0.14559682, 0.14191827, 0.14191827, 0.11608203, 0.10573348, 0.1014424)
)
ggplot(infoGainScores, aes(x = reorder(Attr, Score, decreasing = T), y = Score)) +
  geom_bar(stat = "identity", fill = bright1) +
  labs(title = "Top 10 attributes to determine IHP eligibility (InfoGain)", x = "Attribute", y = "Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 1))

## Ranker + CorrelationAttributeEval
correlationScores <- data.frame(
  Attr = c("inspnIssuead", "inspnReturned", "floodDamage", "ppfvl", "highWaterLocation", "waterLevel", "utilitiesOut", "homeDamage", "floodDamageAmount", "primaryResidence"),
  Score = c(0.42843, 0.42843, 0.36452, 0.31309, 0.25649, 0.21852, 0.19613, 0.18701, 0.16818, 0.14554)
)
ggplot(correlationScores, aes(x = reorder(Attr, Score, decreasing = T), y = Score)) +
  geom_bar(stat = "identity", fill = bright1) +
  labs(title = "Top 10 attributes to determine IHP eligibility (CorrelationAttributeEval)", x = "Attribute", y = "Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 1))

# IHP Amount

## Ranker + CorrelationAttributeEval
correlationScores <- data.frame(
  Attr = c("ppfvl", "floodDamageAmount", "rpfvl", "waterLevel", "floodDamage", "destroyed", "habitabilityREpairsRequired", "emergencyNeeds", "damagedZipCode", "foundationDamageAmount"),
  Score = c(0.52938, 0.35569, 0.31973, 0.30693, 0.24658, 0.21234, 0.21037, 0.18482, 0.13132, 0.13043)
)
ggplot(correlationScores, aes(x = reorder(Attr, Score, decreasing = T), y = Score)) +
  geom_bar(stat = "identity", fill = bright2) +
  labs(title = "Top 10 attributes to determine IHP amount (CorrelationAttributeEval)", x = "Attribute", y = "Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0, 1))