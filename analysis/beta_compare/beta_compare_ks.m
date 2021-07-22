function [ks_dist] = beta_compare_ks(beta_a1,beta_b1,beta_a2,beta_b2)

K = size(beta_a1,1);
H = size(beta_a1,2);
ks_dist = zeros(K,H);
N = 100000;

for h = 1:H
    for k = 1:K
        pd1 = makedist('Beta','a',beta_a1(k,h),'b',beta_b1(k,h));
        pd2 = makedist('Beta','a',beta_a2(k,h),'b',beta_b2(k,h));
        x1 = random(pd1,N,1);
        x2 = random(pd2,N,1);       
        [~,~,ks_dist(k,h)] = kstest2(x1,x2);
    end
end

end