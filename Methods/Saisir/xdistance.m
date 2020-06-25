function [dist] = xdistance(x1,x2)
%xdistance 			- assess the euclidian distances between two MATLAB matrices
% function [dist] = xdistance(x1,x2)
% the tables must have the same number of columns
[nrow1 ncol1]=size(x1);
[nrow2 ncol2]=size(x2);
if(ncol1~=ncol2); error('The number of columns must be equal');end
aux=ones(nrow1,1);
%dist=zeros(nrow1,nrow1);
for i2=1:nrow2
   %pxn
   delta=(x1-aux*x2(i2,:))';
   %size(delta)
   %p*n
   delta=delta.*delta;
   %size(sqrt(sum(delta)))
   dist(i2,:)=sqrt(sum(delta,1));
end

