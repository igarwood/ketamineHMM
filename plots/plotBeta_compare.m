function fig = plotBeta_compare(prob_diff)

H = size(prob_diff,3);
cmap = load('Tcolormap2');
cmap = cmap.cmap;
for h = 1:H
    subplot(1,H,h);
    imagesc(prob_diff(:,:,h));
    caxis([0,1]) 
    colormap(gca,cmap)
    xticks(1:size(prob_diff,1));
    yticks(1:size(prob_diff,1));
    if H > 1
        title(['Frequency band ',num2str(h)']);
    end
    ylabel('state j');
    xlabel('state k');
    if h == H
        c = colorbar;
        ylabel(c,'Pr(X_j-X_k < 0)');
    end
end
fig = gcf;

end