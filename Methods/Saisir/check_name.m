function [detected,names]=check_name(s)
%check_name		- Controls if some strings are strictly identical in a string array
%function [detected,names]=check_name(string)
%find the string witch are strictly identical in s 
s=deblank(s);
[nrow,p]=size(s);
% find the sample matching the model
nirrelevant=0;
detected=zeros(nrow,1);
for row=1:nrow-1
   model=s(row,:);
   for row1=row+1:nrow
      if(strcmp(model,s(row1,:))==1)
          disp([model '  ' s(row1,:)])
          disp([row row1]);
          detected(row,1)=1;
         detected(row1,1)=1;
      end;	
    end;
 end;
 sum(detected);
 names=s(detected==1,:);