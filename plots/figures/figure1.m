%% Figure 1
% Generate manuscript figure 1 from Garwood, Chakravarty, et al, 2020

human = 0;
subject = 1;
session = 1;
pre_anesthesia = 1;

% Number of states
K = 5;

tunit = 'seconds';
file = 'NHP_MJ_';

% Zoom segment info:
zoom_start_t = 360;
zoom_end_t = 375;

% Load the data:
[spectrogram,time,spec_freq] = load_data(file,session);
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];
Y = scale_power(spectrogram,spec_freq, freq_bands);
    
% Load the model:
model = loadmodel_GC(human, subject, session,pre_anesthesia);
path = model.path;
A = model.A;
beta_a = model.beta_a;
beta_b = model.beta_b;


% Extract zoom segment:
[~,zoom_start] = min(abs(time-zoom_start_t));
[~,zoom_end] = min(abs(time-zoom_end_t));
zoom_spectrogram = spectrogram(zoom_start:zoom_end,:);
zoom_Y = Y(zoom_start:zoom_end,:);
zoom_time = time(zoom_start:zoom_end)-time(zoom_start);
zoom_path = path(zoom_start:zoom_end);

if strcmp(tunit, 'minutes')
    time_figs = time/60;
else
    time_figs = time;
end



% Panel D
figure
plotSpectrogram(zoom_spectrogram, zoom_time, spec_freq, human,'seconds');

% Panel E
figure
obs_plots = [7,6,1];
for i = 1:length(obs_plots)
    subplot(length(obs_plots),1,i)
    plot(zoom_time,zoom_Y(:,obs_plots(i)),'color',[0.5,0.5,0.5],'linewidth',2)
    ylim([0,1])
    xlim([0,zoom_time(end)]);
end

% Panel G
figure
plotPath(zoom_path, zoom_time, 'seconds');

figure
plotBeta(beta_a,beta_b);

figure
plotTmat(A(2:5,2:5));
