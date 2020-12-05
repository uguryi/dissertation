/* Define input_directory */
global input_directory "path/to/input/dir"



/* Read in data */
insheet using "${input_directory}/data/survey-exp-data.csv", clear
rename v1 id



/* Prepare data for analysis */
gen condition_r = .
replace condition_r = 1 if condition == "control"
replace condition_r = 2 if condition == "corona_control"
replace condition_r = 3 if condition == "class_ineq"
replace condition_r = 4 if condition == "corona_class_ineq"
replace condition_r = 5 if condition == "natural_ineq"
replace condition_r = 6 if condition == "corona_natural_ineq"
label define condition_r_labels 1 "control" 2 "corona_control" 3 "class_ineq" 4 "corona_class_ineq" 5 "natural_ineq" 6 "corona_natural_ineq"
label values condition_r condition_r_labels

gen corona = .
replace corona = 0 if condition_r == 1 | condition_r == 3 | condition_r == 5
replace corona = 1 if condition_r == 2 | condition_r == 4 | condition_r == 6

gen inequality = .
replace inequality = 0 if condition_r == 1 | condition_r == 2
replace inequality = 1 if condition_r == 3 | condition_r == 4
replace inequality = 2 if condition_r == 5 | condition_r == 6

dummieslab who_most_responsible

summarize age, meanonly
gen age_mc = age - r(mean)



/* Results */

// Does the informational treatment sensitize people to inequality?
reg high_earners_deserve_high       corona
reg high_earners_deserve_high       corona        age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg low_earners_deserve_low         corona
reg low_earners_deserve_low         corona        age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg who_most_responsible_1          i.inequality
reg who_most_responsible_1          i.inequality  age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg govt_should_decrease_ineq       i.inequality
reg govt_should_decrease_ineq       i.inequality  age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg companies_should_decrease_ineq  i.inequality
reg companies_should_decrease_ineq  i.inequality  age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

// Does coronavirus amplify class effects?
reg enough_opportunities            i.condition_r
reg enough_opportunities            i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg more_opportunities_than_parents i.condition_r
reg more_opportunities_than_parents i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg ineq_serious_problem            i.condition_r
reg ineq_serious_problem            i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg poverty_serious_problem         i.condition_r
reg poverty_serious_problem         i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg unequal_hcare_serious_problem   i.condition_r
reg unequal_hcare_serious_problem   i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg govt_transfers_effective        i.condition_r
reg govt_transfers_effective        i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg govt_regulation_effective       i.condition_r
reg govt_regulation_effective       i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg progressive_taxes_effective     i.condition_r
reg progressive_taxes_effective     i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg educ_policies_effective         i.condition_r
reg educ_policies_effective         i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science

reg private_charity_effective       i.condition_r
reg private_charity_effective       i.condition_r age_mc i.gender married has_children i.race i.religion ib4.education i.emp_status ib6.household_income i.income_volatile ib3.liberal ib3.political_party ib3.follow_news ib2.has_confidence_in_science
