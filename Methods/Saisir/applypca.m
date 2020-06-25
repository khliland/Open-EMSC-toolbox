function[coordsup]=applypca(pcatype,saisir)
%applypca     - computes the scores of supplementary observations
%function [supscores]=applypca(pcatype, X)
%assess the scores of supplementary observations
%pcatype is the structure resulting of the application of pca on principal observations 
%The number of columns of X must be compatible with pcatype.  

[n,p]=size(saisir.d);
if(p~=size(pcatype.average.d))
   help pcr;
   error('irrelevant dimensions in input data');
end   
[n1,p1]=size(pcatype.score.d);
aux=sqrt(n1);
aux=1.0;
centred=saisir.d-ones(n,1)*pcatype.average.d;
coordsup.d=(centred*pcatype.eigenvec.d)/aux;
% identifiers
coordsup.i=saisir.i;
coordsup.v=pcatype.eigenvec.v;
