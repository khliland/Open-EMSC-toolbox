function [saisir xmean] = center(saisir1)
%center				- subtracts the average row to each row
% function [X xmean] = center(X1)
saisir.v=saisir1.v;
saisir.i=saisir1.i;
aux=mean(saisir1.d);
%size(ones(size(saisir1.d,1),1)*aux)
saisir.d=saisir1.d-ones(size(saisir1.d,1),1)*aux;
xmean.d=aux;
xmean.v=saisir1.v;
xmean.i='average';