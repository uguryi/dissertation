####################
# Import libraries #
####################

library(foreign)
library(tidyr)
library(sandwich)
library(miceadds)
library(ggplot2)
library(ggpubr)



################
# Read in data #
################

filepath = "path/to/survey_exp_data_processed_old.dta"
df <- read.dta(filepath)



##############
# Fit models #
##############

outcomes <- c("gap_btw_rich_and_poor_increasing", "children_have_worse_chances",
              "intergen_mobility_down", "intragen_mobility_down",
              "income_result_of_circumstances", "equal_outcomes", "govt_should_take_active_steps",
              "ineq_is_a_serious_problem", "high_earners_rarely_deserving",
              "increase_taxes_on_millionares", "increase_estate_tax", "increase_min_wage", "increase_aid_to_poor",
              "increase_food_stamps", "support_entrepreneurs", "support_housing")
models1 <- lapply(outcomes, function(x) {lm(substitute(i ~ 0 + condition,                    list(i = as.name(x))), data = df)})
models2 <- lapply(outcomes, function(x) {lm(substitute(i ~ ineq_condition * mobil_condition, list(i = as.name(x))), data = df)})



####################
# Generate figures #
####################

titles <- c("Income gap increasing", "Children have worse chances",
            "Downward inter-generational mobility", "Downward intra-generational mobility",
            "Income result of circumstances", "Equal outcomes", "Government should take active steps",
            "Inequality is a serious problem", "High earners rarely deserving",
            "Increase taxes on millionaires", "Increase estate tax", "Increase minimum wage", "Increase aid to the poor",
            "Increase spending on food stamps", "Support entrepreneurs", "Support housing")
lst_of_figs <- list()
i <- 1
for (model in models1) {
  condition <- c("OP", "OO", "PP", "PO")
  mean <- coef(summary(model))[, "Estimate"]
  se <- coef(summary(model))[, "Std. Error"]
  data <- data.frame(condition, mean, se)
  g <- ggplot(data, aes(x=mean, y=condition)) + 
    geom_point() + 
    geom_errorbarh(aes(xmin=mean-se*1.96, xmax=mean+se*1.96), height = .2) + 
    ggtitle(titles[i]) +
    labs(y = "", x = "Condition mean") + 
    theme(axis.text.y = element_text(face="bold"))
  lst_of_figs[[i]] <- g
  i <- i + 1
}
figure_perceptions <- ggarrange(lst_of_figs[[1]],  lst_of_figs[[2]],                     ncol=2, nrow=1)
figure_mobility    <- ggarrange(lst_of_figs[[3]],  lst_of_figs[[4]],                     ncol=2, nrow=1)
figure_attitudes   <- ggarrange(lst_of_figs[[7]],  lst_of_figs[[8]],                     ncol=2, nrow=1)
figure_policy      <- ggarrange(lst_of_figs[[11]], lst_of_figs[[12]], lst_of_figs[[16]], ncol=3, nrow=1)
figure_other       <- ggarrange(lst_of_figs[[5]],  lst_of_figs[[6]],  lst_of_figs[[9]],
                                lst_of_figs[[10]], lst_of_figs[[13]], lst_of_figs[[14]],
                                lst_of_figs[[15]],                                       ncol=3, nrow=3)

lst_of_figs <- list()
i <- 1
for (model in models2) {
  coefficient <- c("Ineq. pess.", "Oppo. pess.", "Ineq. pess. x Oppo. pess.")
  estimate <- coef(summary(model))[, "Estimate"][2:4]
  se <- coef(summary(model))[, "Std. Error"][2:4]
  data <- data.frame(coefficient, estimate, se)
  g <- ggplot(data, aes(x=estimate, y=coefficient)) + 
    geom_point() + 
    geom_errorbarh(aes(xmin=estimate-se*1.96, xmax=estimate+se*1.96), height = .2) + 
    ggtitle(titles[i]) + 
    geom_vline(xintercept = 0, linetype="dotted", color="red", size = 1) +
    labs(y = "", x = "Coefficient estimate") + 
    theme(axis.text.y = element_text(face="bold"))
  lst_of_figs[[i]] <- g
  i <- i + 1
}
figure_perceptions_eff <- ggarrange(lst_of_figs[[1]],  lst_of_figs[[2]],                     ncol=2, nrow=1)
figure_mobility_eff    <- ggarrange(lst_of_figs[[3]],  lst_of_figs[[4]],                     ncol=2, nrow=1)
figure_attitudes_eff   <- ggarrange(lst_of_figs[[7]],  lst_of_figs[[8]],                     ncol=2, nrow=1)
figure_policy_eff      <- ggarrange(lst_of_figs[[11]], lst_of_figs[[12]], lst_of_figs[[16]], ncol=3, nrow=1)
figure_other_eff       <- ggarrange(lst_of_figs[[5]],  lst_of_figs[[6]],  lst_of_figs[[9]],
                                    lst_of_figs[[10]], lst_of_figs[[13]], lst_of_figs[[14]],
                                    lst_of_figs[[15]],                                       ncol=3, nrow=3)



#####################
# View/save results #
#####################

#figure_manipulation_checks_eff
#figure_own_mobility_eff
#figure_attitudes_eff
#figure_policy_eff

#figure_manipulation_checks
#figure_own_mobility
#figure_attitudes
#figure_policy

ggsave(file="path/to/fig-1.png", plot=figure_perceptions, width=10, height=5)
ggsave(file="path/to/fig-2.png", plot=figure_mobility,    width=10, height=5)
ggsave(file="path/to/fig-3.png", plot=figure_attitudes,   width=10, height=5)
ggsave(file="path/to/fig-4.png", plot=figure_policy,      width=15, height=5)

ggsave(file="path/to/fig-A4-1.png", plot=figure_other,    width=15, height=15)

ggsave(file="path/to/fig-A4-2.png", plot=figure_perceptions_eff, width=10, height=5)
ggsave(file="path/to/fig-A4-3.png", plot=figure_mobility_eff,    width=10, height=5)
ggsave(file="path/to/fig-A4-4.png", plot=figure_attitudes_eff,   width=10, height=5)
ggsave(file="path/to/fig-A4-5.png", plot=figure_policy_eff,      width=15, height=5)
ggsave(file="path/to/fig-A4-6.png", plot=figure_other_eff,       width=15, height=15)
