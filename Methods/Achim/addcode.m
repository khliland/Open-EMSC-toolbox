function str1 = addcode(str,code,deb_end)
%addcode			- adds a code before any string of a character array
%function str1 = addcode(str,code,deb_end)
%add the string "code" BEFORE or AFTER any string of vector str
%function str1 = addcode(str,code)
% useful for recoding identifier 
%SAISIR FUNCTION
% if deb_end==0: addition before (default)
if(nargin<3)
    deb_end=0;
end
[nrow ncol]=size(str);
if(isempty(code))
    str1=str;
else
    aux=char(ones(nrow,1)*code);
    if(deb_end==0)
        str1=[aux str];
    else
        str1=[str aux];
    end
end      