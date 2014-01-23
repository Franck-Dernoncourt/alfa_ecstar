'''
Created on Jan 3, 2013
'''

import csv
import os
import glob
import sys

# Global constants
MAX_PACKAGE_NUMBER = 21
INDIVIDUAL_NAMES = ["a40006", "a40012", "a40050", "a40051", "a40064", "a40076", "a40096", "a40099", "a40113", "a40119", "a40125", "a40172", "a40207", "a40215", "a40225", "a40234", "a40260", "a40264", "a40277", "a40282", "a40329", "a40376", "a40384", "a40424", "a40439", "a40473", "a40493", "a40551", "a40764", "a40834", "a40921", "a40928", "a41137", "a41177", "a41200", "a41434", "a41447", "a41466", "a41495", "a41664", "a41770", "a41925", "a41934", "a42141", "a42259", "a42277", "a42397", "a42410"]
NB_SOLUTIONS_PER_LOG = 10

# Global variables
percentage_correct_in_solutions_vs_packages = {}
confusion_matrix_solution = [[[0 for k in range(3)] for j in range(4)] for i in range(NB_SOLUTIONS_PER_LOG)]
confusion_matrix_solution_ratio = [[[0 for k in range(3)] for j in range(4)] for i in range(NB_SOLUTIONS_PER_LOG)]
fitness_vs_packages_stats = {}
fitness_vs_packages_stats_per_solution = [{} for i in range(NB_SOLUTIONS_PER_LOG)]
class_summary = [[[0 for j in range(4)] for i in range(3)] for k in range(NB_SOLUTIONS_PER_LOG)]  # Matrix: https://plus.google.com/u/0/photos/instantupload/5830824159768298306
actions = [[] for i in range(NB_SOLUTIONS_PER_LOG)]
count_class =[[0 for k in range(3)]  for i in range(NB_SOLUTIONS_PER_LOG)]

def main():
    '''
    This is the main function
    '''
    initialize_global_variables()
    
    # Run statistics on data packages
    parse_packages()
    
    # Go through every log files
    path = './dump/'
    for dump_file in glob.glob(os.path.join(path, '*.log')):
        print "current file is: " + dump_file
        parse_dump(dump_file)
    
            
    # Computed average fitness for every solution in the log file
    # !!! We suppose favorite    
    for key, value in percentage_correct_in_solutions_vs_packages.items():
        fitness_vs_packages_stats[key][0] += sum(value) / float(len(value)) # average
        if fitness_vs_packages_stats[key][0] > 100:
            sys.exit(1)
            
    pre_process_global_variables()
    
    # Save global variables to files
    print "Saving global variables to files"
    path = './dump/'
    dump_file = "global_"
    writer = csv.writer(open(path + dump_file + "percentage_correct_in_solutions_vs_packages.txt", 'wb'))
    for key, value in percentage_correct_in_solutions_vs_packages.items():
        writer.writerow(value)
    writer = csv.writer(open(path + dump_file + "percentage_correct_in_solutions_vs_packages_labels.txt", 'wb'))
    for key, value in percentage_correct_in_solutions_vs_packages.items():
        writer.writerow([key])        

    for i in range(NB_SOLUTIONS_PER_LOG):
        wr = csv.writer(open(path + dump_file + "confusion_matrix" + str(i) + "_ratio.txt", 'wb'))
        for ii in range(4):
            wr.writerow(confusion_matrix_solution_ratio[i][ii])
    
    writer = csv.writer(open(path + dump_file + "fitness_vs_packages_stats.txt", 'wb'))
    for key, value in fitness_vs_packages_stats.items():
        writer.writerow(value)
    writer = csv.writer(open(path + dump_file + "fitness_vs_packages_stats_labels.txt", 'wb'))
    for key, value in fitness_vs_packages_stats.items():
        writer.writerow([key])
    
    for solution in range(NB_SOLUTIONS_PER_LOG):
        writer = csv.writer(open(path + dump_file + "fitness_vs_packages_stats_per_solution" + str(solution) + ".txt", 'wb'))
        for key, value in fitness_vs_packages_stats_per_solution[solution].items():
            writer.writerow(value)
            
      
    for solution in range(NB_SOLUTIONS_PER_LOG):
        writer = csv.writer(open(path + dump_file + "class_summary_per_solution" + str(solution) + ".txt", 'wb'))
        for i in range  (3): #class_summary[solution]:
            writer.writerow(class_summary[solution][i])
    

