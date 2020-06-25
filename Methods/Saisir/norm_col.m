function [saisir] = norm_col(saisir1,mode)
%norm_col		- divides each column by the corresponding standard deviation
% function [saisir] = norm_col(saisir1,(mode))
% divide each column by the corresponding standard deviation
% mode (optional): 0 or 1 division by  n-1 or by n respectively
% default : 1

if(nargin<2) 
    mode=1;
end

saisir.v=saisir1.v;
saisir.i=saisir1.i;

aux=(1./std(saisir1.d,mode));

size(aux);
saisir.d=saisir1.d.*(ones(size(saisir1.d,1),1)*aux);