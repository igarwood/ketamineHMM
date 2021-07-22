function Z=rsum(X)
% This function is from Machine Learning Toolbox, Version 1.0
% 01-Apr-96 by Zoubin Ghahramani, University of Toronto
%
% row sum
% function Z=rsum(X)

Z=zeros(size(X(:,1)));

for i=1:length(X(1,:))
  Z=Z+X(:,i);
end
