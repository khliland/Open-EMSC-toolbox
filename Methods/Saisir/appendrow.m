function [saisir] = appendrow(saisir1,saisir2)
%appendrow		- Merges two files according to rows
% usage: [saisir]= appendrow(saisir1,saisir2) 
% saisir is a structure i,v,d 
% the number of columns in saisir1 and saisir2 must be equal
%SAISIR FUNCTION
if(isempty(saisir1))
    saisir=saisir2;
    return;
end
if(isempty(saisir2))
    saisir=saisir1;
    return;
end


if(size(saisir1.d,2)~=size(saisir2.d,2))
   help appendrow;
   error('number of columns are not equal');
end   

[n1,p1]=size(saisir1.i);
[n2,p2]=size(saisir2.i);
if(p1~=p2)
   code='                                     ';
   aux=char(ones(n1,1)*code);
	saisir1.i=[saisir1.i aux];
   aux=char(ones(n2,1)*code);
   saisir2.i=[saisir2.i aux];
   saisir.i=[saisir1.i(:,1:20);saisir2.i(:,1:20)];
else
   saisir.i=[saisir1.i;saisir2.i];
end

saisir.d=[saisir1.d;saisir2.d];
saisir.v=saisir1.v;
