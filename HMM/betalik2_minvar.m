function f = betalik2_minvar(x,gamma,p)

a = p(1);
b = p(2);
f(1) = sum(gamma.*(log(x) - (-psi(a+b)+psi(a))))+...
    (b*(b^2-a*b+b-a*(2*a+1)))/((b+a)^3*(b+a+1)^2)*p(3);
f(2) = sum(gamma.*(log(1-x) - (-psi(a+b)+psi(b))))+...
    (a*(a^2-b*a+a-b*(2*b+1)))/((a+b)^3*(a+b+1)^2)*p(3);


% % % term to minimize variance:
f(3) = a*b/(((a+b)^2)*(a+b+1));
end