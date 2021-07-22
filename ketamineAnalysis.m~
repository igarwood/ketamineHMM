% Script for running ketamine HMM analysis
%
% Indie Garwood 
% July 22, 2021
%
% Estimate a betaHMM from ketamine ephys data
%
% Note that the estimation algorithm runs 5 times in order to find the
% global maxima (The EM algorithm is prone to optimizing for local maxima)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of times to run the EM algorithm
Nruns = 5;

% Save output?
flag_save = 0;

% Run simulated data?
sim_data = 0;

% Human data: human = 1
% NHP data: human = 0
human = 0;

multisession = 0;
subject_numbers = 1;
session_numbers = 1;

% Frequency bands
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];

% Number of states
K = 5;
pre_anesthesia = 1;

% Indicate whether or not to plot figures:
suppressfigs = 0;
tunit = 'seconds'; % for figures

% Identify data to load
folderpath = './data/';
if human && ~sim_data
    file = 'human_';
else
    if subject_numbers == 1
        file = 'NHP_MJ_';
    else
        file = 'NHP_LM_';
    end
end

save_string = file;
% Determine the session timepoints:
[start_t,end_t,anes_start] = sessionTimePoints(...
        session_numbers,subject_numbers,pre_anesthesia,human);

% Adjust time so that the start of anesthesia corresponds to t = 0
start_t = start_t - anes_start;
end_t = end_t - anes_start;

if human 
    sessions = subject_numbers; % For multipatient model
else
    sessions = session_numbers; % For multisession model
end

if multisession
    save_string = [save_string, 'all_'];
else
    save_string = [save_string, num2str(sessions),'_'];
end

if ~pre_anesthesia
    save_string = [save_string,'preA0_'];
end

% Load the data:
[spectrogram,time,spec_freq,N] = load_data(file,sessions, start_t, end_t);
Y = [];
dt = time(2)-time(1);

% Across each desired model order, estimate the beta-HMM (repeat 'Nruns'
% times to account for potential local optima)
comptime = zeros(Nruns,length(K));
LL = zeros(1,length(K));
for k = 1:length(K)
    for j = 1:Nruns
        if j == 1
            km_init = 1;
        else
            km_init = 0;
        end
        [Y,A0,pi0,beta_a0,beta_b0,path0,gamma0,alpha0,Xi0,LL0,...
            normconst0, comptime(j,k)] = runHMM(spectrogram, spec_freq, ...
            N, freq_bands, K(k), multisession, km_init,Y);

        fprintf([num2str(K(k)),' states computed in ',...
            num2str(comptime(j,k)),' sec on cycle ',num2str(j),...
            ' with likelihood ',num2str(LL0),' \n']);  
        % Set the parameters according to the run with the highest
        % likelihood
        if LL0 > LL(k)
            LL(k) = LL0;
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
    % Plots:
    if ~suppressfigs
        for l = 1:length(sessions)
            ind1 = sum(N(1:l-1)) + 1;
            ind2 = sum(N(1:l)); 
            ind = ind1:ind2;
            ax = [];
            if strcmp(tunit, 'minutes')
                time_figs = time/60;
            else
                time_figs = time;
            end
            figure
            ax(1) = plotSpectrogram(spectrogram(ind,:), time_figs(ind), ...
                spec_freq, human, tunit);
            figure
            ax(2) = plotPath(path(ind),time_figs(ind), tunit);
            linkaxes(ax,'x')
            figure
            plotEachState(spectrogram(ind,:), path(ind), spec_freq,human);
        end
    end
    if flag_save
        save(['model_output/',save_string,'K',num2str(K(k))], ...
            'Y','A','pi','beta_a','beta_b','gamma',...
            'path','alpha','Xi','LL','anes_start','normconst','dt'); 
    end
    comptime2 = sum(comptime)/Nruns;

end
