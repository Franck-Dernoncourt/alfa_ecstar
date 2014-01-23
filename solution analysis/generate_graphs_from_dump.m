%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Script generating graphs for the Papers2012/GECCO_2012_GF_ABP paper
%
%   Use:A
%          First run the python script parse_dump.py, which will output
%          several csv files that this Matlab script needs.
%   Input:
%          None
%   Output:
%          PNG files corresponding to graphs.
%
%   Author: Franck Dernoncourt for MIT EVO-DesignOpt research group
%    Email: franck.dernoncourt@gmail.com
%     Date: 2013-01-03 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
% http://www.mathworks.com/help/bioinfo/ref/heatmapobject.html
% http://www.mathworks.com/help/bioinfo/ref/addxlabelheatmap.htmlI
a = importdata('2013_01_03_14_35_11_9_dump_train.log_parsed.txt');
labels = importdata('2013_01_03_14_35_11_9_dump_train.log_names_parsed.txt');
clf
p = HeatMap(a);
addTitle(p, 'HeatMap for 2013-01-03-14-35-11-9-dump-train')
addYLabel(p, 'Patients', 'FontSize', 12, 'FontAngle', 'Italic')
addXLabel(p, 'Packages', 'FontSize', 12, 'FontAngle', 'Italic')
plot(p)
print('-dpng','-r100','2013_01_03_14_35_11_9_dump_train')


% ,0.0, > ,51,
% -1 > 50
% ,0. > ,51.


%% plot aggregated confusion matrix. 
% http://www.mathworks.com/help/bioinfo/ref/heatmapobject.html
% http://www.mathworks.com/help/bioinfo/ref/addxlabelheatmap.htmlI
a = importdata('2013_01_03_14_35_11_9_dump_train.logconfusion_matrix_ratio.txt');
clf
p = HeatMap(a);
addTitle(p, 'Aggregated confusion matrix. ')
addYLabel(p, 'Predicted', 'FontSize', 12, 'FontAngle', 'Italic')
addXLabel(p, 'Actual', 'FontSize', 12, 'FontAngle', 'Italic')
plot(p)
print('-dpng','-r100','2013_01_03_14_35_11_9_dump_train_confusion_matrix')


%% plot aggregated confusion matrix with new lib
a = importdata('2013_01_03_14_35_11_9_dump_test.log_parsed.txt');
b = importdata('2013_01_03_14_35_11_9_dump_train.log_parsed.txt');
% spreads_small = importdata('2013_01_03_14_35_11_9_dump_test.log_parsed.txt');
spreads_small = a + b;
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
% celldata = cellstr(data)

heatmap(spreads_small, [] , [], '%0.2f', 'TextColor', 'w', ...
        'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', true);
title('Aggregated confusion matrix');
xlabel('Packages')
ylabel('Patients')
snapnow


