function path = gen_markov_path(A, pi, N)
% Generate markov path

P0 = cumsum(pi);
path = zeros(N,1);
path(1) = find(rand<P0,1);

for i = 2:N
    A_i = cumsum(A(path(i-1),:));
    r = rand;
    path(i) = find(r<A_i,1);
end

end