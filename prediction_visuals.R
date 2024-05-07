library(ggplot2)

middle <- "#9C3587"
bright1 <- "#E53F71"
bright2 <- "#F89F5B"
colors <- c(middle, bright1, bright2)

ihpAmountDf <- data.frame(
  FeatSel = c(rep("Ranker+CorrelationAttributeEval", times = 6), rep("BestFirst+CfsSubsetEval", times = 3)),
  AttrCount = rep(c(9, 11, 15), each = 3),
  PredAlgo = rep(c("Linear Regression", "Decision Table", "Random Forest"), times = 3),
  CorCoef = c(0.5771, 0.5162, 0.7105, 0.5818, 0.5348, 0.714, 0.5815, 0.571, 0.5911)
)

cfsSubset <- subset(ihpAmountDf, FeatSel == "BestFirst+CfsSubsetEval")
ggplot(cfsSubset, aes(x = AttrCount, y = CorCoef, fill = PredAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = 15) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Features selected by Best First", x = "Number of attributes", y = "Correlation coeficient") +
  scale_fill_manual("Prediction algorithm", values = colors)

correlationSubset <- subset(ihpAmountDf, FeatSel == "Ranker+CorrelationAttributeEval")
ggplot(correlationSubset, aes(x = AttrCount, y = CorCoef, fill = PredAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = c(9, 11)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Features selected by Ranker (CorrelationAttributeEval)", x = "Number of attributes", y = "Correlation coeficient") +
  scale_fill_manual("Prediction algorithm", values = colors)

ggplot(ihpAmountDf, aes(x = AttrCount, y = CorCoef, fill = PredAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = c(9, 11, 15)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Features selected by Ranker and Best First", x = "Number of attributes", y = "Correlation coeficient") +
  scale_fill_manual("Prediction algorithm", values = colors)

