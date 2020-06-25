function [saisir] = bag_appendrow1(saisir1,varargin)
%bag_appendrow1		 - Merges an arbitrary number of bags according to rows
% usage: [bag]= appendrow(bag1, bag2 ....) 
% bag is a structure i,v,d 
% the number of columns in saisir files must be equal
% the second and third dimensions of bag.d must be equals

[n,nchar,p]=size(saisir1.d);
[a,ntable]=size(varargin);
saisir=saisir1;
bl='                                    ';
blancs=char(ones(n,1)*bl);
aux=[saisir.i blancs];
saisir.i=aux(:,1:30);% ajusted to 30 with blanks
for table=1:ntable
    if(size(saisir1.d,3)~=size(varargin{table}.d,3))
	   help appendrow;
   	error('number of columns are not equal');
   end	   
    if(size(saisir1.d,2)~=size(varargin{table}.d,2))
	   help appendrow;
   	error('number of char in the second dimension are not equal');
   end	   

   saisir.d=[saisir.d;varargin{table}.d];
   aux=varargin{table}.i;
   [a,b]=size(aux);
   blancs=char(ones(a,1)*bl);
   aux=[aux blancs];
   saisir.i=[saisir.i;aux(:,1:30)];
end;
saisir.v=saisir1.v;