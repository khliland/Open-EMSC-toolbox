function[plstype]=dimpls(x,y,ndim)
%dimpls 			- applies PLS on saisir data
%function [plstype]=dimpls(x,y,dim)
%assess a pls1 model on files following the saisir format
%returns plstype.beta, plstype.beta0,plstype.predy  
%CHANGE THE DIMENSIONS

for i=1:ndim
   disp(i);
   p=saisirpls(x,y,i);
   plstype.beta.d(:,i)=p.beta.d;
   plstype.beta0.d(i)=p.beta0.d;
   plstype.correlation.d(i)=p.correlation.d;
   plstype.predy.d(:,i)=p.predy.d;
end
aux=y.d*ones(1,ndim);
aux1=plstype.predy.d-aux;
df=ones(1,ndim)*size(x.d,1) -(1:ndim) -1;%% degrees of freedom n-k-1 for each dimension
%size(sum(aux1.*aux1))
%size(df)
plstype.rmsec.d=sqrt(sum(aux1.*aux1)./df);
plstype.beta.v=num2str((1:ndim)');
plstype.beta.i=x.v;
plstype.correlation.v=num2str((1:ndim)');
plstype.correlation.i='correlation coefficient';
plstype.predy.i=x.i;
plstype.predy.v=num2str((1:ndim)');
plstype.beta0.v=num2str((1:ndim)');
plstype.beta0.i='beta0';
plstype.rmsec.i='RMSEC';
plstype.rmsec.v=num2str((1:ndim)');
