function [saisir] = appendcol1(saisir1,varargin)
%appendcol1 		- merges an arbitrary number of files according to columns 
% usage: [saisir]= appendcol(saisir1,saisir2, ...) 
% saisir is a structure i,v,d 
% the number of rows in files must be identical
%SAISIR FUNCTION
if(isempty(saisir1));
    saisir=saisir1;
    return;
end

[a,ntable]=size(varargin);
saisir1=saisir_transpose(saisir1);

for i=1:ntable
   varargin{i}=saisir_transpose(varargin{i});
end
bid=appendrow1(saisir1,varargin{1:ntable});
saisir=saisir_transpose(bid);

