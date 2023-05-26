function f = betalik3(x,gamma,p)

f(1) = 2*p(1)*p(3) + sum(gamma.*(log(x) - (-psi(p(1)+p(2))+psi(p(1)))));
f(2) = 2*p(2)*p(3) + sum(gamma.*(log(1-x) - (-psi(p(1)+p(2))+psi(p(2)))));
f(3) = (p(1)^2 + p(2)^2)-2;

% % % term to minimize variance:
% f(4) = length(x)*p(1)*p(2)/((p(1)+p(2))^2*(p(1)+p(2)+1));

end