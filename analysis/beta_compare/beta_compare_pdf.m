function [fDelta,Delta] = beta_compare_pdf(beta_a1,beta_b1,beta_a2,beta_b2,Delta)

tiny = 0;%1e-9;
if isempty(Delta)
    Delta = linspace(-1+tiny,1-tiny,10000);
end

fDelta = zeros(size(Delta));

for i = 1:length(Delta)
    delta = Delta(i);
    fun = @(w) w.^(beta_a1-1).*(1-w).^(beta_b1-1)./beta(beta_a1,beta_b1)...
       .* (w-delta).^(beta_a2-1).*(1-(w-delta)).^(beta_b2-1)./beta(beta_a2,beta_b2);
    if delta <= 0
        fDelta(i) = integral(fun,0,1+delta);
    else
        fDelta(i) = integral(fun,delta,1);
    end
end
