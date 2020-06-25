function index = seekstring(x,str1)
%seekstring		- returns a vector giving the indices of string in matrix of char x in which 'str' is present 
%function index = seekstring(x,str1)
j=0;
str1=deblank(str1);
[n,p]=size(str1);
%str
index=[];
for k=1:n
   str=str1(k,:);
	for i=1:size(x,1);
   	if(~isempty((findstr(str,x(i,:)))))
      	j=j+1;
      	index(j)=i;
   	end;
	end;
end