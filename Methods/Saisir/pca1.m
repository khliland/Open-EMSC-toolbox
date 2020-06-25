function[pcatype]=pca1(saisir)
%pca1				- assesses principal component analysis on raw data (case nrows>ncolumns) 
% assess a rustic principal component analysis (on not normalised data)
% on saisir structure 
% returns saisir coord, saisir eigenvector, saisir eigenvalues
% number of rows > number of columns (usual case)
% saisir average
% currently function [pcatype]=pca(saisir)
%pcatype is a struct containing saisir structures score (coordinates)
%eigenvec eigenvectors (loadings)
%eigenval eigenvalues
%average average observations 
[n,p]=size(saisir.d);

average.d=mean(saisir.d);
centred=saisir.d-ones(n,1)*average.d;
% Warning functin eig does not sort the eigenvalues and eigenvectors!!
%size(centred*centred')
[v,d]=eig(centred'*centred);% diagonalisation matrix X'X centred
[eigenval.d, index]=sort(-abs(diag(d)'/n));% eigenvalues in increasing order!
r=p;%rank 
eigenval.d=-eigenval.d(1:r);
eigenval.i='eigenvalues';
% using dual properties
eigenvec.d=v;
% reordering eigenvector according to eigenvalues
eigenvec.d=eigenvec.d(:,index);
eigenvec.d=eigenvec.d(:,1:r);
% assessing the true scores
aux=sqrt(n);
aux=1;
%size(centred)
%size(eigenvec.d)
coord.d=(centred*eigenvec.d)/aux;
% identifiers
coord.i=saisir.i;
eigenvec.i=saisir.v;
% building identifier A1, A2, ... , Ap
for i=1:p
   chaine=['PC ',num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	eigenvec.v(i,:)=chaine(1:10);   
   
end
eigenval.v=eigenvec.v;
%coord.v=eigenvec.v;
coord.v=[eigenvec.v num2str(round(1000*eigenval.d'/sum(eigenval.d))/10) char(ones(r,1)*'%')];
average.v=saisir.v;
average.i='average';
pcatype.score=coord;
pcatype.eigenvec=eigenvec;
pcatype.eigenval=eigenval;
pcatype.average=average;
% if(nargin==1) pcatype.info=['PCA ' datestr(now,0)];
% else
%    pcatype.info=['PCA ' datestr(now,0) ' ' info];
% end;   