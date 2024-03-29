% Script for running multitrial HMM analysis
%
% Indie Garwood 
% May 26, 2023
%
% Estimate a betaHMM from multitrial data
%
% Note that the estimation algorithm runs 5 times in order to find the
% global maxima (The EM algorithm is prone to optimizing for local maxima)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data input:
% spectrogram: NxFxL 
%   N = number of time points
%   F = number of frequencies
%   L = number of trials (assuming all trials are of equal length)
% spec_freq: frequencies corresponding to spectrogram
% time: time corresponding to spectrogram

%% Example from ketamine data 
% Comment out this section if using other data

% Note that this is NOT a trial-based experiment!
% Split the session into evenly spaced trials for demonstration only

% Load ketamine data (see ketamineAnalysis for explanation of inputs
[start_t,end_t,anes_start] = sessionTimePoints(1,1,1,0);
file = 'NHP_MJ_';
[spectrogram,time,spec_freq,N] = load_data(file,1, start_t, end_t);
N_trial = 300;
spectrogram_trials = zeros(N_trial,513,floor(N/N_trial));
for l = 1:floor(N/N_trial)
    ind_a = (l-1)*N_trial+1;
    ind_b = l*N_trial;
    spectrogram_trials(:,:,l) = spectrogram(ind_a:ind_b,:);
end
time = time(1:300);
spectrogram = spectrogram_trials;


%% Parameters
% Get data dimensions:
N = size(spectrogram,1);
F = size(spectrogram,2);
L = size(spectrogram,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to adjust for your application:

% Frequency bands:
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];

% Number of states:
K = 5; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EM algorithm parameters:
Nruns = 5;

% Scaling parameters will be computed across all trials from each session. 
% If there is only one session, do not change the line below. If there are
% multiple sessions, create cell array that is (n_sessions x 1) where each 
% cell contains the trial indices for each session.
% For example, if session 1 has 100 trials and session 2 has 50:
% session_trials = {[1:100],[101:150]}
session_trials = {[1:L]}; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure parameters:

% Trials to plot (replace with trials that you want to visualize)
trials_plot = [1,round(L/2),L];

% Y limits:
y_lim = [0,55];

% Color scale of spectrogram
color_scale = [12 45];

suppress_figs = 0; % set to 1 if you don't want to plot any figures
tunit = 'minutes';

%% Process data 

% Concatenate spectrogram:

spectrogram_all = zeros(N*L,F);
N_all = zeros(L,1); % This vector is important when trials are unequal lengths
time_all = zeros(N*L,1); % same as above
for l = 1:L
    ind_a = (l-1)*N+1;
    ind_b = l*N;
    spectrogram_all(ind_a:ind_b,:,:) = spectrogram(:,:,l);
    N_all(l) = N; 
    time_all(ind_a:ind_b) = time;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate HMM:

Y = [];
LL = 0;
if L > 1
    multisession = 1;
end
for j = 1:Nruns
    if j == 1
        km_init = 1;
    else
        km_init = 0;
    end
    [Y,A0,pi0,beta_a0,beta_b0,path0,gamma0,alpha0,Xi0,LL0,...
        normconst0, comptime] = runHMM(spectrogram_all, spec_freq, ...
        N_all, freq_bands, K, multisession, km_init,Y,session_trials);

    fprintf([num2str(K),' states computed in ',...
        num2str(comptime),' sec on cycle ',num2str(j),...
        ' with likelihood ',num2str(LL0),' \n']);  
    % Set the parameters according to the run with the highest
    % likelihood
    if LL0 > LL
        LL = LL0;
        A = A0;
        pi = pi0;
        beta_a = beta_a0;
        beta_b = beta_b0;
        gamma = gamma0;
        path = path0;
        alpha = alpha0;
        Xi = Xi0;
        normconst = normconst0;
    end
end
%% Plot figures
if ~suppress_figs
    for l = 1:length(trials_plot)
        trial_plot = trials_plot(l);
        ind1 = sum(N_all(1:trial_plot-1)) + 1;
        ind2 = sum(N_all(1:trial_plot)); 
        ind = ind1:ind2;
        ax = [];
        if strcmp(tunit, 'minutes')
            time_figs = time_all/60;
        else
            time_figs = time_all;
        end
        figure
        subplot(2,1,1);
        ax(1) = plotSpectrogram(spectrogram_all(ind,:), time_figs(ind), ...
            spec_freq, color_scale, tunit);
        ylim(y_lim);
        subplot(2,1,2);
        ax(2) = plotPath(path(ind),time_figs(ind), tunit);
        linkaxes(ax,'x')
        figure
        plotEachState(spectrogram_all(ind,:), path(ind), spec_freq,...
            color_scale,y_lim);
    end
end


