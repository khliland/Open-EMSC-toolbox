function saisir1=group_mean(s,startpos,endpos)
%group_mean 		- gives the means of group of rows		 
%function saisir1=group_mean(s,startpos,endpos)
%GROUP_MEAN  give the means of group of rows
% use the identifier for creating groups.
% creates as many group means as different strings from startpos to endpos

[nrow ncol]=size(s.d);
model(1,:)=s.i(1,startpos:endpos);
nmodel=1
for i=1:nrow
   trouve=0;
   for j=1:nmodel
        	if(strcmp(model(j,:),s.i(i,startpos:endpos))==1)
         indice=j;
         trouve=1;
       end         
   end
   if(trouve==0)
      nmodel=nmodel+1;
      indice=nmodel;
      model(nmodel,:)=s.i(i,startpos:endpos);
   end   
   saisir.d(i,1)=indice;
end   
model
saisir1.i=model;
saisir1.v=s.v;
saisir1.d=zeros(nmodel,ncol);
for i=1:nmodel
saisir1.d(i,:)=mean(s.d(saisir.d(:,1)==i,:));   
end    