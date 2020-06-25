function res=contingency_khi2(table);
%contingency_khi2           - computes khi2 stats on a contingency table
%function res=contingency_kh2(table);
%table can be computed from "contingency_table"
%[n,p]=size(table.d);
s1=sum(table.d);
index=(s1==0);
if(sum(index)~=0)
    table=deletecol(table,index);
    disp('Warning : some columns were empty');
end
s2=sum(table.d,2);
index=(s2==0);
if(sum(index)~=0)
    table=deleterow(table,index);
    disp('Warning : some rows were empty');
end

[n,p]=size(table.d);
tot=sum(sum(table.d));
freq_col=sum(table.d);
freq_row=sum(table.d,2);

row_P.d=freq_row/tot;
col_P.d=freq_col/tot;
theo=row_P.d*col_P.d;
theo.d=theo*tot;
delta=table.d-theo.d;
khi2.d=sum(sum((delta.*delta)./theo.d));
khi2.i='khi2 value';
khi2.v='khi2 value';
dll.d=(n-1)*(p-1);
dll.i='degree of freedom';
dll.v='degree of freedom';
P.d=(1-chi2cdf(khi2.d,dll.d));
P.i='Probability';
P.v='Probability';
theo.i=table.i;
theo.v=table.v;

res.theo=theo;
res.khi2=khi2;
res.dll=dll;
res.P=P;


