
function Z=rdiv(X,Y)
% This function is from Machine Learning Toolbox, Version 1.0
% 01-Apr-96 by Zoubin Ghahramani, University of Toronto
%
% row division: Z = X / Y row-wise
% Y must have one column 

if(length(X(:,1)) ~= length(Y(:,1)) | length(Y(1,:)) ~=1)
  disp('Error in RDIV');
  return;
end

Z=zeros(size(X));

for i=1:length(X(1,:))
  Z(:,i)=X(:,i)./Y;
end
