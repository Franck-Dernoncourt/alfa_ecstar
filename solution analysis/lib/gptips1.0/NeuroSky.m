
clear
close all
gp=rungp('NeuroSkyconfig2');
summary(gp);
runtree(gp,'best');
gppretty(gp,'best');
disp( gp.results.best.eval_individual{1});
