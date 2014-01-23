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
%     Date: 2013-01-16 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [result_struct] = ...
    neural_network(output_folder, run_number, cross_validation_number, ...
    training_set, testing_set)

filename_prefix = ['ann_' 'crossval' num2str(cross_validation_number,'%03d') 'run' num2str(run_number,'%03d')] 
% CROSS_VALIDATION = 10;
OUTPUT_FOLDER  = output_folder;
% RUNS = 1;

% % load cleaned files  patient_all
% data = csvread(horzcat('patient_a41770', '.csv'), 0, 0);
% data = csvread(horzcat('patient_a40096', '.csv'), 0, 0);
% data = csvread(horzcat('patient_all', '.csv'), 0, 0);
% 
% data = data(1:700000, :);

data = training_set;
% basic analysis
normalization_dividend =std(data);
data = bsxfun(@rdivide,data,std(data));
mean(data)
std(data)


%% Configure neural network
p = data(:, 1:5)';
t =  data(:, 6)';

% Here newff is used to create a two-layer feed-forward network. The network has one hidden layer with ten neurons.
% net = feedforwardnet([60, 10]);
net = feedforwardnet(30);
 %net = feedforwardnet(100);
net = configure(net,p,t);


% net.layers{1}.transferFcn = 'logsig';
 net.layers{1}.transferFcn = 'tansig';
%net.layers{1}.transferFcn = 'radbas';
% net.layers{1}.transferFcn = 'purelin';
% net.layers{1}.transferFcn = 'tansig';
% net.layers{4}.transferFcn = 'logsig';
% net.layers{2}.transferFcn = 'radbas';
% net.layers{3}.transferFcn = 'purelin';

% View the network diagram.
% view(net);
%y1 = sim(net,p);
%plot(p,t,'o',p,y1,'x')

% The network is trained for up to 50 epochs to an error goal of 0.01 and then resimulated.
net.trainParam.epochs = 2000;
net.trainParam.goal = 0;
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false;
net.trainParam.time = inf; %Maximum time to train in seconds

% Maximum Validation Checks (max_fail) function parameter max_fail is a training function parameter. It must be a strictly positive integer scalar. max_fail is maximum number of validation checks before training is stopped. This parameter is used by trainb, trainbfg, trainbr, trainc, traincgb, traincgf, traincgp, traingd, traingda, traingdm, traingdx, trainlm, trainoss, trainrp, trains and trainscg
net.trainParam.max_fail = 6; % 
% net.trainParam.
% net.trainParam.
% net.trainParam.

% dividerand Divide the data randomly (default)
% divideblock Divide the data into contiguous blocks
% divideint Divide the data using an interleaved selection
% divideind Divide the data by index
net.divideFcn = 'divideblock';

% Train neural network
[net tr] = train(net,p,t);
net2=net;
y = sim(net,p);

clf
plotperform(tr);
print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'plotperform']);

clf
plottrainstate(tr);
print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'plottrainstate']);

clf
simplefitOutputs = sim(net,p);
plotregression(t,simplefitOutputs);
print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'plotregression']);

clf
y = net(p);
e = t - y;
ploterrhist(e,'bins',20)
print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'ploterrhist']);


% results of training
result = t-y;
mean(abs(result))
std(abs(result))

% plotting results
clf
% plot(1:size(t,2),t)

