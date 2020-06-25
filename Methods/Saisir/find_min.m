function [row,col,value]=find_min(matrix)
%find_min           - gives the indices of the min value of a MATLAB Matrix
%function [row,col,value]=find_min(matrix)
[i,j]=min(matrix);
[k,l]=min(i);
value=k;
col=l;
row=j(l);