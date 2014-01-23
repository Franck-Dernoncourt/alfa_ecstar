%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Script assessing the neural networks' performances for  
%   Papers2012/GECCO_2012_GF_ABP paper (informal comparison with the 
%   genetic programming results)
%
%   Use:
%          First run the python script merge_data_packages-data1.0.py, 
%          which will output several txt files that this Matlab script
%          needs.
%          Configure gpconfig.m
%          
%   Input:
%          None
%   Output:
%          Neural networks' performances 
%
%   Author: Franck Dernoncourt for MIT EVO-DesignOpt research group
%    Email: franck.dernoncourt@gmail.com
%     Date: 2013-01-24 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath_recurse('data_packages1.0');
addpath_recurse('images');
addpath_recurse('lib');    

gp=rungp('gp_config');
summary(gp);
runtree(gp,'best');
gppretty(gp,'best');
disp( gp.results.best.eval_individual{1});
