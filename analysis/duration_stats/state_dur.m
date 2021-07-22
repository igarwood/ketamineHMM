function durations = state_dur(path,state)
% State should be >= 1 
% Duration unit = number of timepoints

% pad the path to avoid edge error
path = [0,path,0];

state_path = path==state;
diff_path = diff(state_path);

state_start = find(diff_path == 1);
state_end = find(diff_path == -1);
durations = (state_end-state_start);


end
