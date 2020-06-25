function [saisir] = durbin_watson(saisir1)
%durbin_watson		 		- assess the durbin watson value on the column of a table1
%function [saisir] = durbin_watson(X)
% normally used to see if th eigenvectors of PCA are random signals
% from an idea of D. Rutledge and A. Barros (INA-Paris), 2000. 
% data are random if the coeff is around 2;
[nrow ncol]=size(saisir1.d);
for i=1:ncol;
   s2=0;s1=0;
   i
   for j=2:nrow;
      aux=saisir1.d(j-1,i)-saisir1.d(j,i);
      s2=s2+aux*aux;
      s1=s1+saisir1.d(j,i)*saisir1.d(j,i);
   end;
   saisir.d(1,i)=s2/s1;
end;
saisir.v=saisir1.v;
saisir.i='durbin_watson value';