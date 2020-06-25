function [indicator, groupings]=build_indicator(x);
%build_indicator        -  build a disjoint table 
%function [indicator, groupings]=build_indicator(x);
%each column of x must contain integer values
%build the complete table of indicators
%Useful for computing multiple correspondance analysis 

[n,p]=size(x.d);

dummy=x;
indicator=[];
for i=1:p
    dummy.i=num2str(x.d(:,i),i);
    [n,k]=size(dummy.i);
    g=create_group1(dummy,1,k);
    this_grouping=g.g;
    this_grouping.variable_name=x.v(i,:);
    groupings(i)=this_grouping;
    ngroup=size(g.g.d,1);
    ind.d=zeros(n,ngroup);
    for j=1:n
        ind.d(j,g.d(j))=1;% indicators
    end    
    %ngroup
    ind.i=x.i;
    aux=char(ones(ngroup,1)*x.v(i,:));
    ind.v=[g.g.i aux ];
    indicator=appendcol(indicator,ind);
end