function std_type=split_std(s,startpos,endpos,option)
%split_std   			- computes the standard deviation according to the identifiers
%function std_type=split_std(X,startpos,endpos,(option))
%use the identifier for compututing standard-deviation 
%creates as many vector of standard deviation as different strings from startpos to endpos
%Returns std_type.std and std_type.g: effectif in each group .
%option: 0 : division by N-1; 1: division by N (default : 0)  
xoption=0;
if(nargin>3)
    xoption=option; 
end
[nrow ncol]=size(s.d);
g=create_group1(s,startpos,endpos);
maxgroup=max(g.d);

for i=1:maxgroup
    aux=s.d(g.d==i,:);
    %aux
    std_type.std.d(i,:)=std(aux,xoption);
end
std_type.std.v=s.v;
std_type.std.i=g.g.i;
std_type.group=g.g;
