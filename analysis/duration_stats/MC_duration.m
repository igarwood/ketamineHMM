function [mean_dur] = MC_duration(A,states,N,N_MC)

if nargin < 4
    N_MC = 4000;
end
if nargin < 3
    N = 2000;
end
K = size(A,1);
mean_dur = zeros(1,N_MC);

for i = 1:N_MC
    pi = zeros(1,K);
    pi(states) = 1/length(states);
    path = gen_markov_path(A, pi, N);
    path2 = zeros(size(path));
    for j = 1:length(states)
        k = states(j);
        path2(path==k) = 1;
    end
    durations_i = state_dur(path2',1);
    mean_dur(i) = mean(durations_i);
end


end