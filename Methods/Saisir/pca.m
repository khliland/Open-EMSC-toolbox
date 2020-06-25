function[pcatype]=pca(saisir,var_score)
%pca				- principal component analysis on raw data 
%function [pcatype]=pca(saisir,var_score)
%Assesses principal component analysis (on not normalised data)
%returns coord, eigenvector,eigenvalues
%average
%pcatype is a struct containing scores (coordinates)
%eigenvec   :eigenvectors (loadings)
%eigenval   :eigenvalues
%average    :average observation 
%var_score  :(optional) 0: only scores of observations 1: gives also the scores of the variables
%            default : 0
%NOTA       :the weight of the observations are equal to 1/(number of rows)   
if (nargin<2)
    var_score=0;
end
[n,p]=size(saisir.d);
if(n>p) 
   pcatype=pca1(saisir);
   if(var_score==1)
%        eigenval.d=pcatype.eigenval.d;
%        eigenvec.d=pcatype.eigenvec.d;
       pcatype.var_score.d=diag(sqrt(abs(pcatype.eigenval.d)))*pcatype.eigenvec.d;
       pcatype.var_score.i=pcatype.eigenvec.i;
       pcatype.var_score.v=pcatype.eigenvec.v;
       pcatype.info=['PCA ' datestr(now,0)];
   end
   return;
end;   
average.d=mean(saisir.d);
centred=saisir.d-ones(n,1)*average.d;

[v,d]=eig(centred*centred');% diagonalisation matrix X'X centred
%'sort'
[eigenval.d, index]=sort(-abs(diag(d)'/n));% eigenvalues in increasing order!
%index
r=n-1;%rank
eigenval.d=-eigenval.d(1:r);
eigenval.i='eigenvalues';
eigenvec.d=normc((v'*centred)');
eigenvec.d=eigenvec.d(:,index);
eigenvec.d=eigenvec.d(:,1:r);
coord.d=centred*eigenvec.d;

% identifiers
coord.i=saisir.i;
eigenvec.i=saisir.v;
% building identifier A1, A2, ... , Ap
for i=1:r
   chaine=['PC ',num2str(i) '             '];
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
if(var_score==1)
%     eigenvec.d=pcatype.eigenvec.d;
%     eigenval.d=pcatype.eigenval.d;
    size(pcatype.eigenval.d)
    size(pcatype.eigenvec.d)
   size(diag(sqrt(abs(pcatype.eigenval.d))))
    pcatype.var_score.d=pcatype.eigenvec.d*diag(sqrt(abs(pcatype.eigenval.d)));
    pcatype.var_score.i=pcatype.eigenvec.i;
    pcatype.var_score.v=pcatype.eigenvec.v;
end
pcatype.info=['PCA ' datestr(now,0)];
