function f = betalik(x,p)

f(1) = sum(log(x)) - length(x)*(-psi(p(1)+p(2))+psi(p(1)));
f(2) = sum(log(1-x)) - length(x)*(-psi(p(1)+p(2))+psi(p(2)));
end