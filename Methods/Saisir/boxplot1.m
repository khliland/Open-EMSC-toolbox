function boxplot1(x,ncol,debpos,endpos);
%boxplot1		- Creation of boxplot on a column of a saisir file
%function boxplot1(x,ncol,debpos,endpos);
%draw the boxplot graph of column ncol from x, taking the qualitative groups from
%character codes in rows from debpos to endpos
%Warning: version23/01/2002: groups must be of equal size and consecutive in the rows.
%general order of rows g1;g1;g1;g2;g2;g2; ...

gr=create_group1(x,debpos,endpos);
aux=gr.g.d(1);
[n1,p1]=size(gr.g.d);
for i=2:n1
   if(aux~=gr.g.d(i))
      error('Not equal number of observations in each group');
   end
end
col=x.d(:,ncol);
x1=reshape(col,aux,n1);
boxplot(x1);
set(gca,'XTickLabel',gr.g.i);
ylabel(x.v(ncol,:));
xlabel('');
title(['Boxplot of variable : ' x.v(ncol,:)]);