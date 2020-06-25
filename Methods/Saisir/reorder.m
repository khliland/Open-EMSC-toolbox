function [saisir1, saisir2]=reorder(s1,s2)
%reorder 			- reorders the data of files s1 and s2 according to their identifiers
%function [B1 B2]=reorder(A1,A2)
%This function makes it possible to realign the rows of A1 and A2, in order
%to have the identifiers corresponding.
%This is necessary for any predictive method (particularly regressions).
%The function discards the observations which are not present in A1 and A2.
%The matrix B1 corresponds to A1 and matrix B2 to A2
%Fails if A1 or A2 contains identical identifiers of rows.  
%A2 is leader (B1 is as close as possible from the order of A2)

nchar1=size(s1.i,2);
nchar2=size(s2.i,2);
model=s2.i;
[nrow ncol]=size(s1.d);
[nrow1 ncol1]=size(model);
nchar=max(nchar1,nchar2);
added_blanks1=char(ones(nrow,nchar)*' ');% added spaces
added_blanks2=char(ones(nrow1,nchar)*' ');% added spaces
s1.i=[s1.i added_blanks1];
s1.i=s1.i(:,1:nchar);
s2.i=[s2.i added_blanks2];
s2.i=s2.i(:,1:nchar);
model=s2.i;

detected=zeros(nrow1,1);
matching=zeros(nrow,1);
[detected,names]=check_name(s1.i);
 if(sum(detected)>0) error('Several identical names');end;
[detected,names]=check_name(s2.i);
 if(sum(detected)>0) error('Several identical names');end;

% find the sample matching the model
for row=1:nrow
   flag=0;
   for row1=1:nrow1
      if(strcmp(model(row1,:),s1.i(row,:))==1)
         detected(row1)=detected(row1)+1;
      	matching(row)=1;   
      	flag=1;   
      end;	
    end;
	if(flag==0)
		disp(['Not found from s1: ' s1.i(row,:)])
	end
 end;
 nrealised=sum(detected>0)
 %irrelevant=sum(detected>1)
 %if(irrelevant>0) error('Several identical names');end;
 nmatch=sum(matching==1);
 saisir1.d=zeros(nmatch,ncol);
 indice=0;
 for row1=1:nrow1
    if(detected(row1)>0)
       indice=indice+1;
       newmodel(indice,:)=model(row1,:);
       saisir2.d(indice,:)=s2.d(row1,:);
       saisir2.i(indice,:)=s2.i(row1,:);
    end 
 end     
 bid=s2.i;
 if(sum(detected==0)>0)
	disp('Not found from s2');
 	bid(detected==0,:)
 end;   
 %newmodel;
 saisir1.d=zeros(nrealised,ncol);
 indice=0;
 for row1=1:nmatch
    flag=0;
    for row=1:nrow
    	if(strcmp(newmodel(row1,:),s1.i(row,:))==1)
      	indice=indice+1;
       	saisir1.d(indice,:)=s1.d(row,:);
     		saisir1.i(indice,:)=s1.i(row,:);     
       end; 
   end      
end;	
saisir1.v=s1.v;
saisir2.v=s2.v;