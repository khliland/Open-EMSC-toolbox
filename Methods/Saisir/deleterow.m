function [saisir] = deleterow(saisir1,index)
%deleterow           - deletes rows 
%usage: [X]= deleterow(X1,index) 
%The rows to be deleted are indicated by the vector index (numbers of booleans)


saisir1.d(index,:)=[];
saisir1.i(index,:)=[];
saisir.d=saisir1.d;
saisir.i=saisir1.i;
saisir.v=saisir1.v;
