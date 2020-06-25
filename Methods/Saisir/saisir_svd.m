function[pcatype]=saisir_svd(saisir,info)
%saisir_svd				- Principal component analysis by svd decomposition 
%NOT VERIFIED !!!!
%function [pcatype]=pca(saisir,info)
%Assesses principal component analysis (on not normalised data)
%returns coord, eigenvector,eigenvalues
%average
%pcatype is a struct containing scores (coordinates)
%eigenvec   :eigenvectors (loadings)
%eigenval   :eigenvalues
%average    :average observation 

[n,p]=size(saisir.d);
if(n>p) 
   pcatype=pca1(saisir);
   return;
end;   
average.d=mean(saisir.d);
centred=saisir.d-ones(n,1)*average.d;
% Warning functin eig does not sort the eigenvalues and eigenvectors!!
%size(centred*centred')
%'eig'
[v,d]=eig(centred*centred');% diagonalisation matrix X'X centred
%'sort'
[eigenval.d, index]=sort(-abs(diag(d)'/n));% eigenvalues in increasing order!
%index
r=n-1;%rank
eigenval.d=-eigenval.d(1:r);
eigenval.i='eigenvalues';
% using dual properties
% the elements of eigenvector are the normalised scores of X' 
eigenvec.d=normc((v'*centred)');
%eigenvec.d=eigenvec.d(:,1:r);
%eigenvec.d=v;
% reordering eigenvector according to eigenvalues
eigenvec.d=eigenvec.d(:,index);
eigenvec.d=eigenvec.d(:,1:r);

% assessing the true scores
aux=sqrt(n);
%size(centred)
%size(eigenvec.d)
%size(centred)
%size(eigenvec.d)
coord.d=(centred*eigenvec.d)/aux;
% identifiers
coord.i=saisir.i;
eigenvec.i=saisir.v;
% building identifier A1, A2, ... , Ap
for i=1:r
   chaine=['A' num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	eigenvec.v(i,:)=chaine(1:10);
end
eigenval.v=eigenvec.v;
coord.v=[eigenvec.v num2str(round(1000*eigenval.d'/sum(eigenval.d))/10) char(ones(r,1)*'%')];
average.v=saisir.v;
average.i='average';
pcatype.score=coord;
pcatype.eigenvec=eigenvec;
pcatype.eigenval=eigenval;
pcatype.average=average;
if(nargin==1) pcatype.info=['PCA ' datestr(now,0)];
else
   pcatype.info=['PCA ' datestr(now,0) ' ' info];
end;
