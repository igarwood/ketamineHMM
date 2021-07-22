function fig = plotSpectrum(spectrogram,spec_freq,path,K)


% Default colors:
defaults = [
        0.4940    0.1840    0.5560;...
        0.0000    0.4470    0.7410;...
        0.8500    0.3250    0.0980;...
        0.9290    0.6940    0.1250;...
        0.4660    0.6740    0.1880;...
        0.3010    0.7450    0.9330;...
        0.6350    0.0780    0.1840];
for k = 1:K
    figure
    spec = pow2db(spectrogram(path==k,:));
    spectrum = mean(spec);
    CI = zeros(2,length(spectrum));
    CI(1,:) = spectrum - std(spec);
    CI(2,:) = spectrum + std(spec);
    x =[spec_freq, fliplr(spec_freq)];
    y =[CI(1,:), fliplr(CI(2,:))];
    
    if k < 8
        plot(spectrum,spec_freq,'Color',defaults(k,:));
        %semilogy(sfreqs,(spectrum),'Color',defaults(i,:));
        hold on
        fill(y,x,defaults(k,:),'FaceAlpha',0.3,'EdgeColor',...
            defaults(k,:));
    elseif k < 15
        plot(spectrum,spec_freq,'Color',defaults(k-7,:));
        hold on
        fill(y,x,defaults(k-7,:),'FaceAlpha',0.3,'EdgeColor',...
            defaults(k-7,:));
    else
        plot(spectrum,spec_freq,'Color',defaults(k-14,:));hold on
        fill(y,x,defaults(k-14,:),'FaceAlpha',0.3,'EdgeColor',...
            defaults(k-14,:));
    end
    
    ylim([0,50]);
    xlim([10,45]);

end

box off
set(gca, 'Ticklength', [0 0])
ylabel('Frequency (Hz)')
xlabel('Power (dB)')
set(gcf,'renderer','Painters')
ax = gca;
ax.FontSize = 15;


end