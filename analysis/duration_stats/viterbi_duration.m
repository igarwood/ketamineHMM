function [mean_dur] = viterbi_duration(path,states)

path2 = zeros(size(path));
for j = 1:length(states)
    k = states(j);
    path2(path==k) = 1;
end
durations = state_dur(path2,1);
mean_dur = mean(durations);

end