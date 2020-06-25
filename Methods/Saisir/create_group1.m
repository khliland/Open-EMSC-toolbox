function [saisir, effectif]=create_group1(s,startpos,endpos)
%create_group1 			- uses the identifiers to create groups
% use the identifier for creating groups.
% creates as many group means as different strings from startpos to endpos
% function saisir=create_group1(s,startpos,endpos)
% s: saisir file, startpos and enpos : position of discriminating characters 
%
[nrow ncol]=size(s.i);
if(nargin==3)
    range=startpos:endpos;
else %%(nargin =2)
    range=startpos;
end
model(1,:)=s.i(1,range);
nmodel=1;
effectif(1)=0;
saisir.d=zeros(nrow,1);
for i=1:nrow
   if(mod(i,10000)==0)
       disp(i);
   end
    trouve=0;
   for j=1:nmodel
        	if(strcmp(model(j,:),s.i(i,range))==1)
         indice=j;
         trouve=1;
      	effectif(indice)=effectif(indice)+1;   
      end         
   end
   if(trouve==0)
      nmodel=nmodel+1;
      indice=nmodel;
      model(nmodel,:)=s.i(i,range);
   	effectif(nmodel)=1;   
   end   
   saisir.d(i,1)=indice;
end   
%model
saisir.g.i=model;
[model index]=sortrows(model);
%model
saisir.i=s.i;
saisir.v='group';
saisir.g.d=effectif';
saisir.g.v='effectif';
saisir.g=selectrow(saisir.g,index);
k=0;
for i=1:size(saisir.g.d,1)
    index1(index(i))=i;
end
saisir.d=index1(saisir.d)';
