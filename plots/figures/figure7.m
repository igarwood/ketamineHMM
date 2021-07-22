%% Figure 7 
% Generate manuscript figure 7 from Garwood, Chakravarty, et al, 2020

human = 1;
subjects = [1:9];
session = 1;
K = 6;
H = 5;

burst_states = [4,5];
burst_interval_states = [1,2,3];
slow_states = [1,2];
slow_interval_states = [3,4,5];

time = csvread('human_1_time.csv');
dt = time(2)-time(1);

betadiff_human = csvread('human_MS_betadiff.csv');


burst_dur_human = csvread('human_MS_burst_dur.csv')*dt;
burst_int_human = csvread('human_MS_burst_int.csv')*dt;
slow_dur_human = csvread('human_MS_slow_dur.csv')*dt;
slow_int_human = csvread('human_MS_slow_int.csv')*dt;

durations = zeros(1,4);
durations_CI = zeros(2,4);
[durations_CI(:,1),durations(1)] = confidence_intervals(burst_dur_human);
[durations_CI(:,2),durations(2)] = confidence_intervals(burst_int_human);
[durations_CI(:,3),durations(3)] = confidence_intervals(slow_dur_human);
[durations_CI(:,4),durations(4)] = confidence_intervals(slow_int_human);

% Load the model:
model_human = loadmodel_GC(human, subjects(1:9), session);
A_human = model_human.A;
path_human = model_human.path;

state_dur_human = 1./(1-diag(A_human))*dt;

path_durations = [viterbi_duration(path_human,burst_states),...
    viterbi_duration(path_human,burst_interval_states),...
    viterbi_duration(path_human,slow_states),...
    viterbi_duration(path_human,slow_interval_states)]*dt;

% Panel A
figure
plotBeta_compare(reshape(betadiff_human,K,K,H));

% Panel B
figure
plotTmat(A_human);
fprintf(['State durations (k=[1,6]) = ', num2str(state_dur_human'),'\n']);


% Panel C
marker = 30;
figure
plotConfInterval(1:4,durations,durations_CI(1,:), durations_CI(2,:));
hold on
plot(1:4,path_durations,'kx','markersize',marker)
ylabel('Mean duration (seconds)')
xlim([0.5,4.5])
xticks([1:4])
xticklabels({'burst', 'burst interval', 'slow osc.', 'slow osc. interval'})
