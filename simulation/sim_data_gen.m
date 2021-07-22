function [sim_spec,spec_freq,time,sim_path,sim_A,sim_pi,sim_beta_a,...
    sim_beta_b] = sim_data_gen(k, human,subject,session,pre_anesthesia)


% Suppress figures?
suppressfigs = 1;
tunit = 'minutes';

% Length of simulated data:
M = 12000;

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
[start_t,end_t] = sessionTimePoints(...
        session,subject,pre_anesthesia,human);
    
% Load data
[spectrogram,time,spec_freq] = load_data(file,session, start_t, end_t);
dt = time(2)-time(1);

time = 0:dt:(M-1)*dt;
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

end
