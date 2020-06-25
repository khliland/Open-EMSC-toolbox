function[lr1type]=lr1(x,y,maxdim,ratioxy)
%lr1			- Latent root 1 model  
% function [lr1type]=lr1(x,y,maxdim,ratioxy)
% assess a basic lr1 model on files following the saisir format
% returns lr1type
% returns the individual predictors and the y predicted with 1 to maxdim latent variables  
% best choice obtained from a weighted sum of the predicted y according to Vigneau et al. 
%ratioxy(optional): positive number greater than 0 less than 1
% giving the relative importance of x and y. 1: x important; 0 x not important
% default : 0.5 (x and y have the same importance)
average.d=mean(x.d);
[n,p]=size(x.d);
if(nargin<4) ratioxy=0.5;end;
x.d=x.d-ones(n,1)*average.d;
averagey=mean(y.d);
y.d=y.d-averagey*ones(n,1);
normx=norm(x.d,'fro')/ratioxy;%
normy=norm(y.d)/(1-ratioxy);
x.d=x.d/normx;y.d=y.d/normy;
yx=appendcol(y,x);
mypca=pca(yx);
[gamma gamma0]=splitrow(mypca.eigenvec,2:size(mypca.eigenvec.d,1));% part of eigenvectors associated with x
%gamma
%gamma0
aux=-1./gamma0.d;
beta.d=gamma.d*diag(aux);
beta.d=beta.d(:,1:maxdim);
%all_predy.d=x.d*beta.d; %maxdim individual predictions
%size(all_predy.d);
qtot=(gamma0.d.*gamma0.d)./mypca.eigenval.d;
predy.d=zeros(n,maxdim);
cumulated_beta.d=zeros(p,maxdim);


for dim=1:maxdim
	q=qtot(1:dim); total=sum(q); q=q/total;
   cumulated_beta.d(:,dim)=normy*(beta.d(:,1:dim)*q');
   %predy.d(:,dim)=normy*(all_predy.d(:,1:dim)*q')+averagey*ones(n,1);% linear combination of individual predictions
   %predy.d(:,dim)=x.d*cumulated_beta.d(:,dim) + averagey*ones(n,1);;
end   
predy.d=x.d*cumulated_beta.d+averagey*ones(n,maxdim);
predy.i=x.i;
predy.v=mypca.eigenvec.v(1:maxdim,:);
lr1type.predy=predy;
corr.d=zeros(1,maxdim);
for i=1:maxdim
   aux=corrcoef(y.d,predy.d(:,i));
   corr.d(1,i)=aux(1,2);
end;   
corr.v=predy.v;
corr.i='correlation coefficient';
lr1type.corrcoef=corr;
lr1type.beta.d=cumulated_beta.d/normx;
lr1type.beta.i=x.v;
lr1type.beta.v=predy.v;
lr1type.averagey=averagey;
lr1type.averagex.d=average.d;
lr1type.averagex.v=x.v;
lr1type.averagex.i='average x';
lr1type.ratioxy=ratioxy;