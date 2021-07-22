human = 1;
subjects = 9;
sessions = 1;

% Number of states
K = 6;

freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];

tunit = 'minutes';

file = 'human_';

% Extract time points:
[start_t,end_t,anes_start] = sessionTimePoints(...
        sessions,subjects,1,human);
start_t = start_t - anes_start;
end_t = end_t - anes_start;
anes_start = 0;
    
% Load the data:
[spectrogram,time,spec_freq,N] = load_data(file,sessions,start_t,end_t);

% % Load the model:
% model = loadmodel_GC(human, subjects, sessions,1);
% path = model.path;
% A = model.A;
% beta_a = model.beta_a;
% beta_b = model.beta_b;

Y = zeros(length(spectrogram),size(freq_bands,1));
L = length(N);

for l = 1:L
    ind1 = sum(N(1:l-1)) + 1;
    ind2 = sum(N(1:l));   
    Y(ind1:ind2,:) = scale_power(spectrogram(ind1:ind2,:),spec_freq, ...
        freq_bands);   
end  

fig = plotBeta_hist(Y,path,beta_a, beta_b);