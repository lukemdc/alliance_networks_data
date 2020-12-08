#import os
#os.chdir('C:\\data\\IAND_v1')
#os.getcwd()
from networks_jaccard import append_jaccard
from networks_conflict import append_conflicts
from networks_regions import append_regions
from networks_trade import append_trade
from networks_alliances import append_alliances
from networks_freedom import append_freedom
from txt_to_csv import convert_to_csv 
import time
def compile_data(filename):
    start=time.time()
    print "starting to compile IAND"
    #append_jaccard calculates the jaccard and hamming distances between two state's IGO networks.
    append_jaccard(filename,"IGO_stateunit_v2.txt")
    #next, each of the following scripts adds variables from one of the source datasets.
    #a temporary .txt is created each time to facilitate editing of the compilation code
    append_alliances(filename[:-4]+'_jaccard.txt',"alliance_sourcedata.txt")
    append_conflicts(filename[:-4]+'_jaccard_alliances.txt',"conflict_prio_complete_sourcedata.txt")
    append_freedom(filename[:-4]+'_jaccard_alliances_conflicts.txt',"freedomhouse_sourcedata.txt")
    append_regions(filename[:-4]+'_jaccard_alliances_conflicts_freedom.txt')
    append_trade(filename[:-4]+'_jaccard_alliances_conflicts_freedom_regions.txt',"trade_sourcedata.txt")
    open("IAND_maier_v1_preprocessed.txt", "w").writelines([l for l in open(filename[:-4]+'_jaccard_alliances_conflicts_freedom_regions_trade.txt').readlines()])    
    stop=time.time()
    convert_to_csv("IAND_maier_v1_preprocessed.txt")
    print "done compiling IAND"
    print "this compilation took: ", stop-start
    print "final file name: IAND_maier_v1_preprocessed.txt"
    return 0
compile_data("temp_build_IAND_maier_v1.txt")
