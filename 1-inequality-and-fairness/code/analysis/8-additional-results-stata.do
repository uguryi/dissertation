log using "path/to/stata-additional.log", replace

/**************
*** BETWEEN ***
**************/

/* INDIVIDUAL-LEVEL ANALYSES */

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

// Add tie choice ~ conditions
melogit addchoice c.earned##c.equal            i.round                     if version == 1           || session_no: || pid:
melogit addchoice c.earned##c.equal            i.round                     if version == 2           || session_no: || pid:
melogit addchoice c.earned##c.equal  i.version i.round                     if              round < 9 || session_no: || pid:
melogit addchoice c.earned##c.equal##i.version i.round                     if              round < 9 || session_no: || pid:
melogit addchoice c.earned##c.equal            i.round coopchoicealter_add if version == 1           || session_no: || pid:
melogit addchoice c.earned##c.equal            i.round coopchoicealter_add if version == 2           || session_no: || pid:
melogit addchoice c.earned##c.equal  i.version i.round coopchoicealter_add if              round < 9 || session_no: || pid:
melogit addchoice c.earned##c.equal##i.version i.round coopchoicealter_add if              round < 9 || session_no: || pid:
// Cut tie choice ~ conditions
melogit cutchoice c.earned##c.equal            i.round                     if version == 1           || session_no: || pid:
melogit cutchoice c.earned##c.equal            i.round                     if version == 2           || session_no: || pid:
melogit cutchoice c.earned##c.equal  i.version i.round                     if              round < 9 || session_no: || pid:
melogit cutchoice c.earned##c.equal##i.version i.round                     if              round < 9 || session_no: || pid:
melogit cutchoice c.earned##c.equal            i.round coopchoicealter_cut if version == 1           || session_no: || pid:
melogit cutchoice c.earned##c.equal            i.round coopchoicealter_cut if version == 2           || session_no: || pid:
melogit cutchoice c.earned##c.equal  i.version i.round coopchoicealter_cut if              round < 9 || session_no: || pid:
melogit cutchoice c.earned##c.equal##i.version i.round coopchoicealter_cut if              round < 9 || session_no: || pid:

// Add tie choice ~ local inequality
melogit addchoice    ginilocal            i.round if                 version == 1            || session_no: || pid:
melogit addchoice    ginilocal            i.round if                 version == 2            || session_no: || pid:
melogit addchoice    ginilocal  i.version i.round if                              round < 9  || session_no: || pid:
melogit addchoice  c.ginilocal##i.version i.round if                              round < 9  || session_no: || pid:
// Cut tie choice ~ local inequality
melogit cutchoice    ginilocal            i.round if                 version == 1            || session_no: || pid:
melogit cutchoice    ginilocal            i.round if                 version == 2            || session_no: || pid:
melogit cutchoice    ginilocal  i.version i.round if                              round < 9  || session_no: || pid:
melogit cutchoice  c.ginilocal##i.version i.round if                              round < 9  || session_no: || pid:

// Cooperation ~ local inequality
melogit coopchoice   ginilocal            i.round if coop_dup <= 1 & version == 1            || session_no: || pid:
melogit coopchoice   ginilocal            i.round if coop_dup <= 1 & version == 2            || session_no: || pid:
melogit coopchoice   ginilocal  i.version i.round if coop_dup <= 1 &              round < 10 || session_no: || pid:
melogit coopchoice c.ginilocal##i.version i.round if coop_dup <= 1 &              round < 10 || session_no: || pid:



/* SESSION-LEVEL ANALYSES */

insheet using "path/to/session_data.csv", clear

