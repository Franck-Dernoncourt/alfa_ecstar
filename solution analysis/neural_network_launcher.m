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
%   Input:
%          None
%   Output:
%          Neural networks' performances 
%
%   Author: Franck Dernoncourt for MIT EVO-DesignOpt research group
%    Email: franck.dernoncourt@gmail.com
%     Date: 2013-01-19 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath_recurse('data_packages1.0');
addpath_recurse('images');
addpath_recurse('lib');      

%% Main parameters. To be configured.
number_of_cross_validation= 10;
training_ratio = 0.9; % should be between 0 and 1
output_folder  = './images/ann/';
number_of_runs = 50;

% Don't touch me
number_of_runs  = number_of_cross_validation * number_of_runs;

%% Load cleaned files 
% training_set = csvread(horzcat('patient_a41770', '.csv'), 0, 0);
% training_set = csvread(horzcat('patient_a40096', '.csv'), 0, 0);
training_set = csvread(horzcat('patient_all', '.csv'), 0, 0);
testing_set = csvread(horzcat('patient_all', '.csv'), 0, 0);
data = csvread(horzcat('patient_all', '.csv'), 0, 0);
data_doubled = vertcat(data, data);

result_number =  0;

for cross_validation_number  = 1:number_of_cross_validation
    % Divide the data into 2 contiguous blocks: training and testing (I duplicated data to make the code easier)
    starting_position=randi(length(data),1);
    training_set = data_doubled(starting_position:starting_position+length(data)*training_ratio, :);
    testing_set = data_doubled(starting_position+length(data)*training_ratio+1:starting_position+length(data), :);
    
    % Do runs over the chosen sets
    for run_number = 1:number_of_runs
        result_number =result_number  + 1;
        results(cross_validation_number, run_number) = neural_network(output_folder, run_number, ...
            cross_validation_number,training_set, testing_set);
    end
end


%% Compute accuracy and analyze results
accuracy = zeros(number_of_cross_validation, number_of_runs);
for i = 1:number_of_cross_validation
    for j = 1:number_of_runs 
        accuracy(i, j) = results(i, j).accuracy;
    end
end
flat_accuracy = reshape(accuracy, number_of_cross_validation*number_of_runs,1)';

% boxplot global
clf
group = [];
labels = {};
for i = 1:number_of_cross_validation
    group = horzcat(group, zeros(number_of_runs, 1)+i);
end
boxplot(flat_accuracy', ...
    reshape(group,number_of_cross_validation*number_of_runs ,1));
% set(gca,'XTick',1:5,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'; 'Variable 5'})
title(['Boxplots comparing accuracy amongst the crossvalidations (' int2str(number_of_runs) ' runs for each crossvalidation)'])
print('-dpng','-r200',[output_folder  'ann_cross_validation_accuracy_boxplots'])

% plot global
clf
plot(flat_accuracy)
title(['Plot accuracy amongst the runs for all crossvalidations (' int2str(number_of_runs) ' runs)'])
xlabel('Runs');
ylabel('Accuracy ');
snapnow
print('-dpng','-r200',[output_folder  'ann_cross_validation_accuracy_plot'])

% hist global
hist(flat_accuracy,0:0.05:1)
title(['Repartition of the accuracy amongst the runs for all crossvalidations (' int2str(number_of_runs) ' runs)'])
xlabel('Accuracy');
ylabel('Runs');
snapnow
print('-dpng','-r200',[output_folder  'ann_cross_validation_accuracy_hist'])


% Graphs for each cross-validation
for cross_validation_number = 1:number_of_cross_validation
    
    % plot 
    clf
    plot(flat_accuracy)
    title(['Plot accuracy amongst the runs for crossvalidation ' int2str(cross_validation_number) ' (' int2str(number_of_runs ) ' runs)'])
    xlabel('Runs');
    ylabel('Accuracy ');
    snapnow
    print('-dpng','-r200',[output_folder  'ann_crossval' num2str(cross_validation_number,'%03d') '_accuracy_plot'])

    % hist global
    hist(flat_accuracy,0:0.05:1)
    title(['Repartition of the accuracy amongst the runs for crossvalidation ' int2str(cross_validation_number) ' (' int2str(number_of_runs ) ' runs)'])
    xlabel('Accuracy');
    ylabel('Runs');
    snapnow
    print('-dpng','-r200',[output_folder  'ann_crossval' num2str(cross_validation_number,'%03d')  '_accuracy_hist'])

end



