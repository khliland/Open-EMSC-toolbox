function [saisir1, saisir2] = splitrow(saisir,index)
%splitrow		- splits a data matrix into 2 resulting matrices  		
% usage: [X1, X2]= splitrow(X,index) 
% Divides X into two matrices X1 and X2
% the first one correspond to kept rows (according to index)
% the second one is the complement 
% index is either indices of the rows (integers) or boolean.
[n,p]=size(saisir.d);
if((sum(index==0)+sum(index==1)==n))
    index=index==1;
end
saisir1=selectrow(saisir,index);
saisir2=deleterow(saisir,index);

