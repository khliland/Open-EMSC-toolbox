function [saisir] = appendrow1(saisir1,varargin)
%appendrow1		 - Merge an arbitrary number of files according to rows
% usage: [saisir]= appendrow(saisir2, .....) 
% saisir is a structure i,v,d 
% the number of columns in saisir files must be equal
%SAISIR FUNCTION


%if(size(saisir1.d,2)~=size(saisir2.d,2))
%   help appendrow;
%   error('number of columns are not equal');
%end   
%saisir.d=[saisir1.d;saisir2.d];
%saisir.i=[saisir1.i;saisir2.i];
%saisir.v=saisir1.v;
[n,p]=size(saisir1.d);
[a,ntable]=size(varargin);
saisir=saisir1;
bl='                                    ';
blancs=char(ones(n,1)*bl);
aux=[saisir.i blancs];
saisir.i=aux(:,1:30);% ajusted to 30 with blanks
for table=1:ntable
	if(size(saisir1.d,2)~=size(varargin{table}.d,2))
	   help appendrow;
   	error('number of columns are not equal');
   end	   
   saisir.d=[saisir.d;varargin{table}.d];
   aux=varargin{table}.i;
   [a,b]=size(aux);
   blancs=char(ones(a,1)*bl);
   aux=[aux blancs];
   saisir.i=[saisir.i;aux(:,1:30)];
end;
saisir.v=saisir1.v;