def initialize_global_variables():
    '''
    Initialize the global variables
    '''
    
    # Build percentage correct matrix (solutions x packages)
    for name in INDIVIDUAL_NAMES:
        for j in range(MAX_PACKAGE_NUMBER):
            percentage_correct_in_solutions_vs_packages[name + "_" + str(j + 1)] = [0 for i in range(NB_SOLUTIONS_PER_LOG)]
    
    # Build percentage correct matrix (solutions x packages)
    for name in INDIVIDUAL_NAMES:
        for j in range(MAX_PACKAGE_NUMBER):
            fitness_vs_packages_stats[name + "_" + str(j + 1)] = [0 for i in range(5)] # 5, because we have 1 fitness + 4 stats on packages
    
    # Build fitness_vs_packages_stats_per_solution
    for solution in range(NB_SOLUTIONS_PER_LOG):
        for name in INDIVIDUAL_NAMES:
            for j in range(MAX_PACKAGE_NUMBER):
                fitness_vs_packages_stats_per_solution[solution][name + "_" + str(j + 1)] = [0 for i in range(5)] # 5, because we have 1 fitness + 4 stats on packages


def pre_process_global_variables():
    '''
    Compute some global variables after parsing the files
    '''
    # https://plus.google.com/u/0/photos/instantupload/5830824159768298306        
    for solution in range(NB_SOLUTIONS_PER_LOG):
        for action in actions[solution]:
            count_class[solution][action] += 1
        for i in range (3):
            class_summary[solution][i][0] = i
            sum_row =  0
            for ii in range(3):
                sum_row += confusion_matrix_solution_ratio[solution][i][ii] 
            if sum_row ==  0:
                class_summary[solution][i][1] =  0
            else:
                class_summary[solution][i][1] = confusion_matrix_solution_ratio[solution][i][i] / float(sum_row) 
            class_summary[solution][i][2] = confusion_matrix_solution_ratio[solution][i][i] 

            print float(count_class[solution][i]),len (actions[solution])
            class_summary[solution][i][3] = float(count_class[solution][i]) / len (actions[solution])
        

def parse_dump(dump_file):
    '''
    Extract statistics from dump file 
    '''
    file = open(dump_file, 'r')
    filename = dump_file
#    file_output = open(dump_file + "_parsed.txt", 'w')
    in_confusion_matrix = False
    in_count = False
    data = {}
    confusion_matrix = [[0 for j in range(3)] for i in range(4)]
    confusion_total_number_of_elements = 0
      
    for cur_line in file:
        # Check in which solution we are
        if (cur_line.find('+++++') >= 0):
            solution = int(cur_line.split("dump_")[1].split("_gene.xml")[0]) - 1
            actions[solution] = []
           
        if (cur_line.find('<*') >= 0): 
            actions[solution].append(int(cur_line.split("-->>> Label == ")[1].split(",")[0]))
#            print action
            
        # Make sure we are in a Confusion Matrix section
        if (cur_line.find('Local Confusion Matrix') >= 0):
            in_confusion_matrix = True
            # if we are at line 'Local Confusion Matrix: a40076_16.gdp', get individual ID a40076 and package ID 16  
            ID = cur_line.split(": ")[1].split(".")[0].split("_")
            individual_ID = ID[0]
            package_ID = int(ID[1])
             
            
        if not in_confusion_matrix: continue
        
        # Aggregate Percent Correct for every individual
        if (cur_line.find('Percent Correct:') >= 0):
            value = float(cur_line.split(": ")[1].replace("\n", ""))
            percentage_correct_in_solutions_vs_packages[individual_ID + "_" + str(package_ID)][solution] = value
            fitness_vs_packages_stats_per_solution[solution][individual_ID + "_" + str(package_ID)][0] = value
            if not individual_ID in data:
                data[individual_ID] = [-20 for j in range(MAX_PACKAGE_NUMBER)]
            # For heatmap            
            data[individual_ID][package_ID - 1] = value
            
        # Aggregate confusion matrices
        if (cur_line.find('Counts') >= 0):
            in_count = True
        if (cur_line.find('Ratios') >= 0):
            in_count = False
        if (in_count and cur_line[0] == '0'): # code repetition is bad, but I didn't see any way to have it more concise without increasing the complexity a lot. Let me know if you find a more clear way to do it.
            confusion0 = cur_line.replace("\n", "").split("\t")
            for col in range(3):
                confusion_matrix[0][col] += int(confusion0[col + 1]) 
