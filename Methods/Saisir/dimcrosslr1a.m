function[lr1res]=dimcrosslr1a(x,y,dimmax,selected,ratioxy)
%dimcrosslr1a 					- cross validation of latent root model LRR1 
%function[lr1res]=dimcrosslr1a(x,y,dimmax,selected,ratioxy)
%dimmax= max number of lr dimension;
%selected: number of observations selected in verification set (=1)
%ratioxy: importance given to x (norm of x divided by this ratio. default:1 ) 
%returns rmsecv,corr
%rmsecv is the root mean square error of crossvalidation
%y must contain a single variable! 
%both corr and rmsecv are saisir files
if(nargin<5) ratioxy=0.5; end;
if(size(y.d,2)~=1)
   help dimcrosslr1;
   error('y must have only one column');
end;   
nind=size(x.d,1);
nend=sum(selected);
[xval, xcal]=splitrow(x,selected==1);
[yval, ycal]=splitrow(y,selected==1);
lr1type=lr1(xcal,ycal,dimmax,ratioxy);
%[aux index]=sort(lr1type.corrcoef.d*(-1));%contains the order of the max correlation coef 
crossvaly=applylr1(lr1type, xval);
predy=crossvaly;
obsy=yval;   

residual=predy.d-obsy.d*ones(1,dimmax);
rmsecv.d=sqrt(sum(residual.*residual)/nend);
rmsecv.i='RMSECV';
co=corrcoef([predy.d obsy.d]);
corr.d=co(1:dimmax,dimmax+1)';
corr.v=lr1type.beta.v;
corr.i='Correlation coefficient';
rmsecv.v=corr.v;
lr1res.predy=predy;
lr1res.obsy=obsy;
lr1res.rmsecv=rmsecv; lr1res.corr=corr;
lr1res.ratioxy=ratioxy;
lr1res.lrtype=lr1type;
%lr1res.index=index;

