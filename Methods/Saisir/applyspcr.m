function[predy]=applyspcr(spcrtype, x)
%applyspcr		- Applies a stepwise PCR
% function [predy]=applyspcr(spcrtype,x)
% apply a pcr with selection (in spcrtype) on saisir data x
% creates as many y predicted as allowed by the dimensions in pcrtype

mypca=spcrtype.pca;
maxdim=size(spcrtype.beta.d,1);
nind=size(x.d,1);
averagey=spcrtype.averagey;
aux=applypca(mypca,x);
c=aux.d(:,spcrtype.selected_component.d);% reorganising coord. fact. according to the selection 
%size(c)
%size(spcrtype.beta.d)
res=c*diag(spcrtype.beta.d); % delta y predicted  with each individual beta
predy.d=zeros(nind,maxdim);
predy.d(:,1)=averagey*ones(nind,1)+res(:,1);% prediction with one component
for i=2:maxdim
   %size(predy.d)
   %size(res(:,i))
   predy.d(:,i)=predy.d(:,(i-1))+res(:,i); % summing the delta y;
end;
predy.i=x.i;
predy.v=spcrtype.beta.i;
