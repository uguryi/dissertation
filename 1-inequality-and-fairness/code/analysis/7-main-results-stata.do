log using "path/to/stata-between.log", replace

/**************
*** BETWEEN ***
**************/

insheet using "path/to/data_final.csv", clear

set more off
describe
replace ginilocal = "" if ginilocal == "inf"
gen ginilocal_real = real(ginilocal)
drop ginilocal
rename ginilocal_real ginilocal
sort session_no version pid round
by session_no version pid: gen f_score_dup = cond(_N==1, 0, _n)
sort session_no version pid round
by session_no version pid round: gen coop_dup = cond(_N==1, 0, _n)
gen earned_x_equal = earned * equal
encode condition, generate(condition2)

// Fairness perceptions
mixed f_score c.earned##c.equal                            if f_score_dup <= 1 & version == 1 || session_no:
mixed f_score c.earned##c.equal                            if f_score_dup <= 1 & version == 2 || session_no:
mixed f_score c.earned##c.equal  i.version                 if f_score_dup <= 1                || session_no: || pid:
mixed f_score c.earned##c.equal##i.version                 if f_score_dup <= 1                || session_no: || pid:
mixed f_score c.earned##c.equal            change_in_score if f_score_dup <= 1 & version == 1 || session_no:
mixed f_score c.earned##c.equal            change_in_score if f_score_dup <= 1 & version == 2 || session_no:
mixed f_score c.earned##c.equal  i.version change_in_score if f_score_dup <= 1                || session_no: || pid:
mixed f_score c.earned##c.equal##i.version change_in_score if f_score_dup <= 1                || session_no: || pid:
// Control for experience
mixed f_score c.earned##c.equal##i.version change_in_score num_other if f_score_dup <= 1 || session_no: || pid:
// Regress on conditions
mixed f_score ibn.condition2 i.version if f_score_dup <= 1, noconstant || session_no: || pid:

// Cooperation patterns
melogit coopchoice c.earned##c.equal            i.round                 if coop_dup <= 1 & version == 1                || session_no: || pid:
melogit coopchoice c.earned##c.equal            i.round                 if coop_dup <= 1 & version == 2                || session_no: || pid:
melogit coopchoice c.earned##c.equal  i.version i.round                 if coop_dup <= 1                & round != 10  || session_no: || pid:
melogit coopchoice c.earned##c.equal##i.version i.round                 if coop_dup <= 1                & round != 10  || session_no: || pid:
melogit coopchoice c.earned##c.equal            i.round scorebeforecoop if coop_dup <= 1 & version == 1                || session_no: || pid:
melogit coopchoice c.earned##c.equal            i.round scorebeforecoop if coop_dup <= 1 & version == 2                || session_no: || pid:
melogit coopchoice c.earned##c.equal  i.version i.round scorebeforecoop if coop_dup <= 1                & round != 10  || session_no: || pid:
melogit coopchoice c.earned##c.equal##i.version i.round scorebeforecoop if coop_dup <= 1                & round != 10  || session_no: || pid:
// Control for experience
melogit coopchoice c.earned##c.equal##i.version i.round scorebeforecoop num_other if coop_dup <= 1 & round != 10 || session_no: || pid:
// Regress on conditions
melogit coopchoice ibn.condition2 i.version i.round if coop_dup <= 1 & round != 10, noconstant || session_no: || pid:

// Session-level analyses
insheet using "path/to/session_data_pid_version.csv", clear

reg   f_score c.earned##c.equal            if version == 1
reg   f_score c.earned##c.equal            if version == 2
mixed f_score c.earned##c.equal  i.version                 || session_no:
mixed f_score c.earned##c.equal##i.version                 || session_no:

insheet using "path/to/session_data_coop.csv", clear

mixed coopchoice c.earned##c.equal            i.round if version == 1             || session_no:
mixed coopchoice c.earned##c.equal            i.round if version == 2             || session_no:
mixed coopchoice c.earned##c.equal  i.version i.round if              round != 10 || session_no:
mixed coopchoice c.earned##c.equal##i.version i.round if              round != 10 || session_no:

log close





log using "path/to/stata-within.log", replace

/*************
*** WITHIN ***
*************/

insheet using "path/to/data_within.csv", clear

