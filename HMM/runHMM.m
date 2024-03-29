function [Y,A,pi,beta_a,beta_b,path,gamma,alpha,Xi,LL,...
    scale_k,comptime] = runHMM(spectrogram, spec_freq,...
    N, freq_bands, K, multisession, km_init,Y,session_trials)
            
if sum(N) ~= size(spectrogram,1)
    error('sum(N) and length of spectrogram disagree')
end


if multisession
    L = length(N);
else 
    L = 1;
    N = sum(N);
end
H = size(freq_bands,1);

if nargin < 9
    trial_analysis = 0;
else
    trial_analysis = 1;
    S = length(session_trials);
end

% HMM Settings:
max_cycles = 50;
tolerance = 0.0001;

% Calculate observations (y) from spectrogram for each session
if isempty(Y)
    Y = zeros(sum(N),H);
    if trial_analysis == 0
        scale_k = zeros(L,H);
        for l = 1:L
            ind1 = sum(N(1:l-1)) + 1;
            ind2 = sum(N(1:l)); 
            [Y(ind1:ind2,:),scale_k(l,:)] = ...
                scale_power(spectrogram(ind1:ind2,:),spec_freq, freq_bands);
        end  
    else
        scale_k = zeros(S,H);
        for s = 1:S
            l_a = session_trials{s}(1);
            l_b = session_trials{s}(end);
            ind1 = sum(N(1:l_a-1)) + 1;
            ind2 = sum(N(1:l_b)); 
            [Y(ind1:ind2,:),scale_k(s,:)] = ...
                scale_power(spectrogram(ind1:ind2,:),spec_freq,...
                freq_bands);
        end   
    end
else
    scale_k = ones(L,H);
end
tic
% Fit the HMM model
[beta_a,beta_b,A,pi,LL1]=hmmbeta_fit(Y,N,K,max_cycles,tolerance,km_init);

% Note that the above line returns gives the parameters at each EM 
% iteration as output. Comment out these lines if you need access to the 
% parameters as they evolve.
LL = LL1(end);
beta_a = beta_a{end};
beta_b = beta_b{end};
A = A{end};
pi = pi{end};

% Determine the probability of each state and observation using the
% estimated model
[gamma,alpha,Xi,B] = hmmbeta_test(Y,N,K,beta_a,beta_b, pi,A);

% Calculate the most likely path:
path = zeros(1,sum(N));
delta = zeros(K,sum(N));
loglik = zeros(size(N));
for l = 1:L
    ind = (sum(N(1:l-1))+1):sum(N(1:l));
    [path(ind), loglik(l),delta(:,ind)] = viterbi_path(pi(l,:), ...
        A, B(ind,:)');
end

% Reassign state labels based on scaled power in gamma freq band
Mu = beta_a./(beta_a+beta_b);   
h_sort = find((freq_bands(:,1)<= 45).*(freq_bands(:,2)>= 45));
[~,map] = sort(Mu(:,h_sort));
path2 = path;
A2 = A; 
A3 = A;
alpha2 = alpha;
Xi2 = Xi;
Xi3 = Xi;
pi2 = pi;
gamma2 = gamma;
beta_a2 = beta_a;
beta_b2 = beta_b;

for k = 1:K
    path(path2==map(k)) = k;
    A2(k,:) = A(map(k),:);
    Xi2(:,k,:) = Xi(:,map(k),:);
    beta_a2(k,:) = beta_a(map(k),:);
    beta_b2(k,:) = beta_b(map(k),:);
end
beta_a = beta_a2;
beta_b = beta_b2;
for k = 1:K
    if L>1
        pi(:,k) = pi2(:,map(k));
    else
        pi(k) = pi2(map(k));
    end
    Xi3(:,:,k) = Xi2(:,:,map(k));
    A3(:,k) = A2(:,map(k));
    gamma(:,k) = gamma2(:,map(k));
    alpha(:,k) = alpha2(:,map(k));
end
A = A3;
Xi = Xi3;
% 
comptime = toc;


end