// Add tie choice ~ conditions
mixed addchoice c.earned##c.equal            i.round                     if version == 1           || session_no:
mixed addchoice c.earned##c.equal            i.round                     if version == 2           || session_no:
mixed addchoice c.earned##c.equal  i.version i.round                     if              round < 9 || session_no:
mixed addchoice c.earned##c.equal##i.version i.round                     if              round < 9 || session_no:
mixed addchoice c.earned##c.equal            i.round coopchoicealter_add if version == 1           || session_no:
mixed addchoice c.earned##c.equal            i.round coopchoicealter_add if version == 2           || session_no:
mixed addchoice c.earned##c.equal  i.version i.round coopchoicealter_add if              round < 9 || session_no:
mixed addchoice c.earned##c.equal##i.version i.round coopchoicealter_add if              round < 9 || session_no:
// Cut tie choice ~ conditions
mixed cutchoice c.earned##c.equal            i.round                     if version == 1           || session_no:
mixed cutchoice c.earned##c.equal            i.round                     if version == 2           || session_no:
mixed cutchoice c.earned##c.equal  i.version i.round                     if              round < 9 || session_no:
mixed cutchoice c.earned##c.equal##i.version i.round                     if              round < 9 || session_no:
mixed cutchoice c.earned##c.equal            i.round coopchoicealter_cut if version == 1           || session_no:
mixed cutchoice c.earned##c.equal            i.round coopchoicealter_cut if version == 2           || session_no:
mixed cutchoice c.earned##c.equal  i.version i.round coopchoicealter_cut if              round < 9 || session_no:
mixed cutchoice c.earned##c.equal##i.version i.round coopchoicealter_cut if              round < 9 || session_no:

// Add tie choice ~ local inequality
mixed addchoice    ginilocal            i.round if version == 1            || session_no:
mixed addchoice    ginilocal            i.round if version == 2            || session_no:
mixed addchoice    ginilocal  i.version i.round if              round < 9  || session_no:
mixed addchoice  c.ginilocal##i.version i.round if              round < 9  || session_no:
// Cut tie choice ~ local inequality
mixed cutchoice    ginilocal            i.round if version == 1            || session_no:
mixed cutchoice    ginilocal            i.round if version == 2            || session_no:
mixed cutchoice    ginilocal  i.version i.round if              round < 9  || session_no:
mixed cutchoice  c.ginilocal##i.version i.round if              round < 9  || session_no:

insheet using "path/to/session_data_coop.csv", clear

// Cooperation ~ local inequality
mixed coopchoice   ginilocal            i.round if version == 1            || session_no:
mixed coopchoice   ginilocal            i.round if version == 2            || session_no:
mixed coopchoice   ginilocal  i.version i.round if              round < 10 || session_no:
mixed coopchoice c.ginilocal##i.version i.round if              round < 10 || session_no:





/*************
*** WITHIN ***
*************/

// TODO: update with delta_int

/* INDIVIDUAL-LEVEL ANALYSES */

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
gen delta_int = earned2 * equal2 - earned1 * equal1

// Add tie choice ~ conditions
mixed delta_addchoice c.delta_earned##c.delta_equal                           i.round || session_no: || pid:
mixed delta_addchoice c.delta_earned##c.delta_equal delta_coopchoicealter_add i.round || session_no: || pid:
// Cut tie choice ~ conditions
mixed delta_cutchoice c.delta_earned##c.delta_equal                           i.round || session_no: || pid:
mixed delta_cutchoice c.delta_earned##c.delta_equal delta_coopchoicealter_cut i.round || session_no: || pid:

// Add tie choice ~ local inequality
mixed delta_addchoice  delta_ginilocal i.round                  || session_no: || pid:
// Cut tie choice ~ local inequality
mixed delta_cutchoice  delta_ginilocal i.round                  || session_no: || pid:

// Cooperatation ~ local inequality
mixed delta_coopchoice delta_ginilocal i.round if coop_dup <= 1 || session_no: || pid:



/* SESSION-LEVEL ANALYSES */

insheet using "path/to/session_data_within.csv", clear

gen delta_earned_i = delta_earned
gen delta_equal_i  = delta_equal
replace delta_earned_i = 2 if delta_earned == -1
replace delta_equal_i  = 2 if delta_equal  == -1

// Add tie choice ~ conditions
mixed delta_addchoice c.delta_earned##c.delta_equal                           i.round || session_no:
mixed delta_addchoice c.delta_earned##c.delta_equal delta_coopchoicealter_add i.round || session_no:
// Cut tie choice ~ conditions
mixed delta_cutchoice c.delta_earned##c.delta_equal                           i.round || session_no:
mixed delta_cutchoice c.delta_earned##c.delta_equal delta_coopchoicealter_cut i.round || session_no:

// Add tie choice ~ local inequality
mixed delta_addchoice  delta_ginilocal i.round || session_no:
// Cut tie choice ~ local inequality
mixed delta_cutchoice  delta_ginilocal i.round || session_no:

insheet using "path/to/session_data_within_coop.csv", clear

// Cooperatation ~ local inequality
mixed delta_coopchoice delta_ginilocal i.round || session_no:

log close
