function[plsres]=dimcrosspls1a(x,y,dimmax,selected)
%dimcrosspls1a 		- crossvalidation of PLS (changing the dimensions)
%  function [plsres]=dimcrosspls1a(x,y,dimmax,selected)
%  THIS FUNCTION IS OBSOLETE ! 
%  USE CROSSVALPLS1A IN REPLACEMENT ! 
%  dimmax= max number of PLS dimension;
%  "selected": vector giving the samples in validation. 1: in validation; 0 in calibration
%  returns rmsecv,corr as a function of the number of introduced components
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  both predy and rmsecv are saisir files

if(size(y.d,2)~=1)
   help dimcrosspls;
   error('y must have only one column');
end;   
ntest=sum(selected);
for i=1:dimmax
   disp(['PLS cross validation with ' num2str(i) ' factors'  ]);
   [res]=crossvalpls1a(x,y,i,selected);
   %[predy,obsy,rmsecv,corr]=crossvalpls1(x,y,ndim,inval,ntest)
   rmsecv.d(1,i)=res.validation.RMSEV;
   if(ntest>1)
        corr.d(1,i)=res.validation.r2;
   end
   %res.corr
	beta.d(:,i)=res.calibration.beta.d;   
end;

for i=1:dimmax
   chaine=['D' num2str(i) '        '];
   rmsecv.v(i,:)=chaine(1:6);
end
plsres.beta.i=x.v;
plsres.beta.v=rmsecv.v;
plsres.beta.d=beta.d;
rmsecv.i='rootmean square error of crossvalidation';
corr.i='correlation coefficient';
corr.v=rmsecv.v;
plsres.rmsecv=rmsecv;
plsres.corr=corr;
