'''
Created on Jan 30, 2013

@author: francky
'''

import glob # http://stackoverflow.com/questions/3207219/how-to-list-all-files-of-a-directory-in-python
from subprocess import call
from os import listdir
from os.path import isfile, join
import time

def main():
    '''
    This is the main function
    '''
#    call(["ls", "-la"])
#    call(["ipconfig"])    

    base= "runs/"
    
    run = 1    
    for run in range(2, 8):
        path =base +str (run)+  "/"
    #    path = "."
        maturity_folders= [ f for f in listdir(path) if not isfile(join(path,f)) ] 
        print maturity_folders
        print maturity_folders[-1]
        path += maturity_folders[-1]+  "/sql_dumps/"
        dumps=glob.glob(path +"*.sql")
        print  dumps
        for dump in dumps:
            experiment= str(dump.split( "_dump.sql" )[0].split( "_" )[-1])
            accuracy_target =  experiment+"_"+str (run)
            print accuracy_target 
            
    #        call(["bash", "../run_pool-server.sh"])
            #Wait for servers to start
    #        time.sleep(10) # delays for 5 seconds
    
            #Clear database
#            call(['mysql',' -u',' root',' --password=gecco2005',' mitServer',' -e',' "TRUNCATE',' pool"'])
#            call(['mysql','-u root --password=gecco2005 ${dbname} -e "TRUNCATE classes"'])
#            time.sleep(10)
            # Load database and get accuracy
            call(["bash", "load_one_data_base_and_get_accuracy.sh", dump,"10","127.0.0.1", "8181", accuracy_target])
            
            print "ok"
    #        call(["bash", "../kill_single_run.sh"])
    #        break
        
        

if __name__ == "__main__":
    main()