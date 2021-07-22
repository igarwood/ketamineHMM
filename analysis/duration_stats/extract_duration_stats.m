% Compare state durations within a single model

% % If loading an estimated model:
% file = [];
% model = load(['./model_output',file]);

% If loading from models published in Garwood, Chakravarty, et al, 2020
% Choose which model to load:
human = 0;
subjects = 1;
sessions = 1:4;
model = loadmodel_GC(human, subjects, sessions);
suppressfig = 0;

beta_a = model.beta_a;
beta_b = model.beta_b;
beta_mode = (beta_a - 1)./(beta_a + beta_b - 2);
beta_mode((beta_a <= 1) & (beta_b > 1)) = ...
    zeros(size(beta_mode((beta_a <= 1) & (beta_b > 1))));
beta_mode((beta_a > 1) & (beta_b <= 1)) = ...
    ones(size(beta_mode((beta_a > 1) & (beta_b <= 1))));

burst_states = find(beta_mode(:,7) > 0.6);
burst_interval_states = find(beta_mode(:,7) <= 0.6);
slow_states = find(beta_mode(:,1) > 0.6 & beta_mode(:,2) > 0.6);
slow_interval_states = find(beta_mode(:,1) <= 0.6 | beta_mode(:,2) <= 0.6);


if human % Remove noise state
    burst_states = burst_states(burst_states~=6);
    slow_states = slow_states(slow_states~=6);
else % Remove preanesthesia state
    burst_interval_states = burst_interval_states(burst_interval_states~=1);
    slow_interval_states = slow_interval_states(slow_interval_states~=1);
end

path = model.path;
A = model.A;
dt = model.dt;

% Determine the distribution of mean durations across N_MC markov chains of
% length N
N_MC = 4000;
N = 2000; % Number of samples per generated Markov Chain
MC_burst_durations = MC_duration(A,burst_states,N,N_MC)*dt;
MC_burst_intervals = MC_duration(A,burst_interval_states,N,N_MC)*dt;
MC_slow_durations = MC_duration(A,slow_states,N,N_MC)*dt;
MC_slow_intervals = MC_duration(A,slow_interval_states,N,N_MC)*dt;

% Determine median and confidence intervals for the durations:
[burst_dur_CI,burst_dur] = confidence_intervals(MC_burst_durations);
[burst_int_CI,burst_int] = confidence_intervals(MC_burst_intervals);
[slow_dur_CI,slow_dur] = confidence_intervals(MC_slow_durations);
[slow_int_CI,slow_int] = confidence_intervals(MC_slow_intervals);
MC_durations = [burst_dur, burst_int,slow_dur,slow_int];
MC_CI = [burst_dur_CI', burst_int_CI',slow_dur_CI', slow_int_CI'];

% Determine the mean durations from the viterbi path
viterbi_burst_duration = viterbi_duration(path,burst_states)*dt;
viterbi_burst_interval = viterbi_duration(path,burst_interval_states)*dt;
viterbi_slow_duration = viterbi_duration(path,slow_states)*dt;
viterbi_slow_interval = viterbi_duration(path,slow_interval_states)*dt;
viterbi_durations = [viterbi_burst_duration, viterbi_burst_interval,...
    viterbi_slow_duration,viterbi_slow_interval];

if ~suppressfig
    marker = 30;
    figure
    plotConfInterval(1:4,MC_durations,MC_CI(1,:), MC_CI(2,:));
    hold on
    plot(1:4,viterbi_durations,'kx','markersize',...
        marker)
    ylabel('Mean duration (seconds)')
    xlim([0.5,4.5])
    xticks(1:4)
    xticklabels({'burst', 'burst interval', 'slow osc.', ...
        'slow osc. interval'})
end



