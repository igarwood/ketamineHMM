human = 0;
subjects = 1;
sessions = 1;

% Number of states
K = 5;

states_compare = [5,2];

freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];
H = size(freq_bands,1);

tunit = 'minutes';

file = 'NHP_MJ_';

% Extract time points:
[start_t,end_t,anes_start] = sessionTimePoints(...
        sessions,subjects,1,human);
start_t = start_t - anes_start;
end_t = end_t - anes_start;
anes_start = 0;
    
% Load the data:
[spectrogram,time,spec_freq,N] = load_data(file,subjects,start_t,end_t);

% Load the model:
model = loadmodel_GC(human, subjects, sessions,1);
path = model.path;
A = model.A;
beta_a = model.beta_a;
beta_b = model.beta_b;

Y = zeros(length(spectrogram),size(beta_a,2));
L = length(N);

for l = 1:L
    ind1 = sum(N(1:l-1)) + 1;
    ind2 = sum(N(1:l));   
    Y(ind1:ind2,:) = scale_power(spectrogram(ind1:ind2,:),spec_freq, ...
        freq_bands);   
end  

fig = plotBeta_hist(Y,path,beta_a, beta_b,1);

figure
plotEachState(spectrogram, path, spec_freq,human);
plotSpectrum(spectrogram,spec_freq,path,K)

defaults = [ [0.6350, 0.0780, 0.1840];...	
            [0.4940, 0.1840, 0.5560];...
            [0.0000, 0.4470, 0.7410];...	          	
          	[0.8500, 0.3250, 0.0980];...	 	          	
          	[0.9290, 0.6940, 0.1250];...	 		 	          	
          	[0.4660, 0.6740, 0.1880];...	 	          	
          	[0.3010, 0.7450, 0.9330]...	 
        ];
    
x = linspace(0,1,10000);
fig(1) = figure;
fig(2) = figure;
fig(3) = figure;
fig(4) = figure;
a = zeros(1,2);
b = zeros(1,2);
probdiff = zeros(H,1);
ccdf = zeros(H,2);
for h = 1:H
    for k = 1:2
        set(0, 'CurrentFigure', fig(k))
        subplot(H,1,H-h+1)
        state = states_compare(k);
        a(k) = beta_a(state,h);
        b(k) = beta_b(state,h);
        betaF = betacdf(x,a(k),b(k));
        [~,midind] = min(abs(x-0.5));
        ccdf(h,k) = 1-betaF(midind);
        
        plot(x,betaF,'color',defaults(state+1,:),'linewidth',3);
        box off
        if h == round(H/2)         
            ylabel('f(X)');
        end
        if h == 1
            xlabel('X')
        else
            set(gca,'xticklabel',[])
        end
        set(gca,'TickLength',[0 0])
    end
    [fZ,Z] = beta_compare_pdf(a(1),b(1),a(2),b(2),[]);
    fZ(isnan(fZ)) = 0;
    fZ(isinf(fZ)) = 0;
    FZ = cumsum(((fZ(2:end)+fZ(1:end-1))/2)*(2/10000));
    [~,zeroind] = min(abs(Z));
    probdiff(h) = FZ(zeroind);
    
    mixcolor = (defaults(states_compare(1)+1,:) +...
        defaults(states_compare(2)+1,:))/2;
    set(0, 'CurrentFigure', fig(3))
    subplot(H,1,H-h+1)
    plot(Z,fZ,'color',mixcolor,'linewidth',3);
    box off
    ylim([0,3])
    if h == round(H/2)         
        ylabel('f(Z)');
    end
    if h == 1
        xlabel('Z')
    else
        set(gca,'xticklabel',[])
    end
    set(gca,'TickLength',[0 0])
    
    set(0, 'CurrentFigure', fig(4))
    subplot(H,1,H-h+1)
    plot(Z(1:end-1),FZ,'color',mixcolor,'linewidth',3);
    box off
    if h == round(H/2)         
        ylabel('F(Z)');
    end
    if h == 1
        xlabel('Z')
    else
        set(gca,'xticklabel',[])
    end
    set(gca,'TickLength',[0 0])
end

close 1 3 4 7 9 10