# Load libraries
library(dplyr)
library(readr)



# Read in data
filepath = "path/to/survey-exp-data.csv"
df <- read_csv(filepath)
colnames(df)[1] <- "id"



# Table B1
df %>%
  group_by(condition) %>%
  summarise(n = n())



# Table B2
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
  mutate(freq = n / sum(n)) %>%
  print(n=30)

df %>%
  group_by(condition, religion) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=60)

df %>%
  group_by(condition, education) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=54)

df %>%
  group_by(condition, emp_status) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=36)

df %>%
  group_by(condition, household_income) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=72)

df %>%
  group_by(condition, income_volatile) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))

df %>%
  group_by(condition, liberal) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=30)

df %>%
  group_by(condition, political_party) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=24)

df %>%
  group_by(condition, follow_news) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=30)

df %>%
  group_by(condition, has_confidence_in_science) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n))



# Table B3
df %>%
  filter(condition == "control") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)

df %>%
  filter(condition == "corona_control") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)

df %>%
  filter(condition == "class_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)

df %>%
  filter(condition == "corona_class_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)

df %>%
  filter(condition == "natural_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)

df %>%
  filter(condition == "corona_natural_ineq") %>%
  group_by(condition, state) %>%
  summarise(n = n()) %>%
  mutate(freq = n / sum(n)) %>%
  print(n=53)
