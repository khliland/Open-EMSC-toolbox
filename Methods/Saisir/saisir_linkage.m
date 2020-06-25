function z=saisir_linkage(dis)
%saisir_linkage			- assesses a simple linkage vector from a matrix of distance
%function z=saisir_linkage(dis)
%from a complete square matrix of distance
%extracts the "unfolded" triangular matrix in order to enter the matlab program "linkage"
%with the option "ward"
%Returns the z vector as required by "dendrogram" function
x=dis.d;
pdist=[];
[n,p]=size(x);
for i=1:n-1
   aux=x(i,:);
   pdist=[pdist aux(i+1:n)];
end
z=linkage(pdist,'ward');
