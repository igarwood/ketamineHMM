% Beta Observation Hidden Markov Model
% Indie Garwood
% October 2020
%
% This code was primarily based on Machine Learning Toolbox, Version 1.0
% 01-Apr-96 by Zoubin Ghahramani, University of Toronto
%
% Y - sum(N) x H data matrix
% N - length of each sequence (sum(N) must equal size(Y,1)
% K - number of states (default 2)
% max_cycles - maximum number of cycles of Baum-Welch (default 100)
% tolerance - termination tolerance (prop change in likelihood) (default 0.0001)
%
% beta_a, beta_b - estimated observation beta distribution parameters
% P - state transition matrix
% Pi - initial state probability
% LL - log likelihood curve
%
% Iterates until a proportional change < tol in the log likelihood 
% or cyc steps of Baum-Welch




function [betaa_cell,betab_cell,A_cell,pi_cell,LL]...
    =hmmbeta_fit_beta_fixed(Y,N,K,max_cycles,tolerance,km_init,beta_a,beta_b)


if nargin<6   km_init = 0; end
if nargin<5   tolerance=0.0001; end
if nargin<4   max_cycles=100; end
if nargin<3   K=2; end
if nargin<2   N=size(Y,1); end

L=length(N);
H = size(Y,2);

% Scale Y to avoid divide by zero error:
Y(:,:)= Y(:,:)*(1-4E-12)+2E-12;

% For optimization problems:
p0 = [1,1];
options = optimset('Display','off', 'UseParallel' , false,'MaxFunEvals',5000);

Var = zeros(K,H);
Mu = zeros(K,H);


% K-means initialization will first create clusters and estimate parameters
% based on which each datapoint belongs to
if km_init
    kmeans_idx = kmeans(Y,K,'distance','cityblock','replicates',5);

    gamma0=zeros(sum(N),K);
    xi0=zeros(sum(N)-L,K*K);
    
    for l = 1:L        
        ind = (sum(N(1:l-1))+1):sum(N(1:l));
        indxi = (sum(N(1:l-1)-1)+1):sum(N(1:l)-1);
        for j = 1:K
            gamma0(ind,j) = kmeans_idx(ind)==j;
            for k = 1:K
                xi0(indxi,(j-1)*K+k) = (kmeans_idx(ind(1:end-1))==...
                    j & kmeans_idx(ind(2:end))==k);
            end
        end
    end
    
    
    % transition matrix 
    sxi=rsum(xi0')';
    sxi=reshape(sxi,K,K);
    A=rdiv(sxi,rsum(sxi));
    
    % intial state probabilities
    pi=zeros(L,K);
    for l=1:L
        pi(l,:)=gamma0((l-1)*N(l)+1,:);
    end
else
    pi = ones(L,K);
    for l = 1:L
        pi(l,:) = dirichlet(pi(l,:)*1/K);
    end
    
    A = ones(K);
    A = A*1/K;
end

Mu_cell(1) = {Mu};
Var_cell(1) = {Var};
betaa_cell(1) = {beta_a};
betab_cell(1) = {beta_b};
A_cell(1) = {A};
pi_cell(1) = {pi};

LL=[];
lik=0;

cycle = 1;

while cycle <= max_cycles
  Gamma=[];
  Xi = [];
  Scale = 0;

  Gammasum=zeros(1,K); 
  for l=1:L 
    alpha = zeros(N(l),K);
    beta = zeros(N(l),K);
    
    ind = (sum(N(1:l-1))+1):sum(N(1:l));
    
    Y2 = repmat(Y(ind,:),1,1,K);
    betaa = zeros(1,H,K);
    betaa(1,:,:) = beta_a';
    betaa2 = repmat(betaa,N(l),1,1);
    betab = zeros(1,H,K);
    betab(1,:,:) = beta_b';
    betab2 = repmat(betab,N(l),1,1);
    B = squeeze(prod(betapdf(Y2,betaa2,betab2),2));
    B(B==0) = 1e-12;
    
    scale=zeros(N(l),1);
    alpha(1,:)=pi(l,:).*B(1,:);
    scale(1)=sum(alpha(1,:));
    alpha(1,:)=alpha(1,:)/scale(1);
    for n=2:N(l)
      alpha(n,:)=(alpha(n-1,:)*A).*B(n,:);
      scale(n)=sum(alpha(n,:));
      alpha(n,:)=alpha(n,:)/scale(n);
    end
    
    beta(N(l),:)=ones(1,K);
    for n=N(l)-1:-1:1
      beta(n,:)=(beta(n+1,:).*B(n+1,:))*(A'); 
      beta(n,:) = beta(n,:)/scale(n+1);
    end
    
    gamma=(alpha.*beta); 
    gammasum=sum(gamma);
    
    xi=zeros(N(l)-1,K*K);
    for n=1:N(l)-1
      t=A.*( alpha(n,:)' * (beta(n+1,:).*B(n+1,:)));
      t(t==0) = 1e-12;
      xi(n,:)=t(:)'/scale(n+1);
    end
    
    Scale=Scale+sum(log(scale));
    Gamma=[Gamma; gamma];
    Gammasum=Gammasum+gammasum;
    Xi=[Xi;xi];
  end
  oldlik=lik;
  lik=sum(Scale);
  LL=[LL lik];
  LLnorm = LL/LL(1);
  
  %%%% M STEP 
  % outputs

  % transition matrix 
  sxi=rsum(Xi')';
  sxi=reshape(sxi,K,K);
  A=rdiv(sxi,rsum(sxi));
  
  % Initial state probabilities
  pi=zeros(1,K);
  for l=1:L
    pi(l,:)=Gamma((sum(N(1:l-1))+1),:);
  end

  Mu_cell(end+1) = {Mu};
  Var_cell(end+1) = {Var};
  betaa_cell(end+1) = {beta_a};
  betab_cell(end+1) = {beta_b};
  A_cell(end+1) = {A};
  pi_cell(end+1) = {pi};

  
  if (cycle<=5)
    likbase=lik;
   elseif ((lik-likbase)<(1 + tolerance)*(oldlik-likbase)||~isfinite(lik))
    break;
  end

    cycle = cycle + 1;
end
