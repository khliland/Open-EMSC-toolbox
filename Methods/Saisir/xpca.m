function[xpcatype]=xpca(s)
%xpca 			- PCA 			on a matlab data matrix   
% assess a rustic principal component analysis (on not normalised data)
% directly on data
% returns coord.d, eigenvector.d, eigenvalues.d
% average.d
% currently only nrow<ncol treated
average.d=mean(s);
[n,p]=size(s);
centred=s-ones(n,1)*average.d;
% Warning functin eig does not sort the eigenvalues and eigenvectors!!
[v,d]=eig(centred*centred');% diagonalisation matrix X'X centred
[eigenval.d, index]=sort(-abs(diag(d)'/n));% eigenvalues in increasing order!
%index
eigenval.d=-eigenval.d;
% using dual properties
% the elements of eigenvector are the normalised scores of X' 
%sum(v'*centred)% to be eliminated
%'std'
%std((v'*centred)')
eigenvec.d=normc((v'*centred)');
% reordering eigenvector according to eigenvalues
eigenvec.d=eigenvec.d(:,index);
% assessing the true scores
aux=sqrt(n);
%size(centred)
%size(eigenvec.d)
coord.d=(centred*eigenvec.d)/aux;
ncomp=min([n-1 p]);
xpcatype.score=coord.d(:,1:ncomp);
xpcatype.eigenvec=eigenvec.d(:,1:ncomp);
xpcatype.eigenval=eigenval.d(1:ncomp);
xpcatype.average=average.d;
