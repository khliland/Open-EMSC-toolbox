function[pcatype]=covariance_pca(covariance_type,ncomponent)
%covariance_pca         - computes principal component analysis when knowing the covariance (of variables) 
%function[pcatype]=covariance_pca(covariance_type,(ncomponent))
%Performs PCA on the covariance matrix as calculated by % "cumulate_covariance"
%returns scores, eigenvector, eigenvalues, average of the observations
%The input argument "covariance_type" is the result of the function cumulate_covariance
%such as : covariance_type1=cumulate_covariance([],covariance_type);%% finishing
% if ncomponent is defined, only this number of component is assessed.
% Default: all
% This function is useful fo to carrying on PCA with huge data set (see
% "cumulate_covariance" for an example of use)

n=covariance_type.n;
p=size(covariance_type.d,2);
average=covariance_type.average;
%centred=covariance_type.d;
% Warning functin eig does not sort the eigenvalues and eigenvectors!!
%size(centred*centred')
[v,d]=eig(covariance_type.d);% diagonalisation matrix X'X centred
[eigenval.d, index]=sort(-abs(diag(d)'));% eigenvalues in increasing order!
r=p;%rank 
eigenval.d=-eigenval.d(1:r);
eigenval.i='eigenvalues';
% using dual properties
eigenvec.d=v;
% reordering eigenvector according to eigenvalues
eigenvec.d=eigenvec.d(:,index);
eigenvec.d=eigenvec.d(:,1:r);
% assessing the true scores
aux=sqrt(n);
%size(centred)
%size(eigenvec.d)
% identifiers
eigenvec.i=covariance_type.v;
% building identifier A1, A2, ... , Ap
for i=1:p
   chaine=['A' num2str(i) '        '];
   eigenvec.v(i,:)=chaine(1:6);
end
eigenval.v=eigenvec.v;
average.v=covariance_type.v;
average.i='average';
if(nargin>1);
    if(ncomponent<p)
        eigenvec=selectcol(eigenvec,1:ncomponent);
        eigenval=selectcol(eigenval,1:ncomponent);
    end
end

pcatype.eigenvec=eigenvec;
pcatype.eigenval=eigenval;

pcatype.average=average;
pcatype.nobservation=n;
