function [grouptype]=bag2group(bag)
%bag2group   			- uses the identifiers in bag to create groups
%function [group_type]=bag2group(bag)
% Use the identifiers for creating groups.
% Build an array of cells. In each cell, the column of  bag.d (matrix of
% char) are processed in order to form a vector of group 
% use the string in each column of bag.d for creating groups.
% creates as many group as different strings in the column of bag.d

[nrow,nchar ncol]=size(bag.d);

for col=1:ncol
    disp(['processing : ' bag.v(col,:)]);
    model=char([]);
    s.i=bag.d(:,:,col);
    model(1,:)=s.i(1,:);
    %model=sortrows(model);
    nmodel=1;
    effectif=[];
    effectif(1)=0;
    for i=1:nrow
        trouve=0;
        for j=1:nmodel
        	%char(model(j,:))
            %s.i(i,:)
            if(strcmp(char(model(j,:)),s.i(i,:))==1)
             indice=j;
            trouve=1;
      	    effectif(indice)=effectif(indice)+1;   
        end         
   end
   if(trouve==0)
      nmodel=nmodel+1;
      indice=nmodel;
      model(nmodel,:)=s.i(i,:);
   	effectif(nmodel)=1;   
   end   
   saisir.d(i,1)=indice;
    end   
    model;
    saisir.i=bag.i;
    saisir.v=bag.v(col,:);
    saisir.g.i=char(model);
    saisir.g.d=effectif';
    saisir.g.v='effectif';
    grouptype{col}=saisir;
end 