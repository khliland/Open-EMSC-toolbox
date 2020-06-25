function myname=names(string,number)
%names 		- repeate a 'string' number times. No direct use 
%function myname=names(string,number)
% creates a matrix of a 'string' repeated 'number' times
myname=char(ones(number,1)*string);