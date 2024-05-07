library(ggplot2)

middle <- "#9C3587"
bright1 <- "#E53F71"
bright2 <- "#F89F5B"
colors <- c(middle, bright1, bright2)

eligibilityClassDf <- data.frame(
  FeatSel = c(rep("BestFirst+CfsSubsetEval", times = 3), rep("Ranker+InfoGain", times = 12), rep("Ranker+Correlation", times = 9)),
  AttrCount = rep(c(5, 8, 10, 12, 15, 6, 8, 11), each = 3),
  ClassAlgo = rep(c("Naive Bayes", "SVM", "Random Forest"), times = 8),
  Accuracy = c(70, 74.55, 70.55, 62.35, 78.85, 67.85, 67.25, 78.85, 70.3, 65.1, 78.8, 70.75, 63.15, 77.65, 76.7, 66.75, 77.7, 76.6, 64, 77.4, 77.35, 0, 75.3, 80.9)
)

cfsSubset <- subset(eligibilityClassDf, FeatSel == "BestFirst+CfsSubsetEval")
ggplot(cfsSubset, aes(x = AttrCount, y = Accuracy, fill = ClassAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = 5) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "Features selected by Best First", x = "Number of attributes", y = "Classification accuracy [%]") +
  scale_fill_manual("Classification algorithm", values = colors)

infoGainSubset <- subset(eligibilityClassDf, FeatSel == "Ranker+InfoGain")
ggplot(infoGainSubset, aes(x = AttrCount, y = Accuracy, fill = ClassAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = c(8, 10, 12, 15)) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "Features selected by Ranker (InfoGainAttributeEval)", x = "Number of attributes", y = "Classification accuracy [%]") +
  scale_fill_manual("Classification algorithm", values = colors)

correlationSubset <- subset(eligibilityClassDf, FeatSel == "Ranker+Correlation")
ggplot(correlationSubset, aes(x = AttrCount, y = Accuracy, fill = ClassAlgo)) +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_continuous(breaks = c(6, 8, 11)) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "Features selected by Ranker (CorrelationAttributeEval)", x = "Number of attributes", y = "Classification accuracy [%]") +
  scale_fill_manual("Classification algorithm", values = colors)