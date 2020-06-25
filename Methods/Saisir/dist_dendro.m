function [H, T]=dist_dendro(distance,topnodes)
%dist_dendro						- dendrogram on distance matrix and Ward linkage
%function [H,T]=dist_dendro(distance,(topnodes))
t=0;
if(nargin>1); t=topnodes;end 
%y=pdist(saisir.d,'euclid');
x=distance.d;
[n,p]=size(x);
if(n~=p) 
    error('Not a distance matrix');
end
y=[];
for i=1:p-1
   aux=x(i,:);
   y=[y aux(i+1:p)];
end

z=linkage(y,'ward');
[H,T]=dendrogram(z,t);
