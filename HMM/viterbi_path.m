function [path, loglik,delta] = viterbi_path(pi, A, B)
% VITERBI Find the most-probable (Viterbi) path through the HMM state 
% trellis.
%
% Hidden Markov Model (HMM) Toolbox written by Kevin Murphy (1998)
% 
%
% Inputs:
% pi(i) = Pr(K(1) = i)
% A(j,k) = Pr(K(t+1)=k | K(t)=j)
% B(k,n) = Pr(y(n) | K(n)=k)
%
% Outputs:
% path(n) = k(n), where k1 ... kN is the argmax of the above expression.


% delta(k,n) = prob. of the best sequence of length n-1 and then going to state k, and O(1:n)
% psi(k,n) = the best predecessor state, given that we ended up in state k
% at n

scaled = 1;

N = size(B, 2);
pi = pi(:);
K = length(pi);

delta = zeros(K,N);
psi = zeros(K,N);
path = zeros(1,N);
scale = ones(1,N);

n=1;
delta(:,n) = pi .* B(:,n);
if scaled
  [delta(:,n), scale(n)] = normalise(delta(:,n));
end
psi(:,n) = 0; % arbitrary value, since there is no predecessor to t=1
for n=2:N
  for k=1:K
    [delta(k,n), psi(k,n)] = max(delta(:,n-1) .* A(:,k));
    delta(k,n) = delta(k,n) * B(k,n);
  end
  if scaled
    [delta(:,n), scale(n)] = normalise(delta(:,n));
  end
end
[p, path(N)] = max(delta(:,N));
for n=N-1:-1:1
  path(n) = psi(path(n+1),n+1);
end

% loglik = log p.
% If scaled==0, p = prob_path(best_path)
% If scaled==1, p = Pr(replace sum with max and proceed as in the scaled forwards algo)
% loglik computed by the two methods will be different, but the best path will be the same.

if scaled
  loglik = -sum(log(scale));
else
  loglik = log(p);
end
