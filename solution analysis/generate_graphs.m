%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Script generating graphs for the Papers2012/GECCO_2012_GF_ABP paper
%
%   Use:
%          First run the python script parse_xml.py, which will output
%          several txt files that this Matlab script needs.
%   Input:
%          None
%   Output:
%          PNG files corresponding to graphs.
%
%   Author: Franck Dernoncourt for MIT EVO-DesignOpt research group
%    Email: franck.dernoncourt@gmail.com
%     Date: 2012-12-25 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
a = sort(importdata('buckets.txt'));
p = plot(a);
xlabel('Appearance#')
ylabel('Bucket number')
title('Distribution of bucket numbers in all the XML files for all the 5 variables.')
print('-dpng','-r100','buckets')

%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
a = sort(importdata('ticks.txt'));
p = plot(a);
xlabel('Appearance#')
ylabel('Ticks')
title('Distribution of ticks in all the XML files for all the 5 variables.')
print('-dpng','-r100','ticks')

%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
a = importdata('complements.txt');
x = [length(a(a==0)) length(a(a==1))];
pie(x,cellstr(['false'; 'true ']))
colormap jet
title('Distribution of complements in all the XML files for all the 5 variables.')
print('-dpng','-r100','complements')

% Note: It's impossible to have text labels inside a pie and percentages outside the pie cha
% http://www.mathworks.com/matlabcentral/answers/1909-how-can-i-have-text-labels-inside-a-pie-and-percentages-outside-the-pie-chart
% Therefore we also output the equivalent histogram
bar(x)
set(gca,'xticklabel',{'false' 'true'})
ylabel('Number of occurrences')
title('Distribution of complements in all the XML files for all the 5 variables.')
print('-dpng','-r100','complements_histogram')


%% plot distribution of actions in all the XML files. 
a = importdata('actions.txt');
x = [length(a(a==0)) length(a(a==1)) length(a(a==2))];
pie(x,cellstr(['Action 0'; 'Action 1'; 'Action 2']))
colormap jet
title('Distribution of actions in all the XML files for all the 5 variables.')
print('-dpng','-r100','actions')

bar(x)
set(gca,'xticklabel',{'Action 0' 'Action 1' 'Action 2'})
ylabel('Number of occurrences')
title('Distribution of actions in all the XML files for all the 5 variables.')
print('-dpng','-r100','complements_histogram')

%% individual main information (= not specific to one rule): age
a = sort(importdata('individuals_main_info.txt'));
p = plot(sort(a(:,1)));
xlabel('Individual# (sorted by age)')
ylabel('Age')
title('Individual main information (= not specific to one rule): age')
print('-dpng','-r100','individuals_main_info_age')

%% individual main information (= not specific to one rule): master fitness
a = sort(importdata('individuals_main_info.txt'));
p = plot(sort(a(:,4)));
xlabel('Individual# (sorted by master fitness)')
ylabel('Master fitness')
title('Individual main information (= not specific to one rule): master fitness')
print('-dpng','-r100','individuals_main_info_master_fitness')

%% individual main information (= not specific to one rule): active samples
a = sort(importdata('individuals_main_info.txt'));
p = barh(sort(a(:,6)));
xlabel('Number of active samples')
ylabel('Master fitness')
title('Individual main information (= not specific to one rule): active samples')
print('-dpng','-r100','individuals_main_info_master_fitness')

%% Stats on rules: Number of times a rule is applied
a = sort(importdata('times_applied.txt')); 
p = plot(sort(a));
xlabel('Rule# (sorted by number of times it is applied)')
ylabel('Number of times a rule is applied')
title('Number of times a rule is applied')
print('-dpng','-r100','times_applied')

%% Stats on rules: Number of times a rule is applied on average per individual
a = sort(importdata('times_applied_average.txt')); 
p = plot(sort(a));
xlabel('Individual# (sorted by number of times on average a rule is applied)')
ylabel('Numer of times each rule is applied on average per individual')
title('Number of times a rule is applied')
print('-dpng','-r100','times_applied_average')

%% Stats on variable: Number of times each variable is used
a1 = sort(importdata('V1.txt'));
a2 = sort(importdata('V2.txt'));
a3 = sort(importdata('V3.txt'));
a4 = sort(importdata('V4.txt'));
a5 = sort(importdata('V5.txt'));
x = [length(a1) length(a2) length(a3) length(a4) length(a5)];
bar(x)
set(gca,'xticklabel',{'Variable 1' 'Variable 2' 'Variable 3' 'Variable 4' 'Variable 5'})
ylabel('Number of times each variable is used')
title('Number of times each variable is used')
print('-dpng','-r100','variables_occurrences')

% Average values
x = [mean(a1) mean(a2) mean(a3) mean(a4) mean(a5)];
bar(x)
set(gca,'xticklabel',{'Variable 1' 'Variable 2' 'Variable 3' 'Variable 4' 'Variable 5'})
ylabel('Average values of each variable')
title('Average values of each variable')
print('-dpng','-r100','variables_average_values')

% Boxplots comparing every variables
group = [ones(size(a1));ones(size(a2))+1;ones(size(a3))+2;ones(size(a4))+3;ones(size(a5))+4];
x = cat(1,a1,a2,a3, a4, a5);
boxplot(x,group);
set(gca,'XTick',1:5,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'; 'Variable 5'})
title('Boxplots comparing every variable')
print('-dpng','-r100','variables_boxplots')

% Plot for variable 1
p = plot(a1);
xlabel('Occurence# (sorted by variable 1 value)')
ylabel('Variable 1 value')
title('Variable 1 value')
print('-dpng','-r100','variable_1_value')

% Plot for variable 2
p = plot(a2);
xlabel('Occurence# (sorted by variable 2 value)')
ylabel('Variable 2 value')
title('Variable 2 value')
print('-dpng','-r100','variable_2_value')

% Plot for variable 3
p = plot(a3);
xlabel('Occurence# (sorted by variable 3 value)')
ylabel('Variable 3 value')
title('Variable 3 value')
print('-dpng','-r100','variable_3_value')

% Plot for variable 4
p = plot(a4);
xlabel('Occurence# (sorted by variable 4 value)')
ylabel('Variable 4 value')
title('Variable 4 value')
print('-dpng','-r100','variable_4_value')

% Plot for variable 5
p = plot(a5);
xlabel('Occurence# (sorted by variable 5 value)')
ylabel('Variable 5 value')
title('Variable 5 value')
print('-dpng','-r100','variable_5_value')

