function z=dendro1(saisir,topnodes)
%dendro1						- dendrogram using euclidian metric and Ward linkage
%function z=dendro1(saisir,topnodes)
%Attempts to display the identifiers on the dendrogram.
%Works only with a few number of identifiers 
t=0;
if(nargin>1); t=topnodes;end 
y=pdist(saisir.d,'euclid');
z=linkage(y,'ward');
dendrogram1(z,t,saisir.i);
