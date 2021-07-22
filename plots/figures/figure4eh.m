%% Figure 4 E-H
% Generate manuscript figure 4 E-H from Garwood, Chakravarty, et al, 2020

human = 0;
subject = 2;
sessions = 1:5;
plot_sessions = [1,5];

% Number of states
K = 5;

tunit = 'minutes';

file = 'NHP_LM_';

% Zoom segment info:
zoom_session = 5;
% zoom_start_t = 190;
% zoom_end_t = 225;
zoom_start_t = 165;
zoom_end_t = 200;

% Extract time points:
[start_t,end_t,anes_start] = sessionTimePoints(...
        sessions,subject,1,human);
start_t = start_t - anes_start;
end_t = end_t - anes_start;
anes_start = 0;
    
% Load the data:
[spectrogram,time,spec_freq,N] = load_data(file,sessions,start_t,end_t);

% Load the model:
model = loadmodel_GC(human, subject, sessions);
path = model.path;
A = model.A;
beta_a = model.beta_a;
beta_b = model.beta_b;

% Extract zoom segment:
ind1 = sum(N(1:zoom_session-1)) + 1;
ind2 = sum(N(1:zoom_session)); 
ind = ind1:ind2;
spectrogram_ss = spectrogram(ind,:);
time_ss = time(ind);
path_ss = path(ind);
[~,zoom_start] = min(abs(time_ss-zoom_start_t));
[~,zoom_end] = min(abs(time_ss-zoom_end_t));
zoom_spectrogram = spectrogram_ss(zoom_start:zoom_end,:);
zoom_time = time_ss(zoom_start:zoom_end);
zoom_path = path_ss(zoom_start:zoom_end);

if strcmp(tunit, 'minutes')
    time_figs = time/60;
else
    time_figs = time;
end

% Panel E-F
for j = 1:length(plot_sessions)
    l = plot_sessions(j);
    ind1 = sum(N(1:l-1)) + 1;
    ind2 = sum(N(1:l)); 
    ind = ind1:ind2;
    ax3 = [];
    figure
    ax3(1) = plotSpectrogram(spectrogram(ind,:), time_figs(ind), ...
        spec_freq, human, tunit);
    figure
    ax3(2) = plotPath(path(ind),time_figs(ind), tunit);
    linkaxes(ax3,'x')
end

% Panel G
figure
plotSpectrogram(zoom_spectrogram, zoom_time, spec_freq, human,'seconds');

figure
plotPath(zoom_path, zoom_time, 'seconds');

% Panel H
figure
plotBeta(beta_a,beta_b)