%% plot aggregated global_percentage_correct_in_solutions_vs_packages with new lib
a = importdata('global_percentage_correct_in_solutions_vs_packages.txt')';
[labels idx] = sort(importdata('global_percentage_correct_in_solutions_vs_packages_labels.txt')');
% spreads_small = importdata('2013_01_03_14_35_11_9_dump_test.log_parsed.txt');
spreads_small = a(:,idx);
clf
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
% celldata = cellstr(data)

heatmap(spreads_small, [] , [], '%0.2f', 'TextColor', 'w', ...
        'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
title('Aggregated confusion matrix');
xlabel('Packages')
ylabel('Solutions')
snapnow


%% plot confusion matrix of every solution with new lib
for i = 0:9
    a = importdata(['global_confusion_matrix' int2str(i) '_ratio.txt']);
    spreads_small = a;
    clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
    % celldata = cellstr(data)

    clf
    heatmap(spreads_small, [] , [], '%0.8f', 'TextColor', 'w', ...
            'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
    title(['Confusion matrix for solution ' int2str(i)]);
    xlabel('Actual')
    ylabel('Predicted')
    snapnow
    print('-dpng','-r100',['global_confusion_matrix' int2str(i) '_ratio'])
end

%% plot global_fitness_vs_packages_stats
for i = 0:2
    a = importdata('global_fitness_vs_packages_stats.txt');
    p = plot(a(:,1), a(:,i+2), '.');
    xlabel('Percent correct')
    ylabel(['Percentage of class ' int2str(i) ' for blood pressure'])
    title('Global Fitness (averaged over all solutions) vs package stats.')
    print('-dpng','-r100',['global_fitness_vs_packages_stats' int2str(i)])
end

%% plot global_fitness_vs_packages_stats_per_solution
for i = 0:2
    for ii = 0:9
        a = importdata(['global_fitness_vs_packages_stats_per_solution' int2str(ii) '.txt']);
        p = plot(a(:,1), a(:,i+2), '.');
        xlabel('Percent correct')
        ylabel(['Percentage of class ' int2str(i) ' for blood pressure'])
        title(['Percent correct vs package stats for solution.' int2str(ii)])
        print('-dpng','-r100',['global_fitness_vs_packages_stats_class' int2str(i) '_solution' int2str(ii) ])
    end
end


%% plot global_fitness_vs_packages_stats_per_solution
clf
for i = 0:9
     labels = cellstr([' % correct  '; 'Abs correct '; ' % in DL    ']);
     labelsy = cellstr([' class 0 '; ' class 1 '; ' class 2 ']);
    a = importdata(['global_class_summary_per_solution' int2str(i) '.txt']);
    spreads_small  = a(:, 2:4);
    
    clf
    heatmap(spreads_small,labels ,labelsy, '%0.8f', 'TextColor', 'w', ...
            'ShowAllTicks', true, 'Colorbar', true, 'Colormap', 'copper', 'ColorLevels', 40, 'UseLogColormap', false);
    title(['Statistics on classes for solution ' int2str(i) ]);
    snapnow
    print('-dpng','-r100',['global_class_summary_per_solution' int2str(i) '_copper'])   
%     
%     clf
%     heatmap(spreads_small,labels ,labelsy, '%0.6f', 'TextColor', 'w', ...
%             'ShowAllTicks', true, 'Colorbar', true, 'Colormap', 'money', 'ColorLevels', 40, 'UseLogColormap', true);
%     title(['Statistics on classes for solution ' int2str(i) ]);
%     snapnow
%     print('-dpng','-r100',['global_class_summary_per_solution' int2str(i) '_money'])   
% 
%     clf
%     heatmap(spreads_small,labels ,labelsy, '%0.6f', 'TextColor', 'w', ...
%             'ShowAllTicks', true, 'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
%     title(['Statistics on classes for solution ' int2str(i) ]);
%     snapnow
%     print('-dpng','-r100',['global_class_summary_per_solution' int2str(i) ''])   

end



%% Analyze Rules Test 
a = importdata('solutions_all_class-action-fired-test.csv');
rules_fired = a  (:, 3);
maximum_rule_fire= max(rules_fired);

%% Position in the ruleset of the rule that fired')
boxplot(rules_fired);
set(gca,'XTick',1:1,'XTickLabel',{'Data: 2013_01_04_12_57_28_0_dump_test'})
title('Position in the ruleset of the rule that fired')
ylabel('Number of occurrences')
print('-dpng','-r200','solutions_all_rules_fired_boxplot_test')

% Hist
hist(rules_fired',maximum_rule_fire)
    ylabel('Number of occurrences')
    xlabel('Position in the ruleset of the rule that fired')
    title('Position of fired rule; Data: 2013-01-04-12-57-28-0-dump-test')
print('-dpng','-r200','solutions_all_rules_fired_hist_test')




%% Analyze Rules train
a = importdata('solutions_all_class-action-fired-train.csv');
rules_fired = a  (:, 3);
maximum_rule_fire= max(rules_fired);

%% Position in the ruleset of the rule that fired
boxplot(rules_fired);
set(gca,'XTick',1:1,'XTickLabel',{'Data: 2013_01_04_12_57_28_0_dump_train'})
ylabel('Number of occurrences')
title('Position of fired rule; Data: 2013-01-04-12-57-28-0-dump-train')
print('-dpng','-r200','solutions_all_rules_fired_boxplot_train')

% Hist
hist(rules_fired',maximum_rule_fire)
ylabel('Number of occurrences')
xlabel('Position in the ruleset of the rule that fired')
title('Position of fired rule; Data: 2013-01-04-12-57-28-0-dump-train')
print('-dpng','-r200','solutions_all_rules_fired_hist_train')


%% plot Position in the ruleset of the rule that fired For every solution
for solution_number = 0:99
    a = importdata(['solutions_' int2str(solution_number ) '_class-action-fired.csv']);
    rules_fired = a  (:, 3);
    hist(rules_fired',16)
    ylabel('Number of occurrences')
    xlabel(['Position in the ruleset of the rule that fired for solution ' int2str(solution_number )])
    title('Position of fired rule; Data: 2013-01-04-12-57-28-0-dump-train')
    print('-dpng','-r200',['solutions_' int2str(solution_number ) '_rules_fired_hist_train'])
end


%% plot Evolution of variables over time (all patients are concatenated)'])
patients =  ['a40006'; 'a40012'; 'a40050'; 'a40051'; 'a40064'; 'a40076'; 'a40096'; 'a40099'; 'a40113'; 'a40119'; 'a40125'; 'a40172'; 'a40207'; 'a40215'; 'a40225'; 'a40234'; 'a40260'; 'a40264'; 'a40277'; 'a40282'; 'a40329'; 'a40376'; 'a40384'; 'a40424'; 'a40473'; 'a40493'; 'a40551'; 'a40834'; 'a40921'; 'a40928'; 'a41177'; 'a41200'; 'a41434'; 'a41447'; 'a41466'; 'a41495'; 'a41664'; 'a41770'; 'a41925'; 'a41934'; 'a42141'; 'a42259'; 'a42277'; 'a42397'];
for i = 1:length(patients)
    a = importdata(['solutions_' patients(i, :)  '_class-action-fired.csv']);
    rules_fired = a  (:, 3);
    hist(rules_fired',16)
    ylabel('Number of occurrences')
    xlabel(['Position in the ruleset of the rule that fired for patient '  patients(i, :)])
    title('Position of fired rule; Data: 2013-01-04-12-57-28-0-dump-train')
    print('-dpng','-r200',['solutions_patient_'  patients(i, :) '_rules_fired_hist_train'])
end





