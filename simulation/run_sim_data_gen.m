% Save output?
save_flag = 1;
folderpath = './data/simdata/';

% Suppress figures?
suppressfigs = 0;
tunit = 'minutes';

% Choose data file from which to simulate the spectrogram:
human = 0;
subject = 1;
session = 1;
pre_anesthesia = 0;

% Length of simulated data:
M = 12000;

% Number of simulated spectrograms to generate per model order
N_sim = 100;
if N_sim > 1 
    suppressfigs = 1; % Don't accidentally generate too many figures
    flag_save = 1; % Save the data from each simulation 
end

% Number of states to simulate:
K = 2:11;

% Frequency bands for clustering + calculating Y: 
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];
H = size(freq_bands,1);

% File prefixes:
if human 
    file = 'human_';
else
    if subject == 1
        file = 'NHP_MJ_';
    else
        file = 'NHP_LM_';
    end
end

% Model from which HMM parameters are used:
if pre_anesthesia == 0
    if human
        model_file = [file,num2str(subject),'_preA0_K'];
    else
        model_file = [file,num2str(session),'_preA0_K'];
    end
else
    if human
        model_file = [file,num2str(subject),'_K'];
    else
        model_file = [file,num2str(session),'_K'];
    end
end

% Extract session timepoints
[start_t,end_t,anes_start] = sessionTimePoints(...
        session,subject,pre_anesthesia,human);
    
% Load data
[spectrogram,time,spec_freq,N] = load_data(file,session, start_t, end_t);
dt = time(2)-time(1);

time = 0:dt:(M-1)*dt;
for n = 1:N_sim
    for j = 1:length(K)
        k = K(j);
        [sim_spec,sim_path,sim_A,sim_pi] = gen_spectrogram_from_file...
            (spectrogram,k,spec_freq,freq_bands,model_file,M);
        Y = scale_power(sim_spec,spec_freq, freq_bands);
        sim_beta_a = zeros(k,H);
        sim_beta_b = zeros(k,H);
        for h = 1:H
            for l = 1:k
                phat = betafit(Y(sim_path==l,h));
                sim_beta_a(l,h) = phat(1);
                sim_beta_b(l,h) = phat(2);
            end
        end
        if ~suppressfigs
            if strcmp(tunit, 'minutes')
                time_figs = time/60;
            else
                time_figs = time;
            end
            figure
            ax(1) = plotSpectrogram(sim_spec, time_figs, ...
                spec_freq, human, tunit);
            figure
            ax(2) = plotPath(sim_path,time_figs, tunit);
            linkaxes(ax,'x')    
        end
        if save_flag
            save([folderpath, model_file,num2str(k),'_sim',num2str(n)],...
                'sim_spec','spec_freq','time','sim_path','sim_A',...
                'sim_pi','sim_beta_a','sim_beta_b');
        end
    end
end

    

