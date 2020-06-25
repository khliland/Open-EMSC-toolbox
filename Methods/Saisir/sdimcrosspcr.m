function[spcrres]=sdimcrosspcr(x,y,dimmax,maxrank,inval)
%sdimcrosspcr		- crossvalidation of stepwise PCR (changing dimensions) 
%  function [spcrres]=sdimcrosspcr(x,y,dimmax,maxrank,inval)
%  dimmax= max number of components in the model;
%  maxrank maximum rank of the considered components
%  inval: number of observations (in sequence) in cross-validation at each step
%  returns predy,rmsecv,corr
%  rmsecv is the root mean square error of crossvalidation
%  y must contain a single variable! 
%  both predy and rmsecv are saisir files

if(size(y.d,2)~=1)
   help sdimcrosspcr;
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
   spcrtype=spcr(xcal,ycal,dimmax,maxrank);
	crossvaly=applyspcr(spcrtype, xval);
	if(i==1) predy=crossvaly; else predy= appendrow(predy,crossvaly);end;
end
%size(predy.d)
%size(y.d(1:nend,1))
%size(ones(1,dimmax))
residual=predy.d-y.d(1:nend,1)*ones(1,dimmax);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
co=corrcoef([predy.d y.d(1:nend,1)]);% J'EN SUIS LA (A VERIFIER)
corr.d=co(1:dimmax,dimmax+1)';%
corr.v=spcrtype.beta.i;
corr.i='Correlation coefficient';
spcrres.predy=predy; spcrres.rmsecv=rmsecv; spcrres.corr=corr;