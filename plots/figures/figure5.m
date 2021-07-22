%% Figure 5 
% Generate manuscript figure 5 from Garwood, Chakravarty, et al, 2020

human = 0;
subjects = [1,2];
sessions = {1:4;1:5};
K = 5;
H = 7;

time = csvread('NHP_MJ_1_time.csv');
dt = time(2)-time(1);

betadiff_MJ = csvread('NHP_MJ_MS_betadiff.csv');
betadiff_LM = csvread('NHP_LM_MS_betadiff.csv');
betadiff_MJvsLM = csvread('NHP_MJvsLM_MS_betadiff.csv');


burst_dur_MJ = csvread('NHP_MJ_MS_burst_dur.csv');
burst_dur_LM = csvread('NHP_LM_MS_burst_dur.csv');
burst_int_MJ = csvread('NHP_MJ_MS_burst_int.csv');
burst_int_LM = csvread('NHP_LM_MS_burst_int.csv');
slow_dur_MJ = csvread('NHP_MJ_MS_slow_dur.csv');
slow_dur_LM = csvread('NHP_LM_MS_slow_dur.csv');
slow_int_MJ = csvread('NHP_MJ_MS_slow_int.csv');
slow_int_LM = csvread('NHP_LM_MS_slow_int.csv');

duration = zeros(4,2);
duration_CI = zeros(2,4,2);
[duration_CI(:,1,1),duration(1,1)] = confidence_intervals(burst_dur_MJ);
[duration_CI(:,1,2),duration(1,2)] = confidence_intervals(burst_dur_LM);
[duration_CI(:,2,1),duration(2,1)] = confidence_intervals(burst_int_MJ);
[duration_CI(:,2,2),duration(2,2)] = confidence_intervals(burst_int_LM);
[duration_CI(:,3,1),duration(3,1)] = confidence_intervals(slow_dur_MJ);
[duration_CI(:,3,2),duration(3,2)] = confidence_intervals(slow_dur_LM);
[duration_CI(:,4,1),duration(4,1)] = confidence_intervals(slow_int_MJ);
[duration_CI(:,4,2),duration(4,2)] = confidence_intervals(slow_int_LM);

% Load the models:
model_MJ = loadmodel_GC(human, subjects(1), sessions{1});
A_MJ = model_MJ.A;
path_MJ = model_MJ.path;
state_dur_MJ = 1./(1-diag(A_MJ))*dt;

model_LM = loadmodel_GC(human, subjects(2), sessions{2});
A_LM = model_LM.A;
path_LM = model_LM.path;
state_dur_LM = 1./(1-diag(A_LM))*dt;

% Extract durations from the viterbi path:
viterbi_durations = zeros(4,2);

burst_states = [4,5];
burst_interval_states = [2,3];
slow_states = [2,3];
slow_interval_states = [4,5];

viterbi_durations(1,1) = viterbi_duration(path_MJ,burst_states)*dt;
viterbi_durations(2,1) = viterbi_duration(path_MJ,burst_interval_states)*dt;
viterbi_durations(3,1) = viterbi_duration(path_MJ,slow_states)*dt;
viterbi_durations(4,1) = viterbi_duration(path_MJ,slow_interval_states)*dt;


viterbi_durations(1,2) = viterbi_duration(path_LM,burst_states)*dt;
viterbi_durations(2,2) = viterbi_duration(path_LM,burst_interval_states)*dt;
viterbi_durations(3,2) = viterbi_duration(path_LM,slow_states)*dt;
viterbi_durations(4,2) = viterbi_duration(path_LM,slow_interval_states)*dt;

% Panel A
marker = 30;
figure
plotConfInterval(1:4,duration(:,1),duration_CI(1,:,1), duration_CI(2,:,1));
hold on
plot(1:4,viterbi_durations(:,1),'kx','markersize',...
    marker)
ylabel('Mean duration (seconds)')
xlim([0.5,4.5])
xticks(1:4)
title('NHP MJ')
xticklabels({'burst', 'burst interval', 'slow osc.', ...
    'slow osc. interval'})

figure
plotConfInterval(1:4,duration(:,2),duration_CI(1,:,2), duration_CI(2,:,2));
hold on
plot(1:4,viterbi_durations(:,2),'kx','markersize',...
    marker)
ylabel('Mean duration (seconds)')
xlim([0.5,4.5])
xticks(1:4)
title('NHP LM')
xticklabels({'burst', 'burst interval', 'slow osc.', ...
    'slow osc. interval'})


% Panel B
figure
plotTmat(A_MJ);
fprintf(['MJ state durations (k=[1,5]) = ', num2str(state_dur_MJ'),'\n']);

% Panel C
figure
plotTmat(A_LM);
fprintf(['LM state durations (k=[1,5]) = ', num2str(state_dur_LM'),'\n']);

% Panel D
figure
plotBeta_compare(reshape(betadiff_MJ,K,K,H));

% Panel E
figure
plotBeta_compare(reshape(betadiff_LM,K,K,H));

% Panel F
figure
plotBeta_compare(reshape(betadiff_MJvsLM,K,K,H));



