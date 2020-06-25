function str1 = addspace(str,number,option)
%addspace			- adds space at the beginning (option=0) or at
%                     the end (option=1), number specifies
% the final number of characters
%function str1 = addspace(str,number)

if (nargin==2)
    Option=0;   % default is add space at beginning
elseif (nargin==3)
    Option=option;
end

[nrow ncol]=size(str);
for row=1:nrow
   test=deblank(str(row,:));
   res=blanks(ncol);
   si=size(test,2);
   if(si~=number)
       if (Option==0)
            nzero=number-si;
       else
           nzero=number;
       end
%      res(1)=test(1);
      for j=1:nzero
         res(j)=' ';
      end;
      if (Option==0)
          for j=1:si;
             res(nzero+j)=test(j);
          end;
      else
          for j=1:si;
             res(j)=test(j);
          end;
      end
   else
      res=str(row,:);
   end;
   str1(row,:)=res;
end

      