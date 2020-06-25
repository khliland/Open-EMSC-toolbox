function[predy]=applypcr(pcrtype, x)
%applypcr 		- applies basic PCR on data  
% function [predy]=applypcr(pcrtype,x)
% apply a basic pcr (in pcrtype) on saisir data x
% creates as many y predicted as allowed by the dimensions in pcrtype

mypca=pcrtype.pca;
maxdim=size(pcrtype.beta.d,1);
nind=size(x.d,1);
averagey=pcrtype.averagey;
aux=applypca(mypca,x);
c=aux.d(:,1:maxdim);
res=c*diag(pcrtype.beta.d); % delta y predicted  with each individual beta
predy.d=zeros(nind,maxdim);
predy.d(:,1)=averagey*ones(nind,1)+res(:,1);% prediction with one component
for i=2:maxdim
   %size(predy.d)
   %size(res(:,i))
   predy.d(:,i)=predy.d(:,(i-1))+res(:,i); % summing the delta y;
end;
predy.i=x.i;
predy.v=pcrtype.beta.i;
