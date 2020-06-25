function [saisir1] = delete_from_identifier(saisir,startpos,str)
%select_from_identifier 		- Uses identifier of rows for deleting samples
%function [saisir1] = delete_from_identifier(saisir,startpos,str)
%Creates the data collection "saisir1" which is the subset of "saisir"
%the identifiers of which do not contain the string str, in starting position startpos 
[n,p]=size(saisir.i);
aux=saisir.i(:,startpos:p);
index=strmatch(str,aux);
%index
saisir1=deleterow(saisir,index);