#                print solution-1, col
                confusion_matrix_solution[solution - 1][0][col] += int(confusion0[col + 1])
        if (in_count and cur_line[0] == '1'):
            confusion1 = cur_line.replace("\n", "").split("\t")
            for col in range(3):
                confusion_matrix[1][col] += int(confusion1[col + 1]) 
                confusion_matrix_solution[solution - 1][1][col] += int(confusion1[col + 1])
        if (in_count and cur_line[0] == '2'):
            confusion2 = cur_line.replace("\n", "").split("\t")
            for col in range(3):
                confusion_matrix[2][col] += int(confusion2[col + 1]) 
                confusion_matrix_solution[solution - 1][2][col] += int(confusion2[col + 1])
        if (in_count  and cur_line[0] == 'N'):
            confusion3 = cur_line.replace("\n", "").split("\t")
            for col in range(3):
                confusion_matrix[3][col] += int(confusion3[col + 1]) 
                confusion_matrix_solution[solution - 1][3][col] += int(confusion3[col + 1])
        
        
    # Compute confusion_matrix_ratio
    for j in range(3):
        for i in range(4):
            confusion_total_number_of_elements += confusion_matrix[i][j]
    confusion_matrix_ratio = [[float(confusion_matrix[i][j]) / confusion_total_number_of_elements for j in range(3)] for i in range(4)]
        
    # Compute confusion_matrix_solution_ratio
    confusion_total_number_of_elements_in_one_solution = [0 for i in range(NB_SOLUTIONS_PER_LOG)] 
    for k in range(NB_SOLUTIONS_PER_LOG):
        for j in range(3):
            for i in range(4):
                confusion_total_number_of_elements_in_one_solution[k] += confusion_matrix_solution[k][i][j]
    for k in range(NB_SOLUTIONS_PER_LOG):
        for j in range(3):
            for i in range(4):
                confusion_matrix_solution_ratio[k][i][j] = float(confusion_matrix_solution[k][i][j]) / confusion_total_number_of_elements_in_one_solution[k]
#    confusion_matrix_ratio[k] = [[float(confusion_matrix[k][i][j]) / confusion_total_number_of_elements_in_one_solution[k] for j in range(3)] for i in range(4)]
             
    
    print data
    print confusion_total_number_of_elements
    print confusion_matrix
    print confusion_matrix_ratio
    
    # Save data on files
    # http://stackoverflow.com/questions/8685809/python-writing-a-dictionary-to-a-csv-file-with-one-line-for-every-key-value

    
    writer = csv.writer(open(dump_file + "_parsed.txt", 'wb'))
    for key, value in data.items():
        writer.writerow(value)

    writer = csv.writer(open(dump_file + "_names_parsed.txt", 'wb'))
    for key, value in data.items():
        writer.writerow([key])        
        
    wr = csv.writer(open(dump_file + "confusion_matrix.txt", 'wb'))
    for i in range(4):
        wr.writerow(confusion_matrix[i])
    
    wr = csv.writer(open(dump_file + "confusion_matrix_ratio.txt", 'wb'))
    for i in range(4):
        wr.writerow(confusion_matrix_ratio[i])


def parse_packages():
    '''
    Compute statistics on packages
    '''
    print "Compute statistics on packages"
     # Go through every log files
    path = './data_packages/'
    for dump_file in glob.glob(os.path.join(path, '*.gdp')):        
        parse_one_package(dump_file)
        
        
def parse_one_package(package_filename):
    '''
    Compute statistics on one package
    '''
#    print "current file is: " + package_filename
    package_name=package_filename.split("data_packages\\")[1].split(".")[0]
    
    # Read file and clean it
    package = open(package_filename, 'r')
    count_BP_outcome = [0,0,0]
    number_of_rows  = 0
    for cur_line in package:
        line = cur_line.replace("\n", "").split(",")
        if (len(line) <> 8 or cur_line.find('sampleId') >= 0): # make sure we are in a data row
            continue
        number_of_rows  += 1
#        print line[7]
        count_BP_outcome[int(line[7])] += 1
    package.close()
      
    # Compute ratio
    count_BP_outcome_ratio=[float(count_BP_outcome[i]) / number_of_rows for i in range(3)]
#    print count_BP_outcome_ratio
    
    # Save statistics
    for i in range(3):
        fitness_vs_packages_stats[package_name][i+1]=count_BP_outcome_ratio[i]
        for solution in range(NB_SOLUTIONS_PER_LOG):
            fitness_vs_packages_stats_per_solution[solution][package_name][i+1]=count_BP_outcome_ratio[i]

if __name__ == "__main__":
    main()
