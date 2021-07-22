function fig = plotTmat(A)
load('Tcolormap2');
imagesc(A)
ax = gca;
c = colorbar;
colormap(ax,'jet')
colormap(ax,cmap)
caxis([0 1]);

set(ax, 'Ticklength', [0 0])
box off
set(gca,'YTick',[1 2 3 4 5])
set(gca,'XTick',[1 2 3 4 5])
ylabel(c,'Transition Probability')
ylabel('state j')
xlabel('state k')
set(ax,'fontsize',16)
fig = gcf;
end