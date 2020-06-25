function[pcrtype]=pcr(x,y,maxdim)
%pcr		- PCR (components introduced in the order of eigenvalues)
% function [pcrtype]=pcr(x,y,maxdim)
% assesses a basic pcr model on files following the saisir format
% returns pcrtype: pca, beta, predy, correlation coeff with 1 to maxdim elements, averagey  
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
mypca=pca(x);
nind=size(y.d,1);
averagey=mean(y.d);
centredy=y.d-averagey*ones(nind,1);
c=mypca.score.d(:,1:maxdim);
v=1./mypca.eigenval.d(:,1:maxdim);
size(v);
beta.d=(c'*centredy).*(v');
res=c*diag(beta.d); % delta y predicted  with each individual beta
%size(res)
predy.d=zeros(nind,maxdim);
predy.d(:,1)=averagey*ones(nind,1)+res(:,1);% prediction with one component
for i=2:maxdim
   %size(predy.d)
   %size(res(:,i))
   predy.d(:,i)=predy.d(:,(i-1))+res(:,i); % summing the delta y;
end;

pcrtype.pca=mypca;
for i=1:maxdim
   chaine=['A' num2str(i) '        '];
 	beta.i(i,:)=chaine(1:6);
end
beta.v='beta';
predy.i=y.i;
predy.v=beta.i;
pcrtype.beta=beta;
pcrtype.predy=predy;
pcr.info=['predicting' y.v];
corr.d=zeros(1,maxdim);
for i=1:maxdim
   aux=corrcoef(y.d,predy.d(:,i));
   corr.d(1,i)=aux(1,2);
end;   
corr.v=beta.i;
corr.i='correlation coefficient';
pcrtype.corrcoef=corr;
pcrtype.averagey=averagey;% necessary to keep this value, in order to 'center' unknown data 
beta1.d=mypca.eigenvec.d(:,1:maxdim)*diag(beta.d);
for i=2:maxdim
   beta1.d(:,i)=beta1.d(:,(i-1))+beta1.d(:,i); % summing the beta;
end;
beta1.i=mypca.eigenvec.i;
beta1.v=beta.i;
pcrtype.beta1=beta1;
pcrtype.obsy=y;
aux=y.d*ones(1,maxdim)-predy.d;

if((ones(1,maxdim)*nind-[1:maxdim]-1)~=0)
	denum=1./(ones(1,maxdim)*nind-[1:maxdim]-1);   
   pcrtype.rmsec.d=sqrt(denum.*sum(aux.*aux));
else
pcrtype.rmsec.d=0;   
end
pcrtype.rmsec.i='RMSEC';
pcrtype.rmsec.v=corr.v;
% verif
%predy1.d=(x.d-ones(nind,1)*mypca.average.d)*beta1.d+ones(nind,maxdim)*averagey;
%predy1.i=y.i;
%predy1.v=beta.i'
%pcrtype.predy1=predy1;
%sum(sum(predy.d-predy1.d))