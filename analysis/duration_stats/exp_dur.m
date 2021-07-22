function durations = exp_dur(A,states)
% Calculate the expected value of the duration of each state in states
% Duration unit = number of timepoints 

A_diag = diag(A);
durations = 1./(1-A_diag);
durations = durations(states);

end
