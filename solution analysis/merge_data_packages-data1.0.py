'''
Created on Jan 11, 2013

@author: francky <franck.dernoncourt@gmail.com>

Description: script parsing data packages to generate the files needed for generate_graphs_from_data_packages1.0.m

Use: 
* configure the  global constants
* Data packages should be name patientname_packagenumber.csv (e.g. patient_a40051.csv)

'''


import csv
import os
import glob
import sys

## Global constants
# To be configured
path = './data_packages1.0/' # The data packages location
path_output  ='./data_packages1.0/processed/' # the location of the files created by the script

# Internal global constants, don't touch it
patient_list={}
patient_rows_total_number={}
patient_rows_total_number['total'] = 0

# old
#INDIVIDUAL_NAMES = ["a40006", "a40012", "a40050", "a40051", "a40064", "a40076", "a40096", "a40099", "a40113", "a40119", "a40125", "a40172", "a40207", "a40215", "a40225", "a40234", "a40260", "a40264", "a40277", "a40282", "a40329", "a40376", "a40384", "a40424", "a40473", "a40493", "a40551", "a40834", "a40921", "a40928", "a41177", "a41200", "a41434", "a41447", "a41466", "a41495", "a41664", "a41770", "a41925", "a41934", "a42141", "a42259", "a42277", "a42397"]
#MAX_PACKAGE_NUMBER = 21


def append_package_to_individual(individual_so_far, new_package, name):
    '''
    Append one data package to the whole individual data
    '''   
    
    # Read file and clean it
    try:
        file = open(new_package, 'r')
        file_output = open(individual_so_far, 'a')
        
        for cur_line in file:
            line = cur_line.replace("\n", "").split(",")
            if (len(line) <> 6 or cur_line.find('sampleId') >= 0): # make sure we are in a data row
                continue
            file_output.write(cur_line)
            patient_rows_total_number[name] += 1
        
        file.close()
        file_output.close()
    finally:
        pass
    

def get_patient_list():
    '''
    Get the list of the patient names
    '''

    for package in glob.glob(os.path.join(path, '*.csv')):
        package = package.replace(".csv", "")
        line = package.split  ("data_packages1.0\\")  [1].split("_")
        name  = line[0]
        package_ID =line[1]
        if not name in patient_list:
            patient_list[name] = []
            patient_rows_total_number[name] = 0
        patient_list[name].append(package_ID)
        print "Currently preprocessing package: " + package
    
    
    
    
    
def main():
    '''
    This is the main function
    '''
    # Clear files    
    file_output = open(path_output+"patient_all.csv",'w')       
    file_output.close()
    
    get_patient_list()
    print patient_list
    
    # Go through every data packages
    for package in glob.glob(os.path.join(path, '*.gdp')):
#        print "current file is: " + package
#        append_package_to_individual(path+"individuals_all.txt", package)
        pass
    
    # Go through every data packages for every individual
    for name, packages in patient_list.items():
        individual_whole_data_file = "patient_" + name + ".csv"
        file_output = open(path_output+individual_whole_data_file,'w')       
        file_output.close()  
        print "Currently processing patient is: " + name  
        for package in packages:
            package= name + "_" + package + ".csv"
            append_package_to_individual(path_output+"patient_all.csv", path+package, name)
            append_package_to_individual(path_output+individual_whole_data_file, path+package, 'total')
    
    # Save global variables to files
    writer = csv.writer(open(path_output + "name_list.txt", 'wb'))
    for key, value in patient_list.items():
        writer.writerow([key])      

    writer = csv.writer(open(path_output + "name_list_number_of_packages.txt", 'wb'))
    for key, value in patient_list.items():
        writer.writerow([len(value)])
        
    writer = csv.writer(open(path_output + "name_list_number_of_rows.txt", 'wb'))
    for key, value in patient_list.items():
        writer.writerow([patient_rows_total_number[key]])    
        
        
if __name__ == "__main__":
    main()