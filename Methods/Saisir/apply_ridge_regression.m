function[res]=apply_ridge_regression(ridgetype, x,y)
%apply_ridge_regression      - applies ridge regression on "unknown data"
%function[res]=apply_ridge_regression(ridgetype,x,(y))
% if y is given, the verification stats (RMSECV are also assessed)
%SAISIR FUNCTION

[n,p]=size(x.d);
size(ridgetype.averagex.d);
x.d=x.d-ones(n,1)*ridgetype.averagex.d;
predy.d=x.d*ridgetype.beta.d + ridgetype.averagey.d*ones(size(x.d,1),size(ridgetype.beta.d,2));
predy.i=x.i;
predy.v=ridgetype.beta.v;

if(nargin>2)
   aux=predy.d-y.d*ones(1,size(ridgetype.beta.d,2));
   rmsecv.d=sqrt(sum(aux.*aux)/n);
   rmsecv.i='RMSECV';
   rmsecv.v=ridgetype.beta.v;
   corr.d=zeros(1,size(ridgetype.beta.d,2));
   for i=1:size(ridgetype.beta.d,2)
      aux=corrcoef(y.d,predy.d(:,i));
   	corr.d(1,i)=aux(1,2);
	end;   
	corr.i='correlation coefficient';
	corr.v=ridgetype.beta.v;;
   res.corr=corr;
   res.rmsecv=rmsecv;
end
res.predy=predy;
