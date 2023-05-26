function [ax] = plotSpectrogram(spectrogram, time, spec_freq, color_scale, tunit)

if nargin<4 human = 0; end 
if nargin<5 tunit = 'minutes'; end

imagesc(time, spec_freq, pow2db(spectrogram(:,:,1)'));
ax = gca;
set(gca, 'Ticklength', [0 0])

box off
%set(gca,'clim',[-20 50])
axis xy; 
ylabel('Frequency (Hz)');
% c = colorbar;
% ylabel(c,'Power (dB)');
%ylim([0 55])
set(gcf,'renderer','Painters')
caxis(color_scale);
%     if human
%         caxis([-20 15]);
%     else
%        caxis([12 45]);
%     end
colormap(gca,'jet')
xlim([min(time),max(time)]);
if strcmp(tunit, 'minutes')
    xlabel('Time (min)')
else
    xlabel('Time (s)')
end

end