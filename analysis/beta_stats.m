function [skewprob, mu] = beta_stats(beta_a,beta_b)
% Calculate the probability that the beta distribution is right skewed (i.e.
% (1-cdf(0.5)) and the mean of the beta distribution

skewprob = zeros(size(beta_a));
mu = zeros(size(beta_a));

for k = 1:size(beta_a,1)
    for h = 1:size(beta_a,2)
        skewprob(k,h) = 1-cdf('Beta',0.5,beta_a(k,h),beta_b(k,h));
        mu(k,h) = beta_a(k,h)/(beta_a(k,h)+beta_b(k,h));
    end
end
