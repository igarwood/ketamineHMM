function [spectrogram, time, spec_freq,N] = ...
    load_data(file,sessions,start_t, end_t)

if nargin < 2
    sessions = [];
    L = 1;
else
    L = length(sessions);
end
if nargin < 4
    end_t = [];
end
if nargin < 3
    start_t = [];
end

N = zeros(1,L);
spec_freq =  csvread([file,'spec_freq.csv']);

for l = 1:L
    spectrogram_SS = csvread([file,num2str(sessions(l)),'_spec.csv']);
    time_SS =  csvread([file,num2str(sessions(l)),'_time.csv']);
    
    if isempty(end_t)
        end_t(l) = time_SS(end);
    end
    if isempty(start_t)
        start_t(l) = time_SS(1);
    end
    
    ind = find(time_SS<=end_t(l));
    ind = intersect(ind,find(time_SS>=start_t(l)));
    spectrogram_SS = spectrogram_SS(ind,:);
    time_SS = time_SS(ind);
    N(l) = length(time_SS);

    if l == 1
        spectrogram = spectrogram_SS;
        time = time_SS;
    else
        spectrogram = [spectrogram; spectrogram_SS];
        time = [time, time_SS];
    end
end

end
    