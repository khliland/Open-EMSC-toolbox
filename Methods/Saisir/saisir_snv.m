function [saisir] = saisir_snv(saisir1)
%snv 			- Standard normal variate correction on spectra
%function [X1] = snv(X)
%SNV is commonly used in spectroscopy. It basically consists in centering
%and standardizing the ROWS (not the columns) of the data matrix. 
%This procedure may reduce the scatter deformation of spectra

[nrow ncol]=size(saisir1.d);
saisir.d=zeros(nrow,ncol);
for row= 1:nrow
   if(mod(row,10000)==0)
       disp(num2str([row nrow]));
   end
   std1=std(saisir1.d(row,:));
   ave=mean(saisir1.d(row,:));
   saisir.d(row,:)=(saisir1.d(row,:)-ones(1,ncol)*ave)/std1;
end
saisir.v=saisir1.v;
saisir.i=saisir1.i;