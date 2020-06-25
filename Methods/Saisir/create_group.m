function saisir=create_group(saisir1,code_list,startpos,endpos)
%create_group 		- creates a vector of number indicating groups from identifiers 
%saisir=create_group(saisir,code_liste,startpos,endpos)
% use the identifier for creating groups.
% the codes of the groups are in code_list , and the positions where to find the letter
% are in startpos and endpos
% see also create_group1
[nrow1 ncol1]=size(code_list);
[nrow2 ncol2]=size(saisir1.d);
for i=1:nrow2
   found=0;
   for j=1:nrow1
      index=findstr(saisir1.i(i,startpos:endpos),code_list(j,:));
      %saisir1.i(i,startpos:endpos)
      %code_list(j,:)      
      %index
      if(~isempty(index))
	      if(index==startpos)
   	      found=1;
      	   group=j;
      	end;
   	end      
   end
      if(found==0)
         error('Impossible to attribute a group in create_group');
      end             
   saisir.d(i,1)=group;   
end
saisir.v='group';
saisir.i=saisir1.i;
      
   