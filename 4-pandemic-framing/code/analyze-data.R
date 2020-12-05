####################
# Import libraries #
####################

library(dplyr)
library(ggplot2)
library(ggpubr)
library(readr)



################
# Read in data #
################

filepath = "path/to/survey-exp-data-corona.csv"
df <- read_csv(filepath)
colnames(df)[1] <- "id"



#############################
# Prepare data for analysis #
#############################

df$at_risk <- as.integer(df$self_at_risk == 1 | df$family_member_at_risk == 1)



############################################
# Define function to graph predicted means #
############################################

graph_means <- function(model, title) {
  condition <- c("Class inequality", "Control", "Natural inequality")
  mean <- coef(summary(model))[, "Estimate"]
  se <- coef(summary(model))[, "Std. Error"]
  data <- data.frame(condition, mean, se)
  g <- ggplot(data, aes(x=mean, y=condition)) + 
    geom_point() + 
    geom_errorbarh(aes(xmin=mean-se*1.96, xmax=mean+se*1.96), height = .2) + 
    ggtitle(title) +
    labs(y = "", x = "Predicted mean") + 
    theme(axis.text.y = element_text(face="bold"))
  return(g)
}



############
# Figure 1 #
############

m1.1 <- lm(coronavirus_serious_threat ~ 0 + condition, data = df)
m1.2 <- lm(must_save_economy          ~ 0 + condition, data = df)

fig1.1 <- graph_means(m1.1, "Coronavirus serious threat")
fig1.2 <- graph_means(m1.2, "Economy must be saved")

fig1 <- ggarrange(fig1.1, fig1.2, ncol=2, nrow=1)

ggsave(file="path/to/figure1.png",               plot=fig1, width=10, height=5)
ggsave(file="path/to/figure1.eps", device="eps", plot=fig1, width=10, height=5)



############
# Figure 2 # 
############

m2.1 <- lm(coronavirus_serious_threat ~ 0 + condition, data = subset(df, at_risk == 1))
m2.3 <- lm(coronavirus_serious_threat ~ 0 + condition, data = subset(df, at_risk == 0))

fig2.1 <- graph_means(m2.1, "Coronavirus serious threat, at risk")
fig2.3 <- graph_means(m2.3, "Coronavirus serious threat, not at risk")

m2.2 <- lm(must_save_economy ~ 0 + condition, data = subset(df, at_risk == 1))
m2.4 <- lm(must_save_economy ~ 0 + condition, data = subset(df, at_risk == 0))

fig2.2 <- graph_means(m2.2, "Economy must be saved, at risk")
fig2.4 <- graph_means(m2.4, "Economy must be saved, not at risk")

fig2 <- ggarrange(fig2.1, fig2.2, fig2.3, fig2.4, ncol=2, nrow=2)

ggsave(file="path/to/figure2.png",               plot=fig2, width=10, height=10)
ggsave(file="path/to/figure2.eps", device="eps", plot=fig2, width=10, height=10)



###########
# Table 1 #
###########

df %>%
  group_by(condition, at_risk) %>%
  summarise(n = n())



###########
# Table 2 #
###########

df %>%
  group_by(condition) %>%
  summarise(mean = mean(age))

df %>%
  group_by(condition, gender) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, married) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, has_children) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, race) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, religion) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=30)

df %>%
  group_by(condition, education) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=27)

df %>%
  group_by(condition, emp_status) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=18)

df %>%
  group_by(condition, household_income) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=36)

df %>%
  group_by(condition, income_volatile) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, liberal) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, political_party) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, follow_news) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, has_confidence_in_science) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))



###########
# Table 3 #
###########

df %>%
  filter(condition == "corona_control") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=51)

df %>%
  filter(condition == "corona_natural_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=51)

df %>%
  filter(condition == "corona_class_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=51)



###########
# Table 4 #
###########

df$condition <- as.factor(df$condition)
df <- within(df, condition <- relevel(condition, ref = "corona_control"))

summary(lm(coronavirus_serious_threat ~ condition, data = df))

summary(lm(coronavirus_serious_threat ~ condition + 
             age + factor(gender) + married + has_children + factor(race) + factor(religion) + 
             factor(education) + factor(emp_status) + household_income + income_volatile + 
             liberal + factor(political_party) + follow_news + has_confidence_in_science, data = df))



###########
# Table 5 #
###########

summary(lm(must_save_economy ~ condition, data = df))

summary(lm(must_save_economy ~ condition + 
             age + factor(gender) + married + has_children + factor(race) + factor(religion) + 
             factor(education) + factor(emp_status) + household_income + income_volatile + 
             liberal + factor(political_party) + follow_news + has_confidence_in_science, data = df))



###########
# Table 6 #
###########

summary(lm(coronavirus_serious_threat ~ condition, data = subset(df, at_risk == 1)))
summary(lm(coronavirus_serious_threat ~ condition, data = subset(df, at_risk == 0)))

summary(lm(must_save_economy ~ condition, data = subset(df, at_risk == 1)))
summary(lm(must_save_economy ~ condition, data = subset(df, at_risk == 0)))



###########
# Table 7 #
###########

summary(lm(satisfied_with_city         ~ condition, data = df))
summary(lm(satisfied_with_state        ~ condition, data = df))
summary(lm(satisfied_with_federal_govt ~ condition, data = df))
