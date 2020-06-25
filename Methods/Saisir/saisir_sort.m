function [s1 s2]=saisir_sort(s,col)
%saisir_sort       - sorts the rows of s according to the values in a column
%function [s1 s2]=saisir_sort(s,col)
%s1 : data sorted according to the column col
%s2 : a column rank is added (fro using graph functions)

[bid,index]=sort(s.d(:,col));
s1=selectrow(s,index);
if(nargout==2)
[n,p]=size(s1.d);
[n1,p1]=size(s.v);
s2=s1;
s2.d=[(1:n)' s1.d];
aux='rank                                    ';
aux=aux(1:p1);
s2.v=[aux;s2.v];
end;