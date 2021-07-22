function clusters = kmeans_spectrogram(spectrogram,K,spec_freq,freq_bands)
% Assign spectral data to K clusters
% If two inputs: form clusters from entire spectrogram
% If four inputs: form clusters from spectrogram averaged within freq_bands
%   Sort clusters according to power in the H'th frequency band

if nargin == 2
    H = [];
    spec = spectrogram;
elseif nargin == 4
    H = size(freq_bands,1);
    spec = zeros(size(spectrogram,1),H);
    for h = 1:H
        [~,low_ind] = min(abs(spec_freq-freq_bands(h,1)));
        [~,high_ind] = min(abs(spec_freq-freq_bands(h,2)));
        spec(:,h) = mean(pow2db(spectrogram(:,low_ind:high_ind)),2);
    end
else
    error('Check kmeans_spectrogram input arguments')
end

% K-means clustering
kmeans_ind = kmeans(spec,K,'distance','cityblock','replicates',5);
clusters = cell(1,K);
mean_H = zeros(K,1);
for k = 1:K
    clusters{k} = spectrogram(kmeans_ind==k,:); 
    if ~isempty(H)
        mean_H(k) = mean(spec(kmeans_ind==k,H)); 
    end
end

% If applicable, sort clusters according to power in the H'th frequency 
% band:
[~, sort_ind] = sort(mean_H);
clusters = clusters(sort_ind);

end
