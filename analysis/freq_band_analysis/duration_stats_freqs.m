% Compare state durations within a single model

% % If loading an estimated model:
% file = [];
% model = load(['./model_output',file]);

% If loading from models published in Garwood, Chakravarty, et al, 2020
% Choose which model to load:
human = 0;
subjects = 1;
sessions = 1:4;
%model = loadmodel_GC(human, subjects, sessions);
suppressfig = 0;
dt = 0.1;

burst_states = [4,5];
burst_interval_states = [2,3];
slow_states = [2,3];
slow_interval_states = [4,5];

% path = model.path;
% A = model.A;
% dt = model.dt;

% Determine the distribution of mean durations across N_MC markov chains of
% length N
N_MC = 4000;
N = 2000; % Number of samples per generated Markov Chain

fig(1) = figure;
fig(2) = figure;
fig(3) = figure;
fig(4) = figure;
for i = 1:14


    A = A_freqs{i};
    pi = pi_freqs{i};
    path = path_mat(i,:);
    MC_burst_durations{i} = MC_duration(A,burst_states,N,N_MC)*dt;
    MC_burst_intervals{i} = MC_duration(A,burst_interval_states,N,N_MC)*dt;
    MC_slow_durations{i} = MC_duration(A,slow_states,N,N_MC)*dt;
    MC_slow_intervals{i} = MC_duration(A,slow_interval_states,N,N_MC)*dt;

    % Determine median and confidence intervals for the durations:
    [burst_dur_CI{i},burst_dur(i)] = confidence_intervals(MC_burst_durations{i});
    [burst_int_CI{i},burst_int(i)] = confidence_intervals(MC_burst_intervals{i});
    [slow_dur_CI{i},slow_dur(i)] = confidence_intervals(MC_slow_durations{i});
    [slow_int_CI{i},slow_int(i)] = confidence_intervals(MC_slow_intervals{i});
    MC_durations{i} = [burst_dur(i), burst_int(i),slow_dur(i),slow_int(i)];
    MC_CI{i} = [burst_dur_CI{i}', burst_int_CI{i}',slow_dur_CI{i}', slow_int_CI{i}'];

    % Determine the mean durations from the viterbi path
    viterbi_burst_duration(i) = viterbi_duration(path,burst_states)*dt;
    viterbi_burst_interval(i) = viterbi_duration(path,burst_interval_states)*dt;
    viterbi_slow_duration(i) = viterbi_duration(path,slow_states)*dt;
    viterbi_slow_interval(i) = viterbi_duration(path,slow_interval_states)*dt;
    viterbi_durations{i} = [viterbi_burst_duration(i), viterbi_burst_interval(i),...
        viterbi_slow_duration(i),viterbi_slow_interval(i)];


end

%%

fig(1) = figure;
fig(2) = figure;
fig(3) = figure;
fig(4) = figure;
num_H = zeros(14,1);
for i = 1:13
    if ~suppressfig
        marker = 30;
        titles = {'Burst Durations', 'Burst Intervals', 'Slow Wave Duration', ...
            'Slow Wave Interval'};
        for j = 1:4
            set(0, 'CurrentFigure', fig(j))
            plotConfInterval(14-i,MC_durations{i}(j),MC_CI{i}(1,j),...
                MC_CI{i}(2,j));
            hold on
            plot(14-i,viterbi_durations{i}(j),'kx','markersize',...              
                marker)
            ylabel('Mean duration (seconds)')
            title(titles{j})
        end
        
    end
    num_H(14-i) = size(beta_freqs{1,i},2);
end
for j = 1:4
    set(0, 'CurrentFigure', fig(j))
    plotConfInterval(14,MC_durations{14}(j),MC_CI{14}(1,j),...
        MC_CI{14}(2,j));
    hold on
    plot(14,viterbi_durations{14}(j),'kx','markersize',...              
        marker)
    ylabel('Mean duration (seconds)')
    title(titles{j})
end
num_H(14) = size(beta_freqs{1,14},2);

for j = 1:4
    set(0, 'CurrentFigure', fig(j))
    ylim([0.5,4.5])
    xticks(1:14)
    xticklabels(num_H);
    xlabel('Number of frequency bands')
    set(gca,'fontsize',18)
end