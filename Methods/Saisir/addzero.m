function str1 = addzero(str,number)
%addzero			- adds zero in the field of character string (very specific)					
%function str1 = addzero(str,number)
% consider the vector of string str1
% examine the non-blank part
% if the size of non-blank part is different of number
% add sufficient number of 0 in second place.
% example: str1=addzero('G12',5)
% str1='G0012'
% useful for trial with Angers (apples) 6/7/2000
%SAISIR FUNCTION

[nrow ncol]=size(str);
for row=1:nrow
   test=deblank(str(row,:));
   res=blanks(ncol);
   si=size(test,2);
   if(si~=number)
      nzero=number-si;
      res(1)=test(1);
      for j=1:nzero
         res(j+1)='0';
      end;
      for j=1:si-1;
         res(nzero+1+j)=test(j+1);
      end;
   else
      res=str(row,:);
   end;
   str1(row,:)=res;
end

      