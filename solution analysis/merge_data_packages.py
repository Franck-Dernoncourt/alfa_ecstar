'''
Created on Jan 6, 2013

@author: francky
'''


import csv
import os
import glob
import sys

# Global constants
INDIVIDUAL_NAMES = ["a40006", "a40012", "a40050", "a40051", "a40064", "a40076", "a40096", "a40099", "a40113", "a40119", "a40125", "a40172", "a40207", "a40215", "a40225", "a40234", "a40260", "a40264", "a40277", "a40282", "a40329", "a40376", "a40384", "a40424", "a40473", "a40493", "a40551", "a40834", "a40921", "a40928", "a41177", "a41200", "a41434", "a41447", "a41466", "a41495", "a41664", "a41770", "a41925", "a41934", "a42141", "a42259", "a42277", "a42397"]
MAX_PACKAGE_NUMBER = 21


def append_package_to_individual(individual_so_far, new_package):
    '''
    Append one data package to the whole individual data
    '''   
    
    # Read file and clean it
    try:
        file = open(new_package, 'r')
        file_output = open(individual_so_far, 'a')
        
        for cur_line in file:
            line = cur_line.replace("\n", "").split(",")
            if (len(line) <> 8 or cur_line.find('sampleId') >= 0): # make sure we are in a data row
                continue
            file_output.write(cur_line)
        
        file.close()
        file_output.close()
    finally:
        pass
    
def main():
    '''
    This is the main function
    '''
    # Clear files    
    path = './data_packages/'
    file_output = open(path+"patient_all.txt",'w')       
    file_output.close()
    
    # Go through every data packages
    for package in glob.glob(os.path.join(path, '*.gdp')):
#        print "current file is: " + package
#        append_package_to_individual(path+"individuals_all.txt", package)
        pass
    
    # Go through every data packages for every individual
    for name in INDIVIDUAL_NAMES:
        individual_whole_data_file = "patient_" + name + ".csv"
        file_output = open(path+individual_whole_data_file,'w')       
        file_output.close()    
        for j in range(MAX_PACKAGE_NUMBER):
            package= name + "_" + str(j + 1) + ".gdp"
            append_package_to_individual(path+"patient_all.csv", path+package)
            append_package_to_individual(path+individual_whole_data_file, path+package)
            

if __name__ == "__main__":
    main()