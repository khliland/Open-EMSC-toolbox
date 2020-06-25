function str1 = decode_angers(str)
%decode_angers			- No use
[nrow ncol]=size(str);
for row=1:nrow
   test=deblank(str(row,:));
   if(~isempty((findstr('DMC',test))))
      res='DMC0000';
      suite=3;
   	else
   	res='DM-0000';
      suite=2;
   end;
longueur=size(test,2);   
num=test(suite+1:longueur-1)
for i=6:-1:6-size(num)-1
   (size(num,2)+6-i-1)-1
   %res(i)=num(size(num,2)+6-i-1)
end;

res(7)=test(longueur);
end

      