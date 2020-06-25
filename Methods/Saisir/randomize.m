function [saisir]=randomize(s)
%randomize   		- Builds a file of randomly attributed vector in s
%function X1=randomize(X)
%the row vector in X are randomly attributed to each obs. 
%X may be the result of function 'create_group1'

[n,p]=size(s.d);
aux=rand(n,1);
[x,y]=sort(aux);
saisir.d=s.d(y,:);
saisir.i=s.i;
saisir.v=s.v;