set more off
describe
replace delta_ginilocal = "" if delta_ginilocal == "inf"
gen delta_ginilocal_real = real(delta_ginilocal)
drop delta_ginilocal
rename delta_ginilocal_real delta_ginilocal
sort session_no pid round
by session_no pid: gen f_score_dup = cond(_N==1, 0, _n)
sort session_no pid round
by session_no pid round: gen coop_dup = cond(_N==1, 0, _n)
gen delta_earned_x_delta_equal = delta_earned * delta_equal
gen delta_earned_i = delta_earned
gen delta_equal_i  = delta_equal
replace delta_earned_i = 2 if delta_earned == -1
replace delta_equal_i  = 2 if delta_equal  == -1
dummieslab delta_earned_i
dummieslab delta_equal_i
gen delta_int = earned_v2 * equal_v2 - earned_v1 * equal_v1

// Fairness perceptions
mixed delta_f_score   delta_earned      delta_equal     delta_int                         if f_score_dup <= 1 || session_no:
mixed delta_f_score i.delta_earned_i##i.delta_equal_i                                     if f_score_dup <= 1 || session_no:
mixed delta_f_score   delta_earned      delta_equal     delta_int   delta_change_in_score if f_score_dup <= 1 || session_no:
// Try ordinal logistic model
meologit delta_f_score delta_earned delta_equal delta_int if f_score_dup <= 1 || session_no:
// Test coef_1 = -1 * coef_2
mixed delta_f_score c.delta_earned_i_1##c.delta_earned_i_2##c.delta_equal_i_1##c.delta_equal_i_2 if f_score_dup <= 1 || session_no:
test  delta_earned_i_1 = -1 * delta_earned_i_2
test  delta_equal_i_1  = -1 * delta_equal_i_2
// Control for experience
mixed delta_f_score   delta_earned      delta_equal     delta_int delta_change_in_score num_other if f_score_dup <= 1 || session_no:

// Cooperation patterns
mixed delta_coopchoice   delta_earned      delta_equal     delta_int                         i.round if coop_dup <= 1 || session_no: || pid:
mixed delta_coopchoice i.delta_earned_i##i.delta_equal_i                                     i.round if coop_dup <= 1 || session_no: || pid:
mixed delta_coopchoice   delta_earned      delta_equal     delta_int   delta_scorebeforecoop i.round if coop_dup <= 1 || session_no: || pid:
// Try ordinal logistic model
meologit delta_coopchoice   delta_earned      delta_equal     delta_int                         i.round if coop_dup <= 1 || session_no: || pid:
meologit delta_coopchoice i.delta_earned_i##i.delta_equal_i                                     i.round if coop_dup <= 1 || session_no: || pid:
meologit delta_coopchoice   delta_earned      delta_equal     delta_int   delta_scorebeforecoop i.round if coop_dup <= 1 || session_no: || pid:
// Test coef_1 = -1 * coef_2
mixed delta_coopchoice c.delta_earned_i_1##c.delta_earned_i_2##c.delta_equal_i_1##c.delta_equal_i_2 i.round if coop_dup <= 1 || session_no: || pid:
test  delta_earned_i_1 = -1 * delta_earned_i_2
test  delta_equal_i_1  = -1 * delta_equal_i_2
// Control for experience
mixed delta_coopchoice   delta_earned      delta_equal     delta_int   delta_scorebeforecoop   num_other i.round if coop_dup <= 1 || session_no: || pid:

// Instrumental variable model
mixed delta_f_score    delta_earned      delta_equal     delta_int         if f_score_dup <= 1 || session_no:
predict dhat
mixed delta_coopchoice dhat                                        i.round if coop_dup <= 1    || session_no: || pid:

// Session-level analyses
insheet using "path/to/session_data_within_pid.csv", clear

gen delta_earned_i = delta_earned
gen delta_equal_i  = delta_equal
replace delta_earned_i = 2 if delta_earned == -1
replace delta_equal_i  = 2 if delta_equal  == -1
gen delta_int = earned2 * equal2 - earned1 * equal1

reg delta_f_score   delta_earned      delta_equal     delta_int
reg delta_f_score i.delta_earned_i##i.delta_equal_i

insheet using "path/to/session_data_within_coop.csv", clear

gen delta_earned_i = delta_earned
gen delta_equal_i  = delta_equal
replace delta_earned_i = 2 if delta_earned == -1
replace delta_equal_i  = 2 if delta_equal  == -1
gen delta_int = earned2 * equal2 - earned1 * equal1

mixed delta_coopchoice   delta_earned      delta_equal     delta_int     i.round || session_no:
mixed delta_coopchoice i.delta_earned_i##i.delta_equal_i                 i.round || session_no:

log close
