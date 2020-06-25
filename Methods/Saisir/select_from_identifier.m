function [saisir1] = select_from_identifier(saisir,startpos,str,Option)
%select_from_identifier 		- Uses identifier of rows for selecting samples
%function [saisir1] = select_from_identifier(saisir,startpos,str,Option)
%Creates the data collection "saisir1" which is the subset of "saisir"
%the identifiers of which contain the string str, in starting position startpos 
% Option = 0  % selects from samples
% Option = 1  % selects from variables

 if (nargin==3) 
        option=0;
 else
        option=Option;
 end    

if (option==0)
    [n,p]=size(saisir.i);
    aux=saisir.i(:,startpos:p);
    index=strmatch(str,aux);
    %index
    saisir1=selectrow(saisir,index);
elseif (option==1)
    [n,p]=size(saisir.v);
    aux=saisir.v(:,startpos:p);
    index=strmatch(str,aux);
    %index
    saisir1=selectcol(saisir,index);
else
    
end