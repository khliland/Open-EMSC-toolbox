function [saisir] = reduce_nvariable(saisir1,nvar)
%reduce_nvariable          - reduces the number of variables by averaging
%[X] = reduce_nvariable(X1,nvar)
%From the original data, averages nvar neighbouring columns.
%The number of resulting variables is roughly equal to nvariable/nvar 
%A few variables (less than nvar) might be lost at the end of the data 
%nvar is preferably an odd value

[n,p]=size(saisir1.d);
d=saisir1.d;
index=0;
gap=floor(nvar/2);
for i=1:nvar:p-nvar
   index=index+1;
   aux=d(:,i:i+nvar-1)';
   aux1=mean(aux);
   saisir.d(:,index)=aux1';
   %i+gap
   saisir.v(index,:)=saisir1.v(i+gap,:);
end
saisir.i=saisir1.i;

   