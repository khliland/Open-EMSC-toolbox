function[pcrres]=dimcrosspcr1(x,y,dimmax,selected)
%dimcrosspcr1			- crossvalidation of pCR (samples in validation are selected) 
%  function [pcrres]=dimcrosspcr1(x,y,dimmax,selected)
%  dimmax= max number of PCR dimension;
%  selected: vector of samples selected as calibration set (==0)
%  and verification set (==1)
%  returns predy,rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  both predy and rmsecv are saisir files
%  components introduced in the order of the eigenvalues
nval=sum(selected==1);
if(size(y.d,2)~=1)
   help dimcrosspcr;
   error('y must have only one column');
end;   
nind=size(x.d,1);
nend=nind;
[xval, xcal]=splitrow(x,(selected==1));
[yval, ycal]=splitrow(y,(selected==1));
pcrtype=pcr(xcal,ycal,dimmax);
crossvaly=applypcr(pcrtype, xval);
predy=crossvaly;
size(predy.d);
size(yval.d);
%size(ones(1,dimmax))

residual=predy.d-yval.d*ones(1,dimmax);
nend=size(yval.d,1);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
rmsecv.v=pcrtype.beta.i;
co=corrcoef([predy.d yval.d]);% J'EN SUIS LA (A VERIFIER)
if(size(co,1)>1)
   corr.d=co(1:dimmax,dimmax+1)';%
   corr.v=pcrtype.beta.i;
	corr.i='Correlation coefficient';
	pcrres.corr=corr;   
end;
pcrres.predy=predy; pcrres.rmsecv=rmsecv; 
pcrres.y=yval;
pcrres.pcrtype=pcrtype;
