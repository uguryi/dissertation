global input_directory "path/to/input/dir"
log using "${input_directory}/logs/1-se-analyze-data-stata.log", replace

/********************************
*** PREPARE DATA FOR ANALYSIS ***
********************************/

/* Read in data */
insheet using "${input_directory}/data/survey_exp_data.csv", clear

/* Generate additional variables */
dummieslab gender
dummieslab marital_status
dummieslab has_children
dummieslab race
dummieslab education
dummieslab employment_status
dummieslab income
dummieslab liberal_vs_conservative
dummieslab democrat_vs_republican

summarize age, meanonly
gen age_mc = age - r(mean)

gen condition_r = .
replace condition_r = 1 if condition == "decr_ineq_incr_mobil"
replace condition_r = 2 if condition == "decr_ineq_decr_mobil"
replace condition_r = 3 if condition == "incr_ineq_incr_mobil"
replace condition_r = 4 if condition == "incr_ineq_decr_mobil"



/*****************************************
*** TABLE 2: SAMPLE SIZES BY CONDITION ***
*****************************************/

sum v1
table ineq_condition mobil_condition, contents(count v1)



/************************************
*** TABLE 3: SUMMARY DEMOGRAPHICS ***
************************************/

table ineq_condition mobil_condition, contents(mean age)

table ineq_condition mobil_condition, contents(mean gender_1 mean gender_2 mean gender_3)
table ineq_condition mobil_condition, contents(mean marital_status_0 mean marital_status_1)
table ineq_condition mobil_condition, contents(mean has_children_0 mean has_children_1)
table ineq_condition mobil_condition, contents(mean race_1 mean race_2 mean race_3 mean race_4 mean race_5)

table ineq_condition mobil_condition, contents(mean education_1 mean education_2 mean education_3 mean education_4 mean education_5) 
table ineq_condition mobil_condition, contents(mean education_6 mean education_7 mean education_8 mean education_9)

table ineq_condition mobil_condition, contents(mean employment_status_1 mean employment_status_2 mean employment_status_3 mean employment_status_4 mean employment_status_5)
table ineq_condition mobil_condition, contents(mean employment_status_6)

table ineq_condition mobil_condition, contents(mean income_1 mean income_2 mean income_3 mean income_4 mean income_5)
table ineq_condition mobil_condition, contents(mean income_6 mean income_7 mean income_8 mean income_9 mean income_10)
table ineq_condition mobil_condition, contents(mean income_11 mean income_12)

table ineq_condition mobil_condition, contents(mean liberal_vs_conservative_1 mean liberal_vs_conservative_2 mean liberal_vs_conservative_3 mean liberal_vs_conservative_4 mean liberal_vs_conservative_5)
table ineq_condition mobil_condition, contents(mean democrat_vs_republican_1 mean democrat_vs_republican_2 mean democrat_vs_republican_3 mean democrat_vs_republican_4)



/****************************
*** APPENDIX 2: GEOGRAPHY ***
****************************/

set more off
encode state, generate(state2)
tab state2

set more off
proportion state2



/*******************************
*** APPENDIX 3: LOGIT MODELS ***
*******************************/

/* Fit models: MC ~ conditions */
set more off

ologit gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition, or
ologit gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or
						
ologit children_have_worse_chances      c.ineq_condition##c.mobil_condition, or
ologit children_have_worse_chances      c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

/* Fit models: Perceived mobility ~ conditions */
set more off

ologit intergen_mobility_down c.ineq_condition##c.mobil_condition, or
ologit intergen_mobility_down c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit intragen_mobility_down c.ineq_condition##c.mobil_condition, or
ologit intragen_mobility_down c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

/* Fit models: Attitudes ~ conditions */
set more off

logit  income_result_of_circumstances c.ineq_condition##c.mobil_condition, or
logit  income_result_of_circumstances c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

logit  equal_outcomes                 c.ineq_condition##c.mobil_condition, or
logit  equal_outcomes                 c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit govt_should_take_active_steps  c.ineq_condition##c.mobil_condition, or
ologit govt_should_take_active_steps  c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit ineq_is_a_serious_problem      c.ineq_condition##c.mobil_condition, or
ologit ineq_is_a_serious_problem      c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit high_earners_rarely_deserving  c.ineq_condition##c.mobil_condition, or
ologit high_earners_rarely_deserving  c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

/* Fit models: Policy preferences ~ conditions */
set more off

