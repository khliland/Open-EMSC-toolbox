function[selected]=random_select(nel, nselect,nrepeat)
%random_select     - random selection of samples
%	function[selected]=random_select(nel, nselect, (nrepeat))
% returns a vector containing 1 in random position
% among nel elements, nselect elements are set to 1
% nrepeat (optional) randomly selects nselect values, but organised by block of nrepeat groups 
%For example, if nrepeat =3 a possible result is [0 0 0 1 1 1 0 0 0 1 1 1 1 1 1 ...]
% This is useful for dividing a collectio in calib and verif set when the repetitions
% are consecutive
% normally nselect is an integer multiple of nrepeat
selected=zeros(1,nel);
if(nargin<3)
   found=0;
	while found<nselect
		number=uint32(random('Uniform',1,nel)+0.5);
   	%number
   	if(selected(1,number)==0)
			selected(1,number)=1;
      	found=found+1;
   	end;   
	end;
else
   nel1=floor(nel/nrepeat);
   selected1=zeros(1,nel1)
   found=0;
   nselect1=floor(nselect/nrepeat);
   while found<nselect1
		number=uint32(random('Uniform',1,nel1)+0.5);
   	%number
   	if(selected1(1,number)==0)
			selected1(1,number)=1;
      	found=found+1;
   	end;   
	end;
   for i=1:nel1
      if(selected1(1,i)==1)
         for j=1:nrepeat
         selected(1,(i-1)*nrepeat+j)=1;   
         end
      end
   end
end   
