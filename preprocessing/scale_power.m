function [y,scale_k] = scale_power(spectrogram,spec_freq, freq_bands)

spectrogram_db = pow2db(spectrogram);
H = size(freq_bands,1);
N = size(spectrogram_db,1);
y = zeros(N,H);
first_q = zeros(1,H);
third_q = zeros(1,H);
md = zeros(1,H);
scale_k = zeros(1,H);

for h = 1:H
    [~,low] = min(abs(spec_freq-freq_bands(h,1)));
    [~,high] = min(abs(spec_freq-freq_bands(h,2)));
    y0 = mean(spectrogram_db(:,low:high),2)';
    first_q(h) = quantile(y0,0.25);
    third_q(h) = quantile(y0,0.75);
    scale_k(h) = 2*(log(3))/(third_q(h)-first_q(h));
    md(h) = median(y0);
    y(:,h) = 1./(1+exp(-scale_k(h).*(y0-md(h))));
end

end