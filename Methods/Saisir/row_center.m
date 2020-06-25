function [saisir] = row_center(saisir1)
%row_center				- subtracts the average of a row to each column 
% function [X] = center(X1)
saisir.v=saisir1.v;
saisir.i=saisir1.i;
aux=mean(saisir1.d,2);
%size(ones(size(saisir1.d,1),1)*aux)
saisir.d=saisir1.d-aux*ones(1,size(saisir1.d,2));