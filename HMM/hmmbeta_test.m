function [alpha,gamma,Xi,B] =hmmbeta_test(Y,N,K,beta_a,beta_b,pi,A)
% Beta Observation Hidden Markov Model
% Indie Garwood
% October 2020
%
% This code was primarily based on Machine Learning Toolbox, Version 1.0
% 01-Apr-96 by Zoubin Ghahramani, University of Toronto

H=length(Y(1,:));
L=length(N);

Y(:,:)= Y(:,:)*(1-4E-12)+2E-12;


Y2 = repmat(Y,1,1,K);
betaa = zeros(1,H,K);
betaa(1,:,:) = beta_a';
betaa2 = repmat(betaa,sum(N),1,1);
betab = zeros(1,H,K);
betab(1,:,:) = beta_b';
betab2 = repmat(betab,sum(N),1,1);
B = squeeze(prod(betapdf(Y2,betaa2,betab2),2));

B(B==0) = 1e-12;

alpha=zeros(sum(N),K);
beta = ones(sum(N),K);

for n = 1:L
    ind = (sum(N(1:n-1))+1):sum(N(1:n));
    indxi = (sum(N(1:n-1)-1)+1):sum(N(1:n)-1);
    
    scale=zeros(N(n),1);
    alpha(ind(1),:)=pi(n,:).*B(ind(1),:);
    scale(1)=sum(alpha(ind(1),:));
    alpha(ind(1),:)=alpha(ind(1),:)/scale(1);
    for i=2:N(n)
      alpha(ind(i),:)=(alpha(ind(i-1),:)*A).*B(ind(i),:);
      scale(i)=sum(alpha(ind(i),:));
      alpha(ind(i),:)=alpha(ind(i),:)/scale(i);
    end

    for i=N(n)-1:-1:1
      beta(ind(i),:)=(beta(ind(i+1),:).*B(ind(i+1),:))*(A'); 
      beta(ind(i),:) = beta(ind(i),:)/scale(i+1);
    end
    
    gamma=(alpha.*beta); 
    xi=zeros(sum(N)-L,K*K);
    for i=1:N(n)-1
      t=A.*( alpha(ind(i),:)' * (beta(ind(i+1),:).*B(ind(i+1),:)));
      t(t==0) = 1e-12;
      xi(indxi(i),:)=t(:)'/scale(i+1);
    end

    Xi = reshape(xi,sum(N)-L,K,K);
end

end