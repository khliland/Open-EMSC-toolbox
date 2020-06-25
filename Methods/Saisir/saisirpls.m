function[plstype]=saisirpls(x,y,ndim)
%saisirpls 			- PLS regression with "dim" dimensions
%function [plstype]=saisirpls(x,y,dim)
%assesses a pls1 model 
%returns plstype.beta, plstype.beta0,plstype.predy, plstype.correlation  
%Several variables can be predicted 
mx=mean(x.d);
xc = x.d-ones(size(x.d,1),1)*mx;
my=mean(y.d);
yc=y.d-ones(size(y.d,1),1)*my;
%function[b]  = pls1a(X,y,K)
[beta.d,ypred,t.d]=pls(xc,yc,ndim);
%beta.d=pls1a(xc,yc,ndim);
beta.i=x.v; beta.v= y.v;
beta0.d=-mx*beta.d+my; % intercept
beta0.v=y.v;beta0.i='beta0';
predy.d= x.d*beta.d+ones(size(x.d,1),1)*beta0.d;
predy.i=x.i;
predy.v=y.v;

plstype.beta=beta;
plstype.beta0=beta0;
plstype.predy=predy;
t.i=x.i;
for i=1:ndim
   chaine=['t' num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	t.v(i,:)=chaine(1:10);
end
plstype.T=t;
co=cormap(y,predy);
co.d=diag(co.d)';
co.v=y.v;
co.i='Correlation coefficients';
plstype.correlation=co;