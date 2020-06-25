function [saisir] = distance(saisir1,saisir2)
%distance 			- Usual Euclidian distances between the
%two tables
%function [D] = distance(X1,X2)
%the tables must have the same number of columns
[nrow1 ncol1]=size(saisir1.d);
[nrow2 ncol2]=size(saisir2.d);
if(ncol1~=ncol2); error('The number of columns must be equal');end
aux=ones(nrow1,1);
for i2=1:nrow2
   delta=(saisir1.d-aux*saisir2.d(i2,:))';
   delta=delta.*delta;
   saisir.d(:,i2)=sqrt(sum(delta,1));
end
saisir.i=saisir1.i;
saisir.v=saisir2.i;
   