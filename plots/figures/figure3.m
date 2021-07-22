%% Figure 3
% Generate manuscript figure 3 from Garwood, Chakravarty, et al, 2020

human = 0;
subject = 1;
session = 1;
pre_anesthesia = 1;

% Number of states
K = 5;

tunit = 'minutes';

file = 'NHP_MJ_';

% Zoom segment info:
zoom_start_t = 360;
zoom_end_t = 390;

% Load the data:
[spectrogram,time,spec_freq] = load_data(file,session);

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
zoom_time = time(zoom_start:zoom_end);
zoom_path = path(zoom_start:zoom_end);

if strcmp(tunit, 'minutes')
    time_figs = time/60;
else
    time_figs = time;
end

% Panel A
figure
ax2(1) = plotSpectrogram(spectrogram, time_figs, spec_freq, human, tunit);

% Panel B
figure
ax2(2) = plotPath(path,time_figs, tunit);
linkaxes(ax2,'x')

% Panel C
figure
plotSpectrogram(zoom_spectrogram, zoom_time, spec_freq, human,'seconds');

% Panel D
figure
plotPath(zoom_path, zoom_time, 'seconds');

% Panel E
figure
plotEachState(spectrogram, path, spec_freq,human);
figure
plotSpectrum(spectrogram,spec_freq,path,K)

% Panel F
figure
plotBeta(beta_a,beta_b)

% Panel G
figure
plotTmat(A)
