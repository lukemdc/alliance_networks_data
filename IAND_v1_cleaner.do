*Intergovernmental Alliance Networks Dataset (v1)

clear all
set more off
import delimited "C:\data\IAND_preprocessed.csv"
save "C:\data\IAND_preprocessed.dta", replace

*generate unique IDs for the dyads 
gen id_temp=country1+" "+country2
egen dyad_id = group(id_temp)
drop id_temp
*clean duplicate observations
unab vlist : _all
sort `vlist'
quietly by `vlist':  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup
duplicates list dyad_id year
duplicates tag dyad_id year, gen(isdup)
drop isdup
duplicates drop year country1 country2, force

*declare time series and destring political freedom data
tsset dyad_id year, yearly
destring pr_c1 cl_c1 pr_c2 cl_c2, replace force float

*remove remaining city-states and island states that possibly weren't excluded in python 
foreach x in "Marshall Is" "Liechtenstein" "Trinidad-Tobago" "Monaco" "Malta" "San Marino" "Singapore" "Western Samoa" "Sao Tomé-Principe" "FYROMacedonia" "Andorra" "Micronesia FS" "St Kitts-Nevis" "St Vincent-Grenadines" "country" "Solomon Is" "St Lucia" "Vanuatu"{
	drop if country1=="`x'" | country2=="`x'"
}

*correct several country names
replace country1="Egypt" if country1=="Egypt/UAR"
replace country2="Egypt" if country2=="Egypt/UAR"

replace country1="Libya" if country1=="Libyan"
replace country2="Libya" if country2=="Libyan"

replace country1="New Zealand" if country1=="New Zeland"
replace country2="New Zealand" if country2=="New Zeland"

replace country1="Vietnam South" if country1=="Vietnam Sorth"
replace country2="Vietnam South" if country2=="Vietnam Sorth"

replace country1="Burkina Faso" if country1=="Burkina Faso/UV"
replace country2="Burkina Faso" if country2=="Burkina Faso/UV"

replace country1="Benin" if country1=="Benin/Dahomey"
replace country2="Benin" if country2=="Benin/Dahomey"

*correct some of the regional dummies
replace southeastern_asia=1 if country1=="Vietnam South" | country2=="Vietnam South"
replace southeastern_asia=1 if country1=="Papua New Guinea" | country2=="Papua New Guinea"
replace western_asia=1 if country1=="South Yemen" | country2=="South Yemen"
replace western_asia=1 if country1=="Nouth Yemen" | country2=="North Yemen"
replace australia_newzeland=1 if country1=="New Zealand" | country2=="New Zealand"
replace western_europe=1 if country1=="Germany East" | country2=="Germany East"
replace western_europe=1 if country1=="Germany West" | country2=="Germany West"
replace southeastern_asia=1 if country1=="Cambodia/Kampuchea" | country2=="Cambodia/Kampuchea"
replace southern_europe=1 if country1=="Yugoslavia/Serbia and Montenegro" |country2=="Yugoslavia/Serbia and Montenegro"
replace western_africa=1 if country1=="Benin" | country2=="Benin"
replace western_africa=1 if country1=="Berkina Faso" | country2=="Burkina Faso"
replace northern_africa=1 if country1=="Egypt" | country2=="Egypt"
replace northern_africa=1 if country1=="Libya" | country2=="Libya"
replace eastern_europe=1 if country1=="Czechoslovakia" | country2=="Czechoslovakia"
replace western_africa=1 if country1=="Côte d'Ivoire" | country2=="Côte d'Ivoire"
replace east_africa=1 if country1=="Madagascar/Malagasy" |country2=="Madagascar/Malagasy"
replace east_africa=1 if country1=="Zimbabwe/Rhodesia" |country2=="Zimbabwe/Rhodesia"

*gen regional dummies that combine UN subregions
gen subsahara=0
replace subsahara=1 if western_africa==1 | middle_africa==1 | east_africa==1 | southern_africa==1
replace subsahara=0 if western_africa==0 & middle_africa==0 & east_africa==0 & southern_africa==0

gen mena=0
replace mena=1 if northern_africa==1 | western_asia==1
replace mena=0 if northern_africa==0 & western_asia==0
replace mena=0 if country1=="Sudan" | country2=="Sudan"

gen western_countries=0
replace western_countries=1 if north_america==1 | western_europe==1 | northern_europe==1
replace western_countries=0 if north_america==0 & western_europe==0 & northern_europe==0
*include spain, portugal, italy in western countries
replace western_countries=1 if country1=="Spain" |country1=="Portugal" | country1=="Italy" | country2=="Spain" | country2=="Portugal" | country2=="Italy"

egen same_temp=rowtotal(western_countries subsahara mena caribbean central_america south_america central_asia eastern_asia southern_asia southeastern_asia eastern_europe southern_europe australia_newzeland)
gen same_region=1 if same_temp==1
replace same_region=0 if same_temp==2 | same_temp==3

*for some reason this is giving a lot of missing data
foreach x in western_countries subsahara mena {
	gen `x'_same=same_region*`x'
}

*generate interactive PR and CL
*PR (political rights) lower is better [1,7]
*CL (civil liberties) lower is better [1,7]
gen PR_cross=pr_c1*pr_c2
replace PR_cross=. if missing(pr_c1) | missing(pr_c2)
gen CL_cross=cl_c1*cl_c2
replace CL_cross=. if missing(cl_c1) | missing(cl_c2)
gen democratic_dyad=.
replace democratic_dyad=1 if freedom_c1=="F" & freedom_c2=="F"
replace democratic_dyad=0 if freedom_c1!="F" | freedom_c2!="F"
replace democratic_dyad=. if missing(freedom_c1) | missing(freedom_c2)

*generate dummy that is 1 if the states have any type of an alliance and generate lagged alliance dummmy
gen alliance_any=.
replace alliance_any=1 if alliance_defense==1 | neutrality==1 | nonaggression==1 | entente==1
replace alliance_any=0 if alliance_defense==0 & neutrality==0 & nonaggression==0 & entente==0
bysort country1 country2 (year): gen alliance_any_lag1=alliance_any[_n+1]

/*You can use the following line to do a k-means cluster analysis with 500 iterations and 10 clusters.  This does not bin the cluster by year.
*cluster kmeans intersection_count union_count jaccard_index inter_jac_same trade pr_c1 cl_c1 pr_c2 cl_c2 subsahara mena western_countries same_region PR_cross CL_cross democratic_dyad alliance_any, k(10) measure(L2) start(krandom(123)) iterate(500)
*graph matrix interstate_conflict jaccard_index union_count alliance_any, m(i) mlabel(_clus_2) mlabpos(0)
foreach num in 1 2 3 4 5 6 7 8 9 10 {
	gen _clus_1`num'=0
	replace _clus_1`num'=1 if _clus_1==`num'	
*/

save "C:\data\IAND_v1.dta", replace
export delimited using "C:\data\IAND_v1.dta", replace
