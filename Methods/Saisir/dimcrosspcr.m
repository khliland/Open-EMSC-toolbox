function[pcrres]=dimcrosspcr(x,y,dimmax,inval)
%dimcrosspcr1			- crossvalidation of PCR (validation samples in sequence)
%  function [pcrres]=dimcrosspcr(x,y,dimmax,inval)
%  dimmax= max number of PCR dimension;
%  inval: number of observations (in sequence) in cross-validation at each step
%  returns predy,rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  both predy and rmsecv are saisir files

if(size(y.d,2)~=1)
   help dimcrosspcr;
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
   pcrtype=pcr(xcal,ycal,dimmax);
	crossvaly=applypcr(pcrtype, xval);
	if(i==1) predy=crossvaly; else predy= appendrow(predy,crossvaly);end;
end
%size(predy.d)
%size(y.d(1:nend,1))
%size(ones(1,dimmax))
residual=predy.d-y.d(1:nend,1)*ones(1,dimmax);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
rmsecv.v=pcrtype.beta.i;
co=corrcoef([predy.d y.d(1:nend,1)]);% J'EN SUIS LA (A VERIFIER)
corr.d=co(1:dimmax,dimmax+1)';%
corr.v=pcrtype.beta.i;
corr.i='Correlation coefficient'
pcrres.predy=predy; pcrres.rmsecv=rmsecv; pcrres.corr=corr;