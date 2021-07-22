function [] = plotSimEstimate(sim,K,file)

tunit = 'minutes';
human = 0;

sim = load([file,num2str(K),'_sim',num2str(sim),'.mat']);
model = load([file,num2str(K),'_sim',num2str(sim),'_est.mat']);


spectrogram = sim.sim_spec;
spec_freq = sim.spec_freq;
time = sim.time;
known_path = sim.sim_path;
est_path = model.path;

if strcmp(tunit, 'minutes')
    time_figs = time/60;
else
    time_figs = time;
end
figure
ax(1) = plotSpectrogram(spectrogram, time_figs, ...
    spec_freq, human, tunit);
figure
ax(2) = plotPath(known_path,time_figs, tunit);
title('Known path');
figure
ax(3) = plotPath(est_path,time_figs, tunit);
title('Estimated path');
linkaxes(ax,'x')


end
