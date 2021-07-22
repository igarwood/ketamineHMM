function [prob_diff, ks_dist, Z, FZ] = beta_compare(beta_a1,beta_b1,beta_a2,beta_b2)
% Calculate CDF(Delta), Pr(delta <= 0) 

if nargin == 2
    model = 1;
elseif nargin == 4
    model = 2;
end


K = size(beta_a1,1);
H = size(beta_a1,2);

prob_diff = zeros(K,K,H);
ks_dist = zeros(K,K,H);
for h = 1:H
    for j = 1:K
        if model == 1 
            kend = j;
        else
            kend = K;
        end
        for k = 1:kend
            if model == 1
                a1 = beta_a1(j,h);
                b1 = beta_b1(j,h);
                a2 = beta_a1(k,h);
                b2 = beta_b1(k,h);
            else
                a1 = beta_a1(j,h);
                b1 = beta_b1(j,h);
                a2 = beta_a2(k,h);
                b2 = beta_b2(k,h);
            end
            [fZ,Z] = beta_compare_pdf(a1,b1,a2,b2,[]);
            fZ(isnan(fZ)) = 0;
            fZ(isinf(fZ)) = 0;
            FZ = cumsum(((fZ(2:end)+fZ(1:end-1))/2)*(Z(2)-Z(1)));
            [~,zeroind] = min(abs(Z));
            prob_diff(j,k,h) = FZ(zeroind);
            ks_dist(j,k,h) = beta_compare_ks(a1,b1,a2,b2);
            
        end
    end
end