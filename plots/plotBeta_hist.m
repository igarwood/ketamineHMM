function fig = plotBeta_hist(Y,path,beta_a, beta_b,vertical)
% Plot frequency and state specific frequency bands
% Beta distribution: p(y) = (y^(a-1)*(1-y)^(b-1))/Beta(a,b)
% Input: for H frequency bands and K states,
%        Y = observations (H bands)
%        path = state path where each element is {1,2,...,k}
%        beta_a: KxH matrix of a 
%        beta_b: KxH matrix of b

% Default colors:
% defaults = [0.6953    0.1328    0.1328;...
%     0.0000    0.0000    0.7500;...
%     0.8516    0.6445    0.1250;...
%     0.0550    0.6053    0.5441;...
%     0.4940    0.1840    0.5560];
if nargin == 4
    vertical = 0;
end
defaults = [ [0.6350, 0.0780, 0.1840];...	
            [0.4940, 0.1840, 0.5560];...
            [0.0000, 0.4470, 0.7410];...	          	
          	[0.8500, 0.3250, 0.0980];...	 	          	
          	[0.9290, 0.6940, 0.1250];...	 		 	          	
          	[0.4660, 0.6740, 0.1880];...	 	          	
          	[0.3010, 0.7450, 0.9330]...	 
        ];
defaultLine = defaults;
%defaultLine = max(zeros(size(defaults)),defaults-0.2);
K = size(beta_a,1);
H = size(beta_a,2);
for k = 1:K
    fig(k) = figure('Name',strcat('State',num2str(k)));
end
for j = 1:H
    for k = 1:K
        set(0, 'CurrentFigure', fig(k))
        set(gcf,'renderer','Painters')
        if vertical
            subplot(H,1,H-j+1)
        else
            subplot(1,H,j)
        end
        y = Y(path==k,j);
        y= y*(1-4E-12)+2E-12;
        pd = makedist('Beta','a',beta_a(k,j),'b',beta_b(k,j));
        x = linspace(0,1,10000);

        [f,xhist] = ecdf(y);
        ecdfhist(f,xhist,0.015:0.03:0.985);
        h = findobj(gca,'Type','patch');
        h.FaceColor = defaults(k+1,:);
        h.FaceAlpha = 0.5;
        
        set(gca,'TickLength',[0 0])
        hold on
        ax = gca;
        ax.YColor = 'none';
        c = ax.Color;
        xlim([0,1])
        % Adjust y lims as needed here:
        box off
        if j == 4 && ~vertical
            xlabel('Normalized Power')
        elseif j == 1 && vertical
            xlabel('Normalized Power')
        elseif vertical
            set(gca,'xticklabel',[])
        end
        
        Y_dist = pdf(pd,x);
        plot(x,Y_dist,'k-','LineWidth',2,'Color',defaultLine(k+1,:));
        set(gca,'TickLength',[0 0])
        set(gca,'fontsize',16)
        hold on
        ax = gca;
        ylim([0,12])
        ax.YColor = 'k';
        ax = gca;
        if j == 1 && ~vertical
            ylabel('f(x)')
        elseif j == round(H/2) && vertical
            ylabel('f(x)')
        elseif ~vertical
            set(gca,'yticklabel',[])
        end
        
    end
end

%legend('0-10 Hz','10-20 Hz','20-30 Hz','30-40 Hz','40-50 Hz');
end