function[plsres]=dimcrosspls1(x,y,dimmax,inval,ntest)
%dimcrosspls1 		- crossvalidation of PLS (changing the dimensions)
%  function [plsres]=dimcrosspls1(x,y,dimmax,inval,ntest)
%  dimmax= max number of PLS dimension;
%  inval: number of observations randomy selected in cross-validation at each step
%  returns rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  both predy and rmsecv are saisir files

if(size(y.d,2)~=1)
   help dimcrosspls;
   error('y must have only one column');
end;   
for i=1:dimmax
   disp(['cross validation with ' num2str(i) ' factors'  ]);
   [py,oy,rmsec,cor]=crossvalpls1(x,y,i,inval,ntest);
   %[predy,obsy,rmsecv,corr]=crossvalpls1(x,y,ndim,inval,ntest)

   rmsecv.d(1,i)=rmsec;
   corr.d(1,i)=cor;
   cor
end;

for i=1:dimmax
   chaine=['D' num2str(i) '        '];
   rmsecv.v(i,:)=chaine(1:6);
end
rmsecv.i='rootmean square error of crossvalidation';
corr.i='correlation coefficient';
corr.v=rmsecv.v;
plsres.rmsecv=rmsecv;
plsres.corr=corr;