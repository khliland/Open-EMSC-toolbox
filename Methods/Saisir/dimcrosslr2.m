function[lr2res]=dimcrosslr2(x,y,dimmax,inval,ratioxy)
%dimcrosslr2 	- crossvalidation of model LRR2 
%  function [lr2res]=dimcrosslr2(x,y,dimmax,inval,ratioxy)
%  dimmax= max number of lr dimension;
%  inval: number of observations (in sequence) in cross-validation at each step
%  returns predy,rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  ratioxy(optional)the norm of x is divided with this value.(the role of x is multipled with ratioxy).default=1
%  both predy and rmsecv are saisir files
if(nargin<5) ratioxy=1;end;
if(size(y.d,2)~=1)
   help dimcrosslr2;
   error('y must have only one column');
end;   
nind=size(x.d,1);
nend=nind;
for i=1:inval:nind;
   disp(num2str(i));
   nend=i+inval-1;
   if(nend>nind)
   	disp(['Warning: samples with indices greater than ' num2str(i-1) ' not included in cross validation step']);
   	nend=i-1;
   	break;
   end;   
   [xval, xcal]=splitrow(x,i:(i+inval-1));
   [yval, ycal]=splitrow(y,i:(i+inval-1));
   lr2type=lr2(xcal,ycal,dimmax,ratioxy);
   crossvaly=applylr2(lr2type, xval);
   if(i==1) predy=crossvaly; else predy= appendrow(predy,crossvaly);end;
end
%size(predy.d)
%size(y.d(1:nend,1))
%size(ones(1,dimmax))
residual=predy.d-y.d(1:nend,1)*ones(1,dimmax);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
co=corrcoef([predy.d y.d(1:nend,1)]);
corr.d=co(1:dimmax,dimmax+1)';%
corr.v=lr2type.beta.i;
corr.i='Correlation coefficient';
lr2res.predy=predy; lr2res.rmsecv=rmsecv; lr2res.corr=corr;
lr2res.ratioxy=ratioxy;
