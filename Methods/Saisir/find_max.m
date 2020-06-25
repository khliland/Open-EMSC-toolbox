function [row,col,value]=find_max(matrix)
%find_max           - gives the indices of the max value of a MATLAB Matrix
%function [row,col,value]=find_max(matrix)
[i,j]=max(matrix);
[k,l]=max(i);
value=k;
col=l;
row=j(l);