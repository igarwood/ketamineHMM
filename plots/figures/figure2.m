%% Figure 2
% Generate manuscript figure 2 from Garwood, Chakravarty, et al, 2020

human = 0;
tunit = 'seconds';

spectrogram = csvread('sim_spec.csv');
spec_freq = csvread('sim_spec_freq.csv');
time = csvread('sim_time.csv');
path = csvread('sim_path_ground_truth.csv');
path_est = csvread('sim_path_estimated.csv');
path_acc = csvread('sim_path_accuracy.csv');
KS_dist = csvread('sim_KS_dist.csv');
A_error = csvread('sim_A_error.csv');
pi_error = csvread('sim_pi_error.csv');
K = csvread('sim_K.csv');

% Extract zoom segment:
zoom_start_t = 400;
zoom_end_t = 500;
[~,zoom_start] = min(abs(time-zoom_start_t));
[~,zoom_end] = min(abs(time-zoom_end_t));
zoom_spectrogram = spectrogram(zoom_start:zoom_end,:);
zoom_time = time(zoom_start:zoom_end)-zoom_start_t;
zoom_path = path(zoom_start:zoom_end);
zoom_path_est = path_est(zoom_start:zoom_end);


% Panel A
figure
ax1(1) = plotSpectrogram(zoom_spectrogram, zoom_time, spec_freq, human, tunit);

% Panel B
figure
ax1(2) = plotPath(zoom_path,zoom_time, tunit);
% Note: adjust 'defaults' in plotPath to match the colors exactly

% Panel C
figure
ax1(3) = plotPath(zoom_path_est,zoom_time, tunit);
% Note: adjust 'defaults' in plotPath to match the colors exactly
linkaxes(ax1,'x')

% Panel D
figure
boxplot(path_acc',K,'color','k','symbol','.')
box off
xlabel('Number of Simulated States')
ylabel('Path Accuracy')

% Panel E
figure
boxplot(KS_dist',K,'color','k','symbol','.')
box off
xlabel('Number of Simulated States')
ylabel('Mean ks distance')

%Panel F
figure
boxplot(A_error',K,'color','k','symbol','.')
box off
xlabel('Number of Simulated States')
ylabel('\epsilon_{A}')

%Panel G
figure
boxplot(pi_error',K,'color','k','symbol','.')
box off
xlabel('Number of Simulated States')
ylabel('\epsilon_{\pi}')

