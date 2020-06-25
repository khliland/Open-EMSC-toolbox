function[res]=pcr1(x,y,dim)
%pcr1		- Basic model of PCR (components introduced in the order of eigenvalues)
% function [pcrtype]=pcr1(x,y,dim)
% assess a basic pcr model on files following the saisir format
% returns pcrtype: pca, beta, predy, correlation coeff with dim elements, averagey  
% SEVERAL VARIABLES BE PREDICTED (no scan of the dimensions)
%disp('ici');
mypca=pca(x);
nind=size(y.d,1);
ny=size(y.d,2);
averagey=mean(y.d);
centredy=y.d-ones(nind,1)*averagey;
c=mypca.score.d(:,1:dim);
v=1./mypca.eigenval.d(:,1:dim);
v=diag(v);
beta1=v*c'*centredy;% this beta from PCA scores
beta.d=mypca.eigenvec.d(:,1:dim)*beta1;% this beta from original centred data
predy.d=c*beta1+ones(nind,1)*averagey;
predy.i=x.i;
predy.v=y.v;
beta.i=x.v;
beta.v=x.v;
res.pca=mypca;
res.beta=beta;
res.averagex=mypca.average;
res.averagey.d=averagey;
res.averagey.i='y averages';
res.averagey.v=y.v;
res.info=['predicting several y  with ' num2str(dim) ' dimensions'];
aux=corrcoef([y.d predy.d]);
for i=1:ny
   corr.d(1,i)=aux(i,i+ny);
end;   
corr.v=y.v;
corr.i='correlation coefficient';
res.corr=corr;
res.predy=predy;