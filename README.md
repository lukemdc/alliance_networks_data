# alliance_networks_data
This contains the scripts to compile the Intergovernmental Alliance Networks Dataset (IAND)

Intergovernmental Alliance Networks Dataset (v1)

---INTRODUCTION---
The Intergovernmental Alliance Networks Dataset (IAND) is new tool for international relations scholars to quantitatively analyze alliance formation, interstate conflict, and co-membership networks in international organizations.  IAND is compiled in Python and processed in Stata.  This README briefly describes the data and how it is compiled.  The full codebook is released separately.

IAND aims to spur to new quantitative international relations scholarship in two ways.  
1) It provides the first publically available dataset that contains the Jaccard Index and Hamming Distance between two nation-states’ diplomatic networks.  For our purposes, a state’s diplomatic network is defined as the set of international organizations (IOs) and treaty regimes in which the state participates in a given year (full list of IOs in Themnér and Wallensteen 2014).  The Jaccard and Hamming variables provide two alternative measures of the similarity between two states’ international diplomatic networks.
2) IAND also aims to add value by transforming and compiling classic IR datasets into dyad-years.  The barrier to this has been disparate coding schemes and the difficulties transforming monadic data into dyads.  IAND uses nearest-matching dictionaries and hand-coded error-correction methods to reconcile observations from six different datasets created by other scholars.  The result is a rich set of dyadic covariates which can facilitate a variety of multiple regression or cluster analyses.

---INSTRUCTIONS FOR COMPILING IAND---
1) Set directory to the folder containing all of the scripts and source data.  
2) In a command prompt, open python and import IAND_compile.py. This script builds IAND using the source data files and several other scripts. Each of called script recodes and transforms one of the source datasets. The output is built as a .txt file. Convert the .txt file to a .csv file.  Please note that adding the bilateral trade data takes significantly more time than adding the other variables.  If you do not need trade data, you can comment out the append_trade function in the IAND_compile.py main function; this will skip the trade data when IAND_compile is run.
3) In Stata, run IAND_v1_cleaner.do.  This removes remaining errors in the data and prepares it for analysis as a .dta or .csv.

---SOURCE DATA---
Data for Jaccard Index and Hamming Distance between Diplomatic Networks:  Intergovernmental Organization Dataset for Dyad Units v2.3 (Pevehouse and Nordstrom 2005)
Alliance Data: Correlates of War Formal Interstate Alliance Dataset v4 (Gibler 2013)
Conflict Data: UCDP/PRIO Armed Conflict Dataset v4 (Themnér and Wallensteen 2014; v1 from Gleditsch et al. 2002)
Political Freedom Data from: Freedom House’s Freedom in the World Index (Freedom House 2015)
Geographic Regions: United Nations Statistics Division Geoscheme
Bilateral Trade: Correlates of War Trade Data Set v3 (Barbieri and Keshk 2012)

