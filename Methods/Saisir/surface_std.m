function [saisir] = surface_std(saisir1)
%surface_std 			- divide each row by the sum of the corresponding columns
%function [X1] = surface_std(X)
%If the sum is equal to 0, the elements of the corresponding row are set to 0. 

saisir.v=saisir1.v;
saisir.i=saisir1.i;

aux=(1./sum(saisir1.d'))';
% avoiding NaN values
aux(isinf(aux))=0;
%size(aux)
%size(ones(1,size(saisir1.d,2)))
%size(aux*ones(1,size(saisir1.d,2)))
%size(saisir1.d)
saisir.d=saisir1.d.*(aux*ones(1,size(saisir1.d,2)));