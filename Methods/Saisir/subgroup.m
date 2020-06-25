function saisir=subgroup(s,code,startpos,endpos)
%subgroup		 			- extracts a subgroup corresponding to a given code
% use the identifier for creating the subgroups.
% function saisir=subgroup(saisir,code,startpos,endpos)
[nrow ncol]=size(s.d);
selected=zeros(nrow,1);
for i=1:nrow
   if(strcmp(code,s.i(i,startpos:endpos))==1) selected(i,1)=1;end;
end;
%selected
nrow1=sum(selected)
saisir.d=zeros(nrow1,ncol);
indice=0;
for i =1:nrow
   if(selected(i,1)==1)
      indice=indice+1;
      saisir.d(indice,:)=s.d(i,:);
 		saisir.i(indice,:)=s.i(i,:);     
   end
end
saisir.v=s.v;