function [saisir] = subtract_variable(saisir1,ncol)
%subtract_variable			- subtract a given variable to all the others
% function [saisir] = subtract_variable(saisir1,ncol)
% subtract the variable of indice ncol to each other variables of the observations
saisir.v=saisir1.v;
saisir.i=saisir1.i;
aux=saisir1.d(:,ncol);
saisir.d=saisir1.d-aux*ones(1,size(saisir1.d,2));