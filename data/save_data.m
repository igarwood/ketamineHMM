%% Multisession 

%filepath = '/Users/indiegarwood/Documents/ketamine paper/data/';
filepath ='./data/';
NHP = 'MJ';
num_sess = 4;
human = 0;
freqs = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];
if ~human 
    close all
    for i = 1:num_sess
        writematrix(spectralData_ss{i},...
            [filepath,'NHP_',NHP,'_',num2str(i),'_spec.csv']);
%         writematrix(stimes_ss{i},...
%            [filepath,'NHP_',NHP,'_',num2str(i),'_time.csv']);
        writematrix(path_ss{i},...
            ['NHP_',NHP,'_',num2str(i),'_MS_path.csv']);
        writematrix(pi(i,:),...
            ['NHP_',NHP,'_',num2str(i),'_MS_pi.csv']);
    end
    writematrix(sfreqs,[filepath,'NHP_',NHP,'_spec_freq.csv']);
    writematrix(beta_a,['NHP_',NHP,'_MS_beta_a.csv']);
    writematrix(beta_b,['NHP_',NHP,'_MS_beta_b.csv']);
    writematrix(A,['NHP_',NHP,'_MS_A.csv']);
    writematrix(freqs,['NHP_',NHP,'_MS_freq_bands.csv']);
    writematrix(numstates,[filepath,'NHP_',NHP,'_MS_K.csv']);
else
    close all
    for i = 1:num_sess
%         writematrix(spectralData_ss{i},...
%             [filepath,'human_',num2str(i),'_spec.csv']);
%         writematrix(stimes_ss{i},...
%             [filepath,'human_',num2str(i),'_time.csv']);
        writematrix(path_ss{i},...
            ['human_',num2str(i),'_MS_path.csv']);
        writematrix(pi(i,:),...
            ['human_',num2str(i),'_MS_pi.csv']);
    end
%    writematrix(sfreqs,[filepath,'human_spec_freq.csv']);
    writematrix(beta_a,['human_MS_beta_a.csv']);
    writematrix(beta_b,['human_MS_beta_b.csv']);
    writematrix(A,['human_MS_A.csv']);
    writematrix(freqs,['human_MS_freq_bands.csv']);
%     writematrix(numstates,[filepath,'human_MS_K.csv']);
end

%% Single session
%filepath = '/Users/indiegarwood/Documents/ketamine paper/data/';

writematrix(path, 'NHP_MJ_1_SS_path.csv');
writematrix(pi, 'NHP_MJ_1_SS_pi.csv');
writematrix(beta_a,'NHP_MJ_1_SS_beta_a.csv');
writematrix(beta_b,'NHP_MJ_1_SS_beta_b.csv');
writematrix(A,'NHP_MJ_1_SS_A.csv');
writematrix(freq_bands,'NHP_MJ_1_SS_freq_bands.csv');
writematrix(K,'NHP_MJ_1_SS_K.csv');