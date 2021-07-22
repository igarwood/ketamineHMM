function Z=rprod(X,Y)
% This function is from Machine Learning Toolbox, Version 1.0
% 01-Apr-96 by Zoubin Ghahramani, University of Toronto
%
% row product
% function Z=rprod(X,Y)

[n m]=size(X);

if(length(Y(:,1)) ~=n  | length(Y(1,:)) ~=1)
  disp('Error in RPROD');
  return;
end

Z=X.*(Y*ones(1,m));
