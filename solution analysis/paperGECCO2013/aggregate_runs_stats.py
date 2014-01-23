'''
Created on Jan 30, 2013

@author: francky
'''

import csv
import os
import sys
import time

import parse_dump_callable

# Global constants
MAX_PACKAGE_NUMBER = 21
INDIVIDUAL_NAMES = ["a40006", "a40012", "a40050", "a40051", "a40064", "a40076", "a40096", "a40099", "a40113", "a40119", "a40125", "a40172", "a40207", "a40215", "a40225", "a40234", "a40260", "a40264", "a40277", "a40282", "a40329", "a40376", "a40384", "a40424", "a40439", "a40473", "a40493", "a40551", "a40764", "a40834", "a40921", "a40928", "a41137", "a41177", "a41200", "a41434", "a41447", "a41466", "a41495", "a41664", "a41770", "a41925", "a41934", "a42141", "a42259", "a42277", "a42397", "a42410"]
NB_SOLUTIONS_PER_LOG = 20

# Global variables
percentage_correct_in_solutions_vs_packages = {}


#def get_accuracy(filename ):
#    '''
#    
#    '''
#    accuracy=  []
#    file = open(filename, 'r')
#    for cur_line in file:
#        if (cur_line.find('Fitness accuracy:') >= 0):
#            accuracy.append(float(cur_line.split(": ")[1]))
#                    
#    return  sorted(accuracy,reverse=True)




def get_accuracy(filename ):
    '''
    
    '''
    accuracy=  [0 for j in range(NB_SOLUTIONS_PER_LOG)]
#    file = open(filename, 'r')
#    for cur_line in file:
#        if (cur_line.find('Fitness accuracy:') >= 0):
#            accuracy.append(float(cur_line.split(": ")[1]))
                    
    parse_dump_callable.initialize_global_variables()
    result = parse_dump_callable.parse_dump_training_and_testing(filename)            
    if result == -1:
        print "boom"
#        time.sleep(5) 
        return  sorted(accuracy,reverse=True)
    path = "/".join(filename.split("/")[0:-1]) +  "/"
    print path 
    parse_dump_callable.post_process(path)
    accuracy=parse_dump_callable.get_accuracy()
#    print fitness_vs_packages_stats_per_solution
    
    return  sorted(accuracy,reverse=True)


def get_accuracy2(filename):
    parse_dump_callable.initialize_global_variables()
    accuracy=  [0 for j in range(NB_SOLUTIONS_PER_LOG)]
    path = "/".join(filename.split("/")[0:-1]) +  "/"
    
    for individual in range  (NB_SOLUTIONS_PER_LOG):
        confusion_matrix_file = "global_confusion_matrix"+ str(individual) +"_ratio.txt"
        confusion_matrix = [[0 for j in range(3)]  for i in range(4)]
        if not os.path.isfile(path+confusion_matrix_file):
            continue    
        file = open(path+confusion_matrix_file, 'r')
        count =  0
        for cur_line in file:
            line = cur_line.split(",")
            for i in range  (len(line)):
                confusion_matrix[count][i]=float(line[i])
            count += 1
        print confusion_matrix 
        
        accuracy[individual]=  confusion_matrix[0][0]+confusion_matrix[1][1] +confusion_matrix[2][2]
    
    print accuracy
#    sys.exit(1)
    
    return  sorted(accuracy,reverse=True)
    

def main():
    '''
    This is the main function
    '''
    number_of_run = 7
    number_of_experiment =12
    base  = "./dump/gecco2013runs/"
    file_output_accuracy  = csv.writer(open(base  + "accuracy"  + '.csv', 'wb'))
    file_output_accuracy2  = csv.writer(open(base  + "accuracy2"  + '.csv', 'wb'))
    
    for experiment_number in range  (number_of_experiment):
        for run in range(1, number_of_run+1):
            filename = base + str(experiment_number)+  "_"+str (run)+  "/"+   str(experiment_number)+  "_"+str (run)+ "_" #test.log"
            print filename 
            file_output_accuracy.writerow(get_accuracy(filename))
            file_output_accuracy2.writerow(get_accuracy2(filename)) 
          
        
    
    
    

if __name__ == "__main__":
    main()