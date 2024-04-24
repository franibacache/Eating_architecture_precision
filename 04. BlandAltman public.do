********************************
** by: Francisca Ibacache
** date: 17/02/2023
********************************

* Analysis – Bland-Altman analysis

use "/PATH/TO/FILE/Eating Architecture MS vs AT 7y.dta", clear

*** Traditional Bland and Altman plots (limits of agreement are horizontal).

  batplot Grams_mean_AT Grams_mean_MS , info xlab(100(100)700) ylab(-500(500)500) notrend
  batplot EnergyKcal_mean_AT EnergyKcal_mean_MS , info xlab(100(300)700) ylab(-600(200)400) notrend
  batplot n_occasions_mean_AT n_occasions_mean_MS , info xlab(2(2)10) ylab(-5(5)10) notrend
  batplot TimeFirst_mean_AT TimeFirst_mean_MS , info xlab(300(100)800) ylab(-400(200)500) notrend
  batplot TimeLast_mean_AT TimeLast_mean_MS  , info xlab(800(200)1300) ylab(-400(200)200) notrend
  batplot EatingPeriod_mean_AT EatingPeriod_mean_MS , info xlab(300(300)900) ylab(-800(400)600) notrend
  batplot InterMealInterval_mean_AT InterMealInterval_mean_MS , info xlab(100(100)300) ylab(-200(100)100) notrend


*** Same B-A analysis but showing trend

  batplot Grams_mean_AT Grams_mean_MS , info xlab(100(100)700) ylab(-500(500)500)
  batplot EnergyKcal_mean_AT EnergyKcal_mean_MS , info xlab(100(300)700) ylab(-600(200)400)
  batplot n_occasions_mean_AT n_occasions_mean_MS , info xlab(2(2)10) ylab(-5(5)10)
  batplot TimeFirst_mean_AT TimeFirst_mean_MS , info xlab(300(100)800) ylab(-400(200)500)
  batplot TimeLast_mean_AT TimeLast_mean_MS  , info xlab(800(200)1300) ylab(-400(200)200)
  batplot EatingPeriod_mean_AT EatingPeriod_mean_MS , info xlab(300(300)900) ylab(-800(400)600)
  batplot InterMealInterval_mean_AT InterMealInterval_mean_MS , info xlab(100(100)300) ylab(-200(100)100)
  

