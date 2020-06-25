function[pcatype]=pca2(saisir,info)
%pca2 				- computes principal component analysis on raw data (case nrows>ncolumns) 
% assess a rustic principal component analysis (on not normalised data)
% on saisir structure 
% returns saisir coord, saisir eigenvector, saisir eigenvalues
% number of rows > number of columns (usual case)
% saisir average
% currently function [pcatype]=pca(saisir,info)
%pcatype is a struct containing saisir structures score (coordinates)
%eigenvec eigenvectors (loadings)
%eigenval eigenvalues
%average average observations 
'start'
[n,p]=size(saisir.d);

average.d=mean(saisir.d);
centred=saisir.d-ones(n,1)*average.d;
% Warning functin eig does not sort the eigenvalues and eigenvectors!!
%size(centred*centred')
%'eig'
   [S, eigenval.d, eigenvec.d]=svd(saisir.d);
%[v,d]=eig(centred'*centred);% diagonalisation matrix X'X centred
%'sort'
%eigenval.d, index]=sort(-abs(diag(d)'/n));% eigenvalues in increasing order!
%index
%eigenval.d=-eigenval.d(1:p-1);
eigenval.i(1,:)='eigenvalues';
% using dual properties
%eigenvec.d=v;
% reordering eigenvector according to eigenvalues
%eigenvec.d=eigenvec.d(:,index);
%eigenvec.d=eigenvec.d(:,1:p-1);
% assessing the true scores
aux=sqrt(n);
%size(centred)
%size(eigenvec.d)
coord.d=S*sqrt(eigenval.d)/aux;
% identifiers
coord.i=saisir.i;
eigenvec.i=saisir.v;
% building identifier A1, A2, ... , Ap
for i=1:p-1
   chaine=['A' num2str(i) '        '];
   eigenvec.v(i,:)=chaine(1:6);
end
eigenval.v=eigenvec.v;
eigenval.d=diag(eigenval.d);
coord.v=eigenvec.v;
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