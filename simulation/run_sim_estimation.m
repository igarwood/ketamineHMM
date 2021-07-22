% Number of times to run the EM algorithm
Nruns = 5;

% Save output? (Required if estimating more than one model)
flag_save = 0;

% Number of simulation models to estimate:
% N_sim = 100;
N_sim = 1;

% Number of states to estimate:
% K = 2:11;
K = 4;

% Info about file underlying the simulation:
% Human data: human = 1
% NHP data: human = 0
human = 0;

subject_number = 1;
session_number = 1;
pre_anesthesia = 0;

% Frequency bands
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];

% Identify data to load
folderpath = './data/simdata/';
if human 
    file = ['human_',num2str(subject_number)];
else
    if subject_number == 1
        file = ['NHP_MJ_',num2str(session_number)];
    else
        file = ['NHP_LM_',num2str(session_number)];
    end
end

if pre_anesthesia == 0
    file = [file,'_preA0_K'];
else
    file = [file,'_K'];
end

% Across each desired model order, estimate the beta-HMM (repeat 'Nruns'
% times to account for potential local optima)
comptime = zeros(Nruns,length(K));
LL = zeros(N_sim,length(K));
for n = 1:N_sim
    for k = 1:length(K)
        % load([file,num2str(K(k)),'_sim',num2str(n),'.mat']);
        [sim_spec,spec_freq,time,sim_path,sim_A,sim_pi,sim_beta_a,...
            sim_beta_b] = sim_data_gen(K(k),human,subject_number,...
            session_number,pre_anesthesia);
        save_file = [file,num2str(K(k)),'_sim',num2str(n),'_est'];
        spectrogram = sim_spec;
        N = size(spectrogram,1);
        dt = time(2)-time(1);
        Y = [];
        for l = 1:Nruns
            if l == 1
                km_init = 1;
            else
                km_init = 0;
            end
            [Y,A0,pi0,beta_a0,beta_b0,path0,~,~,~,LL0,...
                ~, comptime(l,k)] = runHMM(spectrogram, ...
                spec_freq, N, freq_bands, K(k), 0, km_init,Y);

            fprintf(['Simulation number ', num2str(n),' : ', ...
                num2str(K(k)),' states computed in ',...
                num2str(comptime(l,k)),' sec on cycle ',num2str(l),...
                ' with likelihood ',num2str(LL0),' \n']);  
            % Set the parameters according to the run with the highest
            % likelihood
            if LL0 > LL(n,k)
                LL(n,k) = LL0;
                est_A = A0;
                est_pi = pi0;
                est_beta_a = beta_a0;
                est_beta_b = beta_b0;
                est_path = path0;
            end
        end
        if flag_save
            save(['model_output/simulations/',save_file], 'est_A',...
                'est_pi','est_beta_a','est_beta_b','est_path', ...
                'sim_path','sim_A','sim_pi','sim_beta_a','sim_beta_b'); 
        end
    end
end