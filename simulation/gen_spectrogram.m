function [sim_spec,sim_path,A,pi] = gen_spectrogram(spectrogram,spec_freq,...
    freq_bands,A,pi,M)
% Generate a spectrogram from an underlying Markov process using the data 
% in spectrogram and the model specified by model_file.
k = length(pi);
clustered_spectrogram = kmeans_spectrogram(spectrogram,k,spec_freq,...
        freq_bands);
sim_path = gen_markov_path(A,pi, M);

sim_spec = zeros(M,size(spectrogram,2));
for l = 1:k
    sample_ind = randsample(size(clustered_spectrogram{l},1),...
        sum(sim_path==l),1);
    sim_spec(sim_path==l,:) = clustered_spectrogram{l}(sample_ind,:);
end

end
