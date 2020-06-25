function [saisir] = mdistance(saisir1,saisir2,metric)
%mdistance 			- computes distances between the two tables using metric "metric"
% function [saisir] = mdistance(saisir1,saisir2,metric)
% the tables must have the same number of columns
% metric must be ncolx ncol
[nrow1 ncol1]=size(saisir1.d);
[nrow2 ncol2]=size(saisir2.d);
if(ncol1~=ncol2); error('The number of columns must be equal');end
aux=ones(nrow1,1);
for i2=1:nrow2
   delta=(saisir1.d-aux*saisir2.d(i2,:));
   aux1=delta*metric.d;
   delta=(aux1.*delta)';
   saisir.d(:,i2)=sqrt(sum(delta,1));
end
saisir.i=saisir1.i;
saisir.v=saisir2.i;
   