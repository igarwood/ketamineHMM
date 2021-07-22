function [M, c] = normalise(M)
% NORMALISE Make the entries of a (multidimensional) array sum to 1
% [M, c] = normalise(M)
%

c = sum(M(:));
% Set any zeros to one before dividing
d = c + (c==0);
M = M / d;
c = 1/c;
