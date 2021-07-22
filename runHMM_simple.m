function [path,A,pi,beta_a,beta_b,LL] = runHMM_simple(spectrogram,time,spec_freq,K)

% Number of times to run the EM algorithm
Nruns = 5;

% Frequency bands
freq_bands = [[0,1];[2,4];[5,8];[9,12];[13,25];[26,35];[36,50]];

% Indicate whether or not to plot figures:
suppressfigs = 0;
tunit = 'minutes'; % for figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Human data: human = 1
human = 1;

multisession = 0;
sessions = 1;
N = length(time);

Y = [];
dt = time(2)-time(1);

% Across each desired model order, estimate the beta-HMM (repeat 'Nruns'
% times to account for potential local optima)
comptime = zeros(Nruns,length(K));
LL = zeros(1,length(K));
for k = 1:length(K)
    for j = 1:Nruns
        if j == 1
            km_init = 1;
        else
            km_init = 0;
        end
        [Y,A0,pi0,beta_a0,beta_b0,path0,gamma0,alpha0,Xi0,LL0,...
            normconst0, comptime(j,k)] = runHMM(spectrogram, spec_freq, ...
            N, freq_bands, K(k), multisession, km_init,Y);

        fprintf([num2str(K(k)),' states computed in ',...
            num2str(comptime(j,k)),' sec on cycle ',num2str(j),' of ', ...
            num2str(Nruns), ' with likelihood ',num2str(LL0),' \n']);  
        % Set the parameters according to the run with the highest
        % likelihood
        if LL0 > LL(k)
            LL(k) = LL0;
            A = A0;
            pi = pi0;
            beta_a = beta_a0;
            beta_b = beta_b0;
            gamma = gamma0;
            path = path0;
            alpha = alpha0;
            Xi = Xi0;
            normconst = normconst0;
        end
    end
    % Plots:
    if ~suppressfigs
        for l = 1:length(sessions)
            ind1 = sum(N(1:l-1)) + 1;
            ind2 = sum(N(1:l)); 
            ind = ind1:ind2;
            ax = [];
            if strcmp(tunit, 'minutes')
                time_figs = time/60;
            else
                time_figs = time;
            end
            figure
            ax(1) = plotSpectrogram(spectrogram(ind,:), time_figs(ind), ...
                spec_freq, human, tunit);
            figure
            ax(2) = plotPath(path(ind),time_figs(ind), tunit);
            linkaxes(ax,'x')
            figure
            plotEachState(spectrogram(ind,:), path(ind), spec_freq,human);
        end
    end
    comptime2 = sum(comptime)/Nruns;

end
