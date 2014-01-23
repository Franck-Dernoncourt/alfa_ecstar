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
%     Date: 2013-01-07 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NUMBER_OF_PATIENTS = 44;
OUTPUT_FOLDER = './images/images_data_1.0/';

%% plot Evolution of variables over time (all patients are concatenated)'])
a = importdata('individuals_all.csv');
for i = 1:5
    p = plot(a(:,2+i));
    xlabel('Time (all patients are concatenated)')
    ylabel(['Variable ' int2str(i)])
    title(['Evolution of variable ' int2str(i) ' over time (all patients are concatenated)'])
    print('-dpng','-r100',[OUTPUT_FOLDER  'individuals_all_variable_' int2str(i)])
end

%% plot Evolution of variables over time (all patients are concatenated)'])
%% !! We suppose we have the same amount of rows for every patient
a = importdata('individuals_all.csv');
for i = 1:6
    p = plot(a(:,2+i));
    xlabel('Time (all patients are concatenated)')
    ylabel(['Variable ' int2str(i)])
    title(['Evolution of variable ' int2str(i) ' over time (all patients are concatenated)'])
    for ii = 1:NUMBER_OF_PATIENTS
        h = vline(ii * length(a)/ NUMBER_OF_PATIENTS,'--r',''); % http://www.mathworks.com/matlabcentral/fileexchange/1039
    end
    print('-dpng','-r200',['patients_all_variable_with_separation_line_variable_' int2str(i)])
end


%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
a = importdata('individuals_all.csv');
for i = 6:6
    p = plot(a(:,2+i));
    xlabel('Time (all patients are concatenated)')
    ylabel(['Variable ' int2str(i)])
    title(['Evolution of blood pressure over imes (all patients are concatenated)'])
    print('-dpng','-r100',['individuals_all_blood_pressure'])
end


%% Boxplots comparing every variables
a1 = a(:,3);
a2 =  a(:,4);
a3 =  a(:,5);
a4 =  a(:,6);
a5 =  a(:,7);

group = [ones(size(a1));ones(size(a2))+1;ones(size(a3))+2;ones(size(a4))+3;ones(size(a5))+4];
x = cat(1,a1,a2,a3, a4, a5);
boxplot(x,group);
set(gca,'XTick',1:5,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'; 'Variable 5'})
title('Boxplots comparing every variable')
print('-dpng','-r100','individuals_all_variables_boxplots')


%% Boxplots comparing every variables
a1 = a(:,3);
a2 =  a(:,4);
a3 =  a(:,5);
a4 =  a(:,6);
group = [ones(size(a1));ones(size(a2))+1;ones(size(a3))+2;ones(size(a4))+3];
x = cat(1,a1,a2,a3, a4);
boxplot(x,group);
set(gca,'XTick',1:4,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'})
title('Boxplots comparing every variable')
print('-dpng','-r100','individuals_all_variables_except5_boxplots')


%% Boxplot on blood pressure (0, 1 or 2)
a1 = a(:,8);
group = [ones(size(a1))];
x = cat(1,a1);
boxplot(x,group);
set(gca,'XTick',1:1,'XTickLabel',{'Blood pressure (0, 1 or 2)'})
title('Boxplots on blood pressure (class 0, 1 or 2)')
print('-dpng','-r100','individuals_all_blood_pressure_boxplots')


%% plot distribution of blood pressure (measured blood pressure) in all the data packages for all patients.')
x = [length(a(a==0)) length(a(a==1)) length(a(a==2))];
pie(x,cellstr(['Class 0 (low) '; 'Class 1 (avg) '; 'Class 2 (high)' ]))
colormap jet
title('Distribution of blood pressure (measured blood pressure) in all the data packages for all patients.')
print('-dpng','-r100','individuals_all_blood_pressure_pie')


% Note: It's impossible to have text labels inside a pie and percentages outside the pie cha
% http://www.mathworks.com/matlabcentral/answers/1909-how-can-i-have-text-labels-inside-a-pie-and-percentages-outside-the-pie-chart
% Therefore we also output the equivalent histogram
bar(x)
set(gca,'xticklabel',{'Class 0 (low) ' 'Class 1 (avg) ' 'Class 2 (high)' })
ylabel('Number of occurrences')
title('Distribution of measured blood pressure) in all the data packages for all patients.')
print('-dpng','-r100','individuals_all_blood_pressure_bar')


%% Compute correlation (heatmap)
R = corrcoef(a(:,3:8));
% p = HeatMap(R);
% addTitle(p, 'Correlation matrix  for all the 5 variables over all patients. ')
% addYLabel(p, 'Variable 1 to 5, and blood pressure', 'FontSize', 12, 'FontAngle', 'Italic')
% addXLabel(p, 'Variable 1 to 5, and blood pressure', 'FontSize', 12, 'FontAngle', 'Italic')
% plot(p)
% print('-dpng','-r100','individuals_all_variables_correlation_heatmap')

spreads_small = R;
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
% celldata = cellstr(data)

heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap'])

heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'Colormap', 'money', 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap_money'])

heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'Colormap', 'copper', 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap_copper'])
%  imagesc(R); 

%% PCA on all patient
b = a(:,3:7);
% b = normc(a(:,3:7)); % Normalize columns of matrix
% b(:,5)=b(:,5)./10;
b = bsxfun(@rdivide,b,std(b));
[pc,score,latent,tsquare] = princomp(b);
cumsum(latent)./sum(latent)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Now the remaining will do the same analysis but for each patient

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Excluded 
patients =  ['a40006'; 'a40012'; 'a40050'; 'a40051'; 'a40064'; 'a40076'; 'a40096'; 'a40099'; 'a40113'; 'a40119'; 'a40125'; 'a40172'; 'a40207'; 'a40215'; 'a40225'; 'a40234'; 'a40260'; 'a40264'; 'a40277'; 'a40282'; 'a40329'; 'a40376'; 'a40384'; 'a40424'; 'a40473'; 'a40493'; 'a40551'; 'a40834'; 'a40921'; 'a40928'; 'a41177'; 'a41200'; 'a41434'; 'a41447'; 'a41466'; 'a41495'; 'a41664'; 'a41770'; 'a41925'; 'a41934'; 'a42141'; 'a42259'; 'a42277'; 'a42397'];

%% plot Evolution of variables over time (all patients are concatenated)'])
for patient_number = 1:length(patients)
    a = importdata(['individuals_' patients(patient_number, :) '.csv']);
    for i = 1:5
        p = plot(a(:,2+i));
        xlabel(['Time (patient ' patients(patient_number, :) ' only)'])
        ylabel(['Variable ' int2str(i)])
        title(['Evolution of variable ' int2str(i) ' over time for patient ' patients(patient_number, :) ])           
        print('-dpng','-r100',['data_packages_variable_' int2str(i) '_patient_' patients(patient_number, :) '_evolution'])
    end
end

%% plot distribution of bucket numbers in all the XML files for all the 5 variables. 
for patient_number = 1:length(patients)
    a = importdata(['individuals_' patients(patient_number, :) '.csv']);
    for i = 6:6
        p = plot(a(:,2+i));
        xlabel(['Time (patient ' patients(patient_number, :) ' only)'])
        ylabel(['Variable ' int2str(i)])
        title(['Evolution of variable ' int2str(i) ' (blood pressure) over time for patient ' patients(patient_number, :) ])           
        print('-dpng','-r100',['data_packages_variable_' int2str(i) '_patient_' patients(patient_number, :) '_evolution'])
    end
end


%% Misc boxplots
for patient_number = 1:length(patients)
    a = importdata(['individuals_' patients(patient_number, :) '.csv']);
    %% Boxplots comparing every variables
    a1 = a(:,3);
    a2 =  a(:,4);
    a3 =  a(:,5);
    a4 =  a(:,6);
    a5 =  a(:,7);
    group = [ones(size(a1));ones(size(a2))+1;ones(size(a3))+2;ones(size(a4))+3;ones(size(a5))+4];
    x = cat(1,a1,a2,a3, a4, a5);
    boxplot(x,group);
    set(gca,'XTick',1:5,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'; 'Variable 5'})
    title(['Boxplots comparing every variable for patient ' patients(patient_number, :)])
    print('-dpng','-r100',['data_packages_all_variables_boxplots_patient_' patients(patient_number, :)] )


    %% Boxplots comparing every variables
    a1 = a(:,3);
    a2 =  a(:,4);
    a3 =  a(:,5);
    a4 =  a(:,6);
    group = [ones(size(a1));ones(size(a2))+1;ones(size(a3))+2;ones(size(a4))+3];
    x = cat(1,a1,a2,a3, a4);
    boxplot(x,group);
    set(gca,'XTick',1:4,'XTickLabel',{'Variable 1'; 'Variable 2'; 'Variable 3'; 'Variable 4'})
    title(['Boxplots comparing every variable for patient ' patients(patient_number, :)])
    print('-dpng','-r100',['data_packages_all_variables_except5_boxplots_patient_' patients(patient_number, :)] )

    
    %% Boxplot on blood pressure (0, 1 or 2)
    a1 = a(:,8);
    group = [ones(size(a1))];
    x = cat(1,a1);
    boxplot(x,group);
    set(gca,'XTick',1:1,'XTickLabel',{'Blood pressure (0, 1 or 2)'})
    title(['Boxplots on blood pressure (class 0, 1 or 2) for patient ' patients(patient_number, :)])
    print('-dpng','-r100',['data_packages_variable6_boxplot_patient_' patients(patient_number, :)] )


    %% plot distribution of blood pressure (measured blood pressure) in all the data packages for all patients.')
    x = [length(a(a==0)) length(a(a==1)) length(a(a==2))];
    pie(x,cellstr(['Class 0 (low) '; 'Class 1 (avg) '; 'Class 2 (high)' ]))
    colormap jet
    title(['Distribution of measured blood pressure in all the data packages for patient ' patients(patient_number, :)])
    print('-dpng','-r100',['data_packages_variable6_pie_patient_' patients(patient_number, :)] )


    % Note: It's impossible to have text labels inside a pie and percentages outside the pie cha
    % http://www.mathworks.com/matlabcentral/answers/1909-how-can-i-have-text-labels-inside-a-pie-and-percentages-outside-the-pie-chart
    % Therefore we also output the equivalent histogram
    bar(x)
    set(gca,'xticklabel',{'Class 0 (low) ' 'Class 1 (avg) ' 'Class 2 (high)' })
    ylabel('Number of occurrences')
    title(['Distribution of measured blood pressure in all the data packages for patient ' patients(patient_number, :)])
    print('-dpng','-r100',['data_packages_variable6_bar_patient_' patients(patient_number, :)] )
end


%% Compute correlation (heatmap)
R = corrcoef(a(:,3:8));
% p = HeatMap(R);
% addTitle(p, 'Correlation matrix  for all the 5 variables over all patients. ')
% addYLabel(p, 'Variable 1 to 5, and blood pressure', 'FontSize', 12, 'FontAngle', 'Italic')
% addXLabel(p, 'Variable 1 to 5, and blood pressure', 'FontSize', 12, 'FontAngle', 'Italic')
% plot(p)
% print('-dpng','-r100','individuals_all_variables_correlation_heatmap')

spreads_small = R;
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
% celldata = cellstr(data)

clf
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap'])

clf
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'Colormap', 'money', 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap_money'])

clf
heatmap(spreads_small);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'Colormap', 'copper', 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5, and blood pressure');
ylabel('Variable 1 to 5, and blood pressure');
snapnow
print('-dpng','-r100',['individuals_all_variables_correlation_heatmap_copper'])
%  imagesc(R); 


%% Correlation values Of the five variables without Blood pressure
clf
spreads_small = spreads_small(1:end-1, 1:end-1);
clabel = arrayfun(@(x){sprintf('%0.2f',x)}, spreads_small); 
heatmap(spreads_small, [] , [], '%0.6f', 'TextColor', 'w', ...
        'Colorbar', true, 'Colormap', 'copper', 'ColorLevels', 40, 'UseLogColormap', false);
title('Correlation matrix  for all the 5 variables over all patients. ');
xlabel('Variable 1 to 5');
ylabel('Variable 1 to 5');
snapnow
print('-dpng','-r200',['individuals_all_variables_without_bp_correlation_heatmap_copper'])


%% Correlation plots Of the five variables without Blood pressure
clf
corrplot(a(:,3:7)) 
% title('Correlation matrix  for all the 5 variables over all patients. ');
% xlabel('Variable 1 to 5');
% ylabel('Variable 1 to 5');
snapnow
print('-dpng','-r200','individuals_all_variables_without_bp_correlation_pearson_corrplot')




%% PCA on each patient
% Excluded a40064
patients =  ['a40006'; 'a40012'; 'a40050'; 'a40051'; 'a40076'; 'a40096'; 'a40099'; 'a40113'; 'a40119'; 'a40125'; 'a40172'; 'a40207'; 'a40215'; 'a40225'; 'a40234'; 'a40260'; 'a40264'; 'a40277'; 'a40282'; 'a40329'; 'a40376'; 'a40384'; 'a40424'; 'a40473'; 'a40493'; 'a40551'; 'a40834'; 'a40921'; 'a40928'; 'a41177'; 'a41200'; 'a41434'; 'a41447'; 'a41466'; 'a41495'; 'a41664'; 'a41770'; 'a41925'; 'a41934'; 'a42141'; 'a42259'; 'a42277'; 'a42397'];
for i = 1:length(patients)
    a = importdata(['individuals_' patients(i, :) '.csv']);
    patients(i, :) 
    b = a(:,3:7);
    b(:,5)=b(:,5)./10000;
    b = bsxfun(@rdivide,b,std(b));
    avg = mean(b)
    standard_dev = std(b)
    [pc,score,latent,tsquare] = princomp(b);
    pc
    cumsum(latent)./sum(latent)
    biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',{'X1' 'X2' 'X3' 'X4' 'X5'})
    title(['PCA on patient ' patients(i, :)]);
    print('-dpng','-r100',['data_packages_variables_pca_patient_' patients(i, :)])
end




