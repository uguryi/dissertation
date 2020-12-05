// Last updated: 2018-12-20

// Code and data downloaded from: http://davidrand-cooperation.com/data-and-code/

/***************************************************
POWER CALCULATIONS BASED ON NISHI ET AL. (2015) DATA
***************************************************/

*Step A: Data infile

clear
insheet using "path/to/individual_data.csv"

describe





*Step B: Variable creation

destring behavior, replace force
gen coop = behavior

gen wealth = cumulativepayoff

gen visible = .
replace visible = 1 if showscore == "true"
replace visible = 0 if showscore == "false"

gen gini = "0.0" if scorea == 500
replace gini = "0.2" if scorea == 700 | scorea == 850
replace gini = "0.4" if scorea == 1150

gen gini2 = 0.0 if scorea == 500
replace gini2 = 0.2 if scorea == 700 | scorea == 850
replace gini2 = 0.4 if scorea == 1150

replace initial_score = initial_score
gen initial_score2 = initial_score/100

destring e_behavior, replace force
gen prev_coop = e_behavior
tab prev_coop, missing

destring e_cumulativepayoff, replace force
gen prev_wealth = e_cumulativepayoff
gen prev_wealth2 = prev_wealth/100

destring e_degree, replace force

destring local_avg_wealth, replace force
gen alter_minus_ego_wealth = local_avg_wealth - prev_wealth

gen richer_e = .
replace richer_e = 1 if alter_minus_ego_wealth <= 0
replace richer_e = 0 if alter_minus_ego_wealth > 0

destring local_rate_coop, replace force

gen local_rate_coop2 = .
replace local_rate_coop2 = 1 if local_rate_coop >= 0.5 & local_rate_coop !=.
replace local_rate_coop2 = 0 if local_rate_coop < 0.5  & local_rate_coop !=.

gen int_ric_gin2 = richer_e*gini2





*Step C (Analysis)

//xi: logit2 coop i.visible i.prev_coop local_rate_coop2, fcluster(game) tcluster(round)
//xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 i.visible*richer_e i.visible*gini2 i.visible*int_ric_gin2, fcluster(game) tcluster(round)

//xi: logit2 coop e_degree prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==0 & initial_score == 500, fcluster(game) tcluster(round)
//xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==0 & (initial_score == 850 | initial_score ==700 | initial_score == 350 | initial_score ==300), fcluster(game) tcluster(round)
//xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==0 & (initial_score == 1150 | initial_score ==200), fcluster(game) tcluster(round)
//xi: logit2 coop e_degree prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==1 & round>=2 & initial_score == 500, fcluster(game) tcluster(round)
//xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==1 & (initial_score == 850 | initial_score ==700 | initial_score == 350 | initial_score ==300), fcluster(game) tcluster(round)
//xi: logit2 coop e_degree initial_score2 prev_wealth2 i.prev_coop*local_rate_coop2 richer_e if visible ==1 & (initial_score == 1150 | initial_score ==200), fcluster(game) tcluster(round)





/**********************/
/* Power Calculations */
/**********************/

gen gini_cat = .
replace gini_cat = 1 if gini == "0.0"
replace gini_cat = 2 if gini == "0.2"
replace gini_cat = 3 if gini == "0.4"

log using "path/to/power-calculations1-2018-12-20.log"
mixed coop i.gini_cat i.round || game: , cov(independent) || superid: if visible == 1, cov(independent) mle
log close

log using "path/to/power-calculations2-2018-12-20.log"
mixed coop i.gini_cat##i.visible i.round || game: , cov(independent) || superid:, cov(independent) mle
log close