ologit increase_taxes_on_millionares c.ineq_condition##c.mobil_condition, or
ologit increase_taxes_on_millionares c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit increase_estate_tax           c.ineq_condition##c.mobil_condition, or
ologit increase_estate_tax           c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit increase_min_wage             c.ineq_condition##c.mobil_condition, or
ologit increase_min_wage             c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit increase_aid_to_poor          c.ineq_condition##c.mobil_condition, or
ologit increase_aid_to_poor          c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

ologit increase_food_stamps          c.ineq_condition##c.mobil_condition, or
ologit increase_food_stamps          c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

logit  support_entrepreneurs         c.ineq_condition##c.mobil_condition, or
logit  support_entrepreneurs         c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or

logit  support_housing               c.ineq_condition##c.mobil_condition, or
logit  support_housing               c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican, or



/*****************************
*** APPENDIX 4: OLS MODELS ***
*****************************/

/* Fit models: MC ~ conditions */
set more off

reg gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition
reg gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg children_have_worse_chances      c.ineq_condition##c.mobil_condition
reg children_have_worse_chances      c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

/* Fit models: Perceived mobility ~ conditions */
set more off

reg intergen_mobility_down c.ineq_condition##c.mobil_condition
reg intergen_mobility_down c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg intragen_mobility_down c.ineq_condition##c.mobil_condition
reg intragen_mobility_down c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

/* Fit models: Attitudes ~ conditions */
set more off

reg income_result_of_circumstances c.ineq_condition##c.mobil_condition
reg income_result_of_circumstances c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg equal_outcomes                 c.ineq_condition##c.mobil_condition
reg equal_outcomes                 c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg govt_should_take_active_steps  c.ineq_condition##c.mobil_condition
reg govt_should_take_active_steps  c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg ineq_is_a_serious_problem      c.ineq_condition##c.mobil_condition
reg ineq_is_a_serious_problem      c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg high_earners_rarely_deserving  c.ineq_condition##c.mobil_condition
reg high_earners_rarely_deserving  c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

/* Fit models: Policy preferences ~ conditions */
set more off

reg increase_taxes_on_millionares c.ineq_condition##c.mobil_condition
reg increase_taxes_on_millionares c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg increase_estate_tax           c.ineq_condition##c.mobil_condition
reg increase_estate_tax           c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg increase_min_wage             c.ineq_condition##c.mobil_condition
reg increase_min_wage             c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg increase_aid_to_poor          c.ineq_condition##c.mobil_condition
reg increase_aid_to_poor          c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg increase_food_stamps          c.ineq_condition##c.mobil_condition
reg increase_food_stamps          c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg support_entrepreneurs         c.ineq_condition##c.mobil_condition
reg support_entrepreneurs         c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican

reg support_housing               c.ineq_condition##c.mobil_condition
reg support_housing               c.ineq_condition##c.mobil_condition age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.liberal_vs_conservative ib3.democrat_vs_republican



/****************************************
*** APPENDIX 5: POLITICAL ORIENTATION ***
****************************************/

recode liberal_vs_conservative (1 = -2) (2 = -1) (3 = 0) (4 = 1) (5 = 2), gen(liberal_vs_conservative_r)

set more off

reg gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg gap_btw_rich_and_poor_increasing c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg children_have_worse_chances      c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg children_have_worse_chances      c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg intergen_mobility_down           c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg intergen_mobility_down           c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg intragen_mobility_down           c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg intragen_mobility_down           c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg income_result_of_circumstances   c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg income_result_of_circumstances   c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg equal_outcomes                   c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg equal_outcomes                   c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg govt_should_take_active_steps    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg govt_should_take_active_steps    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg ineq_is_a_serious_problem        c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg ineq_is_a_serious_problem        c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg high_earners_rarely_deserving    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg high_earners_rarely_deserving    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

set more off

reg increase_taxes_on_millionares    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg increase_taxes_on_millionares    c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg increase_estate_tax              c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg increase_estate_tax              c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg increase_min_wage                c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg increase_min_wage                c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg increase_aid_to_poor             c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg increase_aid_to_poor             c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg increase_food_stamps             c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg increase_food_stamps             c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg support_entrepreneurs            c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg support_entrepreneurs            c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican

reg support_housing                  c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r
reg support_housing                  c.ineq_condition##c.mobil_condition##c.liberal_vs_conservative_r age_mc ib2.gender i.marital_status i.has_children i.race ib4.education i.employment_status ib6.income ib3.democrat_vs_republican



/************************************
*** SAVE DATA IN OLD FORMAT FOR R ***
************************************/

drop how_to_fix_ineq_text outcome_display_order
saveold "${input_directory}/data/survey_exp_data_processed_old.dta", replace

log close
