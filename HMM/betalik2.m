function f = betalik2(x,gamma,p)

f(1) = sum(gamma.*(log(x) - (-psi(p(1)+p(2))+psi(p(1)))));
f(2) = sum(gamma.*(log(1-x) - (-psi(p(1)+p(2))+psi(p(2)))));

% % % term to minimize variance:
% f(3) = 0.8*length(x)*p(1)*p(2)/(((p(1)+p(2))^2)*(p(1)+p(2)+1));
end