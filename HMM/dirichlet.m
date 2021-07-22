function p = dirichlet(alpha)
    x = gamrnd(alpha,1);
    p = x./repmat(sum(x,2),1,size(x,2));
end