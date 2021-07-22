path_51 = path_mat(1,:);
path_7 = path_mat(14,:);
beta_a_51 = beta_freqs{1,1};
beta_b_51 = beta_freqs{2,1};
beta_a_7 = beta_freqs{1,14};
beta_b_7 = beta_freqs{2,14};



human = 0;

multisession = 1;
subject_numbers = 1;
session_numbers = 1:4;
tunit = 'seconds';

K = 5;
pre_anesthesia = 1;

[start_t,end_t,anes_start] = sessionTimePoints(...
        session_numbers,subject_numbers,pre_anesthesia,human);
start_t = start_t - anes_start;
end_t = end_t - anes_start;


if human 
    sessions = subject_numbers; % For multipatient model
else
    sessions = session_numbers; % For multisession model
end

%data_folder = '/Users/indiegarwood/Documents/Data/';
folderpath = '../betaHMM_canonical/data/';
if human 
    file = 'human_';
else
    if subject_numbers == 1
        file = 'NHP_MJ_';
    else
        file = 'NHP_LM_';
    end
end
save_string = file;

[spectrogram,time,spec_freq,N] = load_data([folderpath,file],sessions, start_t, end_t);

% L = length(N);
% Y_51 = zeros(sum(N),51);
% Y_7 = zeros(sum(N),7);
% for l = 1:L
%     ind1 = sum(N(1:l-1)) + 1;
%     ind2 = sum(N(1:l)); 
%     [Y_51(ind1:ind2,:),~] = ...
%         scale_power(spectrogram(ind1:ind2,:),spec_freq, freqs{1});
%     [Y_7(ind1:ind2,:),~] = ...
%         scale_power(spectrogram(ind1:ind2,:),spec_freq, freqs{14});
% end 

%% Figures 
l = 1;
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
ax(2) = plotPath(path_51(ind),time_figs(ind), tunit);

figure
ax(3) = plotPath(path_7(ind),time_figs(ind), tunit);
linkaxes(ax,'x')

figure
plotEachState(spectrogram(ind,:), path_51(ind), spec_freq,human);

figure
plotEachState(spectrogram(ind,:), path_7(ind), spec_freq,human);

% figure
% plotBeta_hist(Y_51,path_51,beta_a_51, beta_b_51);
% 
% figure
% plotBeta_hist(Y_7,path_7,beta_a_7, beta_b_7);