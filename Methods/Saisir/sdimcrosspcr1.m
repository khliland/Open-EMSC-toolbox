function[pcrres]=sdimcrosspcr1(x,y,maxdim,maxrank,selected,corr_cov)
%sdimcrosspcr1			- crossvalidation of stepwisePCR 
%  (samples in validation are selected) 
%  function [pcrres]=sdimcrosspcr1(x,y,dimmax,maxrank,selected,(corr_cov))
%  dimmax  : max number of PCR dimension;
%  maxrank : the selection of components is limited to the first maxrank components  
%  selected: vector of samples selected as calibration set (==0)
%  and verification set (==1)
%  returns predy,rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  corr_cov: =1: introduction of components in the order of r2 between y and component 
%  coor_cov: =0: introduction in the order of covariance between y and component 

if(nargin<6); corr_cov=1;end
nval=sum(selected==1);
if(size(y.d,2)~=1)
   help dimcrosspcr;
   error('y must have only one column');
end;   
nind=size(x.d,1);
nend=nind;
[xval, xcal]=splitrow(x,(selected==1));
[yval, ycal]=splitrow(y,(selected==1));
pcrtype=spcr(xcal,ycal,maxdim,maxrank,corr_cov);
crossvaly=applyspcr(pcrtype, xval);
predy=crossvaly;
size(predy.d);
size(yval.d);
%size(ones(1,dimmax))
residual=predy.d-yval.d*ones(1,maxdim);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
rmsecv.v=pcrtype.beta.i;
co=corrcoef([predy.d yval.d]);
corr.d=co(1:maxdim,maxdim+1)';%
corr.v=pcrtype.beta.i;
corr.i='Correlation coefficient';
pcrres.predy=predy; pcrres.rmsecv=rmsecv; pcrres.corr=corr;
pcrres.y=yval;
pcrres.pcrtype=pcrtype;