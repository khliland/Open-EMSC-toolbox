function table=contingency_table(g1,g2)
%contingency_table       - Computes a contingency table
%function table=contingency_table(g1,g2)
%g1 and g2 are the group files possibly computed from "create_group1". 
%g1.d and g2.d are vectors of integer values with the same number of elements.
%In these vectors, a same number indicates the belonging to the same group.

[n1,p1]=size(g1.d);
[n2,p2]=size(g1.d);
if(n1~=n2)
    error('Error in ''contingency_table'': g1 and g2 must have the same number of elements');
end

maxgroup1=max(g1.d);
maxgroup2=max(g2.d);
table.d=zeros(maxgroup1,maxgroup2);

for i=1:n2
    table.d(g1.d(i),g2.d(i))=table.d(g1.d(i),g2.d(i))+1;
end
table.i=num2str((1:maxgroup1)');
table.v=num2str((1:maxgroup2)');
table.i=addcode(table.i,'G');
table.v=addcode(table.v,'g');


if(isfield(g1,'g'))
    table.i=g1.g.i;
end

if(isfield(g2,'g'))
    table.v=g2.g.i;
end


