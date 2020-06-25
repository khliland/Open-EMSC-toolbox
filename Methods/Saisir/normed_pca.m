function[pcatype]=normed_pca(saisir)
%normed_pca			- PCA with normalisation of data
%function[pcatype]=normed_pca(saisir)
std1=std(saisir.d);
aux=(1./std1);
saisir.d=saisir.d.*(ones(size(saisir.d,1),1)*aux);
pcatype=pca(saisir,1);
pcatype.std.d=std1;
pcatype.std.i='standard deviation';
pcatype.std.v=saisir.v;

%[n,p]=size(saisir.d);
%for i=1:n
%   for j=1:p;
%      saisir.d(i,j)=saisir.d(i,j)/std1(j);
%   end
%end
% eigenval.d=pcatype.eigenval.d;
% eigenvec.d=pcatype.eigenvec.d;
% pcatype.var_score.d=diag(sqrt(abs(eigenval.d)))*eigenvec.d;
% pcatype.var_score.i=pcatype.eigenvec.i;
% pcatype.var_score.v=saisir.v;