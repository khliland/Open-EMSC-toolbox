function average_type=split_average(s,startpos,endpos)
%split_average 			- averages observations according to the identifiers
%function average_type=split_average(X,startpos,endpos)
%use the identifier for averaging
%creates as many average as different strings from startpos to endpos
%Returns average_type.average and averagetype.effectif: number of obs. in each group.
%Take into account of NAN values 
%disp('''NEW ''version'); 
[nrow ncol]=size(s.d);
g=create_group1(s,startpos,endpos);
maxgroup=max(g.d);
%maxgroup
for i=1:maxgroup
    size(s.d)
    size(g.d)
    aux=s.d(g.d==i,:);
    %aux
    average_type.average.d(i,:)=mean(aux,1);
end
average_type.average.v=s.v;
average_type.average.i=g.g.i;
average_type.group=g.g;
