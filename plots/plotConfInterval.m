function fig = plotConfInterval(x,y,CI_neg, CI_pos)
% Scatter plot with vertical confidence intervals

defaults = [ 0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
plot(x,y,'.','color',defaults(1,:),'markersize',50)
hold on
plot([x-0.2;x+0.2],[CI_neg;CI_neg],'color',defaults(1,:),'linewidth',3)
plot([x-0.2;x+0.2],[CI_pos;CI_pos],'color',defaults(1,:),'linewidth',3)
plot([x;x],[CI_neg;CI_pos],'color',defaults(1,:),'linewidth',3);
fig = gcf;
end