range = 1:17000;
plot(range ,t(range ),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',1)
            
hold on

plot(range ,y(range ),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',1)           
%             
% plot(1:size(t,2),t,'--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10)
            
% [net,tr,Y,E,Pf,Af] = train(net,P,T,Pi,Ai) 


%% Compute accuracy and analyze results
% data3 = csvread(horzcat('patient_all', '.csv'), 0, 0);
% data3_original = data3(700000:850000, :);

data3 = testing_set;
data3_original = testing_set;

data3 = bsxfun(@rdivide,data3_original,normalization_dividend );
mean(data3)
std(data3)

% machine learning: MLP
p3 = data3(:, 1:5)';
t3 =  data3(:, 6)';
y3 = sim(net,p3);

% Compute accuracy
result3 = t3-y3;
mean(abs(result3))
std(abs(result3))
blood_pressure_class_values3=unique(t3);
blood_pressure_class_interval=blood_pressure_class_values3( 2) -blood_pressure_class_values3(1)
threshold = blood_pressure_class_interval/2;
accuracy3 = length(result3(abs(result3) < threshold ))/length(result3)

% Compute confusion matrix
prediction_labels3 = zeros(length(result3), 1) + 10;
for i = 1:length(result3)
    if abs(result3(i) < threshold )
       [~, prediction_labels3(i)] = min(abs(y3(i) - blood_pressure_class_values3(:)));
    end    
    prediction_labels3(i) = prediction_labels3(i) - 1;
end

confusion_matrix = confusionmat(data3_original(:, 6), prediction_labels3)';
confusion_matrix_ratio = confusion_matrix./length(result3);

% Draw confusion matrix heatmap
clf
heatmap(confusion_matrix_ratio , [] , [], '%0.10f', 'TextColor', 'w', ...
        'Colorbar', true, 'ColorLevels', 40, 'UseLogColormap', false);
title(['Confusion matrix (Overall accuracy: ' num2str(accuracy3) ')']);
xlabel('Actual')
ylabel('Predicted')
snapnow
print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'confusion_matrix_heatmap'])        

% Compute recall, precision, f1Score (taken from Alexander's code EvaluateClassifierPerformance.m)
numberOfClasses = length(blood_pressure_class_values3);
recall = zeros(1,numberOfClasses);
precision = zeros(1,numberOfClasses);
f1Score = zeros(1,numberOfClasses);

for i = 1:numberOfClasses
    recall(i) = confusion_matrix(i,i)/(sum(confusion_matrix(i,:)));
    precision(i) = confusion_matrix(i,i)/(sum(confusion_matrix(:,i)));
    f1Score(i) = 2*(precision(i)*recall(i))/(precision(i)+recall(i));
end


clf
% Plot some results
plot(result3)
% plot(t3)
% plot(y3)

clf
range = 1:length(t3);
plot(range ,t3,'-k','LineWidth',2,...
                'MarkerEdgeColor','black',...
                'MarkerFaceColor','black',...
                'MarkerSize',1)
            
hold on

plot(range ,y3,'-','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','b',...
                'MarkerSize',1)      

sum_so_far = blood_pressure_class_values3(1) - threshold ;
for vertical_line = 1:(length(blood_pressure_class_values3)+1) 
        h = hline(sum_so_far,'--r',''); % http://www.mathworks.com/matlabcentral/fileexchange/1039
        sum_so_far = sum_so_far + threshold *2;
end

print('-dpng','-r200',[OUTPUT_FOLDER filename_prefix 'plot_against_test_set']);

%% Record results into a struct
result_struct = struct('accuracy',accuracy3, ...
                       'confusion_matrix', confusion_matrix, ...
                       'confusion_matrix_ratio', confusion_matrix_ratio, ...
                       'net', net);

%% Dead zone
%
% %%            
% data2 = csvread(horzcat('patient_a40096', '.csv'), 0, 0);
% % basic analysis
% data2 = bsxfun(@rdivide,data2,std(data2));
% mean(data2)
% std(data2)
% 
% p2 = data2(:, 1:5)';
% t2 =  data2(:, 6)';
% 
% 
% y2 = sim(net,p2);
% 
% % results of training
% result = t2-y2;
% mean(abs(result))
% std(abs(result))
% 
% % plotting results
% figure
% % plot(1:size(t,2),t)
% 
% range = 1:17500;
% plot(range ,t2(range ),'--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',1)
%             
% hold on
% 
% plot(range ,y2(range ),'--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','r',...
%                 'MarkerSize',1)           