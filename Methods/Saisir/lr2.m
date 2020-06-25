function[lr2type]=lr2(x,y,maxdim,ratioxy)
%lr2			- latent root 2 model (not very efficient) 
% function [lr2type]=lr2(x,y,maxdim,ratioxy): maximization of projected y
% assess a lr2 model on files following the saisir format
% returns lr2type
%ratioxy(optional)the norm of x is divided with this value.(the role of x is multipled with ratioxy).default=1
% returns the individual predictors and the y predicted with 1 to maxdim latent variables  
if(nargin<4) ratioxy=1;end;
average.d=mean(x.d);
[n,p]=size(x.d);
x.d=x.d-ones(n,1)*average.d;
averagey=mean(y.d);
y.d=y.d-averagey*ones(n,1);
normx=norm(x.d,'fro')/ratioxy;
normy=norm(y.d);
x.d=x.d/normx;y.d=y.d/normy;
yx=appendcol(y,x);
mypca=pca(yx);
[gamma gamma0]=splitrow(mypca.eigenvec,2:size(mypca.eigenvec.d,1));% part of eigenvectors associated with x
%gamma
%gamma0
predy.d=zeros(n,maxdim);
beta.d=zeros(p,maxdim);
for dim=1:maxdim
   gam0=gamma0.d(:,1:dim);
   bet=(gam0*gamma.d(:,1:dim)')/(1-norm(gam0)^2);
   cumulated_beta.d(:,dim)=normy*bet';
   %predy.d(:,dim)=normy*(all_predy.d(:,1:dim)*q')+averagey*ones(n,1);% linear combination of individual predictions
   %predy.d(:,dim)=x.d*cumulated_beta.d(:,dim) + averagey*ones(n,1);;
end   
predy.d=x.d*cumulated_beta.d+averagey*ones(n,maxdim);
predy.i=x.i;
predy.v=mypca.eigenvec.v(1:maxdim,:);
lr2type.predy=predy;
corr.d=zeros(1,maxdim);
for i=1:maxdim
   aux=corrcoef(y.d,predy.d(:,i));
   corr.d(1,i)=aux(1,2);
end;   
corr.v=predy.v;
corr.i='correlation coefficient';
lr2type.corrcoef=corr;
lr2type.beta.d=cumulated_beta.d/normx;
lr2type.beta.i=x.v;
lr2type.beta.v=predy.v;
lr2type.averagey=averagey;
lr2type.averagex.d=average.d;
lr2type.averagex.v=x.v;
lr2type.averagex.i='average x';
lr2type.ratioxy=ratioxy;