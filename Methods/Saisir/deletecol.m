function [saisir] = deletecol(saisir1,index)
%deletecol     - deletes columns of saisir files 
% usage: [X]= deletecol(X1,index) 
%The deleted columns are indicated by the vector index (numbers of booleans)

saisir1.d(:,index)=[];
saisir1.v(index,:)=[];

saisir.d=saisir1.d;
saisir.i=saisir1.i;
saisir.v=saisir1.v;