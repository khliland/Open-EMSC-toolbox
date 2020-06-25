function [saisir] = selectcol(saisir1,index)
%selectcol 		- creates a new data matrix with the selected columns
% usage: [saisir]= selectcol(saisir1,index) 
% saisir is a structure i,v,d 
% the resulting file correspond to the selected columns
% index is a vector of indices (integer) or of booleans


saisir.i=saisir1.i;
saisir.v=saisir1.v(index,:);
saisir.d=saisir1.d(:,index);