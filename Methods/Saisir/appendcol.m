function [saisir] = appendcol(saisir1,saisir2)
%appendcol 		- merges two files according to columns 
% usage: [saisir]= appendcol(saisir1,saisir2) 
% saisir is a structure i,v,d 
% the number of rows in saisir1 and saisir2 must be equal
%SAISIR FUNCTION
if(isempty(saisir1));
    saisir=saisir2;
    return;
end

if(size(saisir1.d,1)~=size(saisir2.d,1))
   help appendcol;
   error('number of rows are not equal');
   
end   
saisir.d=[saisir1.d saisir2.d];
[n1,p1]=size(saisir1.v);
[n2,p2]=size(saisir2.v);
if(p1~=p2)
   code='                                     ';
   aux=char(ones(n1,1)*code);
	saisir1.v=[saisir1.v aux];
   aux=char(ones(n2,1)*code);
   saisir2.v=[saisir2.v aux];
   saisir.v=[saisir1.v(:,1:10);saisir2.v(:,1:10)];
else
   saisir.v=[saisir1.v;saisir2.v];
end

saisir.i=saisir1.i;

