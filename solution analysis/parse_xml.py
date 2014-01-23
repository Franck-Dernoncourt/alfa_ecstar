'''
Created on Dec 22, 2012

'''


import os
import glob
import sys

# Constants
variable_names = ["V1", "V2","V3","V4","V5"]

def main():
    '''
    This is the main function
    '''
    
    # Clear files
    file_output = open("individuals_main_info.txt",'w')       
    file_output.close()
    file_output = open("buckets.txt",'w')       
    file_output.close()
    file_output = open("ticks.txt",'w')       
    file_output.close()
    file_output = open("complements.txt",'w')       
    file_output.close()
    file_output = open("actions.txt",'w')       
    file_output.close()
    file_output = open("times_applied.txt",'w')       
    file_output.close()
    file_output = open("times_applied_average.txt",'w')       
    file_output.close()
    
    file_output_dictionary = {}
    for v in variable_names:
        file_output_dictionary[v] = open(v+".txt",'w')
        file_output_dictionary[v].close()
        
    

    
    # Iterate over XML files    
    path = './solutions/'
    for xml_file in glob.glob( os.path.join(path, '*.xml') ):
        print "current file is: " + xml_file
        parse_xml(xml_file)
    

def parse_xml(xml_file):
    '''
     
    '''
    
    # Export XML http://docs.python.org/2/library/xml.etree.elementtree.html
    import xml.etree.ElementTree as ET
#    filename = "2012_12_17_12_57_49_0_dump_0_gene.xml"
    filename=xml_file
    tree = ET.parse(filename)
    root = tree.getroot()
    print root[0].text
    
    # Get individual main information (= not specific to one rule )
    file_output = open("individuals_main_info.txt",'a')    
    for i in range(9):
        if i < 3: continue        
        file_output.write(root[i].text + ",")
    file_output.write("\n")
    file_output.close()
    
    # iterate over every rule    
    for rule in root.iter('Rule'):
        for condition in rule.iter('Condition'):        
#            print condition[0].text
            pass

    # iterate over every bucket
    file_output = open("buckets.txt",'a')    
    for condition in root.iter('Condition'):        
            file_output.write(condition[0].text + "\n")
    file_output.close()
    
    
    # iterate over every tick
    file_output = open("ticks.txt",'a')    
    for tick in root.iter('TickIndex'):        
            file_output.write(tick.text + "\n")
    file_output.close()
    
    # iterate over every condition and see how often we take the complement
    # FALSE = the condition is NOT negated
    # TRUE = the condition is negated
    file_output = open("complements.txt",'a')    
    for complement in root.iter('complement'):        
            if complement.text == 'false':
                file_output.write("0" + "\n")
            elif complement.text == 'true':
                file_output.write("1" + "\n")
            else:
                print "Parsing error: something is wrong with complement format"
                sys.exit(1)
                
    file_output.close()
    
    # iterate over every action
    file_output = open("actions.txt",'a')    
    for action in root.iter('action'):        
            file_output.write(action.text + "\n")
    file_output.close()
    
    # iterate over every timesApplied
    file_output = open("times_applied.txt",'a') 
    sum = 0
    number_of_rules  = 0   
    for timesApplied in root.iter('timesApplied'):        
            file_output.write(timesApplied.text + "\n")
            sum  += int(timesApplied.text)
            number_of_rules += 1
    file_output.close()
    file_output = open("times_applied_average.txt",'a')
    file_output.write(str(sum/float(number_of_rules)) + "\n")    
    file_output.close()    
    
    
    # iterate over every variables to see their values
    file_output_dictionary = {}
    for v in variable_names:
        file_output_dictionary[v] = open(v+".txt",'a')   
        for var in root.iter(v):        
                file_output_dictionary[v].write(var.text + "\n")
        file_output_dictionary[v].close()


if __name__ == "__main__":
    main()