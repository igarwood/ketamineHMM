function [ax] = plotEachState(spectrogram, path, spec_freq,color_scale,y_lim)

K = max(path);
for k = 1:K
    rows = ceil(K/2);
    cols = 2;
    ax = subplot(rows,cols,k);
    imagesc(1:length(path==k), spec_freq, pow2db(spectrogram(path==k,:,1)'));
    box off
    set(gca,'clim',[-20 50])
    set(gca,'xticklabel',[])
    axis xy; 
    ylabel('Frequency (Hz)');
    title(strcat('State',num2str(k)));
    %ylim([0 50])
    ylim(y_lim);
    caxis(color_scale);
%     if human
%         caxis([-20 15]);
%     else
%        caxis([12 45]);
%     end
    colormap(gca,'jet')
    ax = gca;
end