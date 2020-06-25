function[spcrtype]=spcr(x,y,maxdim,maxrank,corr_cov)
%spcr 				- stepwise Principal component regression
% function [spcrtype]=spcr(x,y,maxdim, (maxrank)(corr_cov))
% Calculates a PCR model 
% returns spcrtype: pca, beta, selected_component, predy, 
% correlation coeff with 1 to maxdim elements, averagey  
% The components are introduced in the order of their regression coefficient or their covariance 
% with y
% maxdim: maximal number of components in the model
% maxrank: (optional) maximal rank of the components possibly introduced in the model (the components
% of higher rank are not considered). Default value: all components possibly introduced.  
%corr_cov : 1 introduction according to correlation coeff (corr_cov=1,default);
%or       : 0 introduction according to covariance	
mypca=pca(x);
nind=size(y.d,1);
if(nargin<4) 
   maxrank=size(mypca.score.d,2)-1;
   corr_cov=1;
end;
if(nargin<5);corr_cov=1;end;
if(maxrank>size(mypca.score.d,2)-1); maxrank=size(mypca.score.d,2)-1;end
averagey=mean(y.d);
centredy=y.d-averagey*ones(nind,1);
c=mypca.score.d(:,1:maxrank);
if(corr_cov>0)
   disp('Components introduced in the order of partial r2 with y');
   co=corrcoef([c y.d]);
else
   disp('Components introduced in the order of covariance with y');
   co=cov([c,y.d],1);
end
co1=co(1:maxrank,maxrank+1).*co(1:maxrank,maxrank+1);% squared coeff
[co2, index]=sort(-co1);
%-co2(1:maxdim,:)
index=index(1:maxdim);
v=1./mypca.eigenval.d(:,1:maxrank);
%size(v);
beta.d=(c'*centredy).*(v');
beta.d=beta.d(index);
%size(beta.d)
res=c(:,index)*diag(beta.d); % delta y predicted  with each individual beta
%size(res)
predy.d=zeros(nind,maxdim);
predy.d(:,1)=averagey*ones(nind,1)+res(:,1);% prediction with one component
for i=2:maxdim
   %size(predy.d)
   %size(res(:,i))
   predy.d(:,i)=predy.d(:,(i-1))+res(:,i); % summing the delta y;
end;
spcrtype.pca=mypca;
for i=1:maxdim
   chaine=['R' num2str(i) '        '];
 	beta.i(i,:)=chaine(1:6);
end
beta.v='beta';
predy.i=y.i;
predy.v=beta.i';
selected_component.d=index(1:maxdim,1);
selected_component.v='ranks of selected components';
selected_component.i=beta.i;
spcrtype.beta=beta;
spcrtype.selected_component=selected_component;
spcrtype.predy=predy;
spcr.info=['predicting' y.v];
corr.d=zeros(1,maxdim);
for i=1:maxdim
   aux=corrcoef(y.d,predy.d(:,i));
   corr.d(1,i)=aux(1,2);
end;   
corr.v=beta.i;
corr.i='r2';
corr.d=corr.d.*corr.d;

spcrtype.r2=corr;
spcrtype.averagey=averagey;% necessary to keep this value, in order to 'center' unknown data 
%=============
beta1.d=mypca.eigenvec.d(:,index)*diag(beta.d);
for i=2:maxdim
   beta1.d(:,i)=beta1.d(:,(i-1))+beta1.d(:,i); % summing the beta;
end;
beta1.i=mypca.eigenvec.i;
beta1.v=beta.i;
spcrtype.beta1=beta1;
spcrtype.obsy=y;
aux=y.d*ones(1,maxdim)-predy.d;
if((ones(1,maxdim)*nind-[1:maxdim]-1)~=0)
	denum=1./(ones(1,maxdim)*nind-[1:maxdim]-1);   
   spcrtype.rmsec.d=sqrt(denum.*sum(aux.*aux));
else
   spcrtype.rmsec.d=0;
end
spcrtype.rmsec.i='RMSEC';
spcrtype.rmsec.v=corr.v;
% verif
%predy1.d=(x.d-ones(nind,1)*mypca.average.d)*beta1.d+ones(nind,maxdim)*averagey;
%predy1.i=y.i;
%predy1.v=beta.i';
%spcrtype.predy1=predy1;
%sum(sum(predy.d-predy1.d));