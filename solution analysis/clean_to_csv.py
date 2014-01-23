'''
Created on Jan 9, 2013

@author: francky
'''

import csv
import os
import glob
import sys

# Global constants
MAX_PACKAGE_NUMBER = 21
PATIENT_NAMES = ["a40006", "a40012", "a40050", "a40051", "a40064", "a40076", "a40096", "a40099", "a40113", "a40119", "a40125", "a40172", "a40207", "a40215", "a40225", "a40234", "a40260", "a40264", "a40277", "a40282", "a40329", "a40376", "a40384", "a40424", "a40439", "a40473", "a40493", "a40551", "a40764", "a40834", "a40921", "a40928", "a41137", "a41177", "a41200", "a41434", "a41447", "a41466", "a41495", "a41664", "a41770", "a41925", "a41934", "a42141", "a42259", "a42277", "a42397", "a42410"]
NB_SOLUTIONS_PER_LOG = 10



def main():
    '''
    This is the main function
    '''
    
    print("started")
    
    # Read file and clean it
    
#    # Set main paths
#    path = './dump/transition_test_data/raw/'
#    path_analysis = './dump/transition_test_data/analysis/'
#    path_output = './dump/transition_test_data/processed/'
    
    path = './dump/transition_train_data/raw/'
    path_analysis = './dump/transition_train_data/analysis/'
    path_output = './dump/transition_train_data/processed/'
    
    # clean open global files
    file_analysis = open(path_analysis + "solutions_all_class-action-fired.csv", 'w')
    file_analysis_solution  = {}
    
    for solution in range( 100):
        file_analysis_solution[solution] = open(path_analysis + "solutions_"+str(solution)+ "_class-action-fired.csv", 'w')
    
    file_analysis_patient  ={}
    for patient in PATIENT_NAMES:
        file_analysis_patient[patient] = open(path_analysis + "solutions_"+patient+ "_class-action-fired.csv", 'w')
    
    
    
    for package in glob.glob(os.path.join(path, '*')):
        print package
        name=package.split('2013_01_04_12_57_28_0_')[1] # 2013_01_04_12_57_28_0_dump_0_gene_a40006_4
        patient =package.split('gene_')[1].split ("_") [0] # 2013_01_04_12_57_28_0_dump_0_gene_a40006_4
        solution=package.split('2013_01_04_12_57_28_0_dump_')[1].split ("_") [0] # 2013_01_04_12_57_28_0_dump_0_gene_a40006_4
        file = open(package, 'r')
        file_output = open(path_output  + name +".csv", 'w')
        
        for cur_line in file:
            if (cur_line.find('# sample_id') >= 0):
                continue
            cur_line =cur_line.replace(" /scratch/erik/clean_v5/v5/generator/data/test/", "")
            cur_line =cur_line.replace(" /scratch/erik/clean_v5/v5/generator/data/train/", "")
            cur_line =cur_line.replace(".gdp", "")
#            line = cur_line.split("  ")in
#            line[1]=line[1].replace(" 1,")
#            line[1]=line[1].replace(" 2,")
#            line[1]=line[1].replace(" 3,")
#            line[1]=line[1].replace(" 4,")
            cur_line =cur_line.replace(" ", "")
                
            line = cur_line.split(",")
#            for item in line:
                     
#            file_output.write(cur_line)
            file_analysis_solution[int(solution)].write(",".join(line[-3::]))
            file_analysis_patient[patient].write(",".join(line[-3::]))
            file_analysis.write(",".join(line[-3::])) 
            
        
        file.close()
        file_output.close()
        
#        break
    
    file_analysis.close()

if __name__ == "__main__":
    main()