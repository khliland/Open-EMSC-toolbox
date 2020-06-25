function [H, T]=dendro(saisir,topnodes)
%dendro						- dendrogram using euclidian metric and Ward linkage
%function [H,T]=dendro(saisir,(topnodes))
t=0;
if(nargin>1); t=topnodes;end 
y=pdist(saisir.d,'euclid');
z=linkage(y,'ward');
[H,T]=dendrogram(z,t,'orientation','left');
