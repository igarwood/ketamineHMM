function [ax,path,time] = plotPath(statepath,time, tunit)

if nargin<3 tunit = 'minutes'; end

% Default colors:
defaults = [ [0.6350, 0.0780, 0.1840];...	
            [0.4940, 0.1840, 0.5560];...
            [0.0000, 0.4470, 0.7410];...	          	
          	[0.8500, 0.3250, 0.0980];...	 	          	
          	[0.9290, 0.6940, 0.1250];...	 		 	          	
          	[0.4660, 0.6740, 0.1880];...	 	          	
          	[0.3010, 0.7450, 0.9330]...	 
        ];

ncolor = size(defaults,1);


dt = time(2)-time(1);
K = double(max(statepath));
t = zeros(4,length(time));
t(1,:) = time;
t(2,:) = time;
t(3,:) = time+dt;
t(4,:) = time+dt;


path =  zeros(4,length(time));
path(1,:) = statepath-.5;
path(2,:) = statepath+0.5;
path(3,:) = statepath+0.5;
path(4,:) = statepath-.5;


for k = 1:K
    ind = (statepath == k);
    patch(t(:,ind),path(:,ind),defaults(mod(k,ncolor)+1,:),'EdgeColor','none');
    hold on
end
yticks(1:K)
ylim([0.5,K+0.5])
set(gca,'TickLength',[0 0])
ax = gca;

box off
axis xy; 
ylabel('State');
if strcmp(tunit, 'minutes')
    xlabel('Time (min)')
else
    xlabel('Time (s)')
end
set(gcf,'renderer','Painters')
xlim([min(time),max(time)]);
end
