function f = betalik2(x,gamma,p)

f(1) = sum(gamma.*(log(x) - (-psi(p(1)+p(2))+psi(p(1)))));
f(2) = sum(gamma.*(log(1-x) - (-psi(p(1)+p(2))+psi(p(2)))));

end