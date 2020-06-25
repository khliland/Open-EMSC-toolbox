function[fdatype]=fda1(pcatype, group, among, maxvar)
%fda1				- stepwise factorial discriminant analysis on PCA scores 
% function[fdatype]=fda1(pcatype, group, among, maxvar)
% assesses a stepwise factorial discriminant analysis according to Bertrand et al., J of Chemometrics, Vol . 4, 413-427 (1990). 
% the basic idea is to assess a factorial discriminant analysis on the scores of 
% a previous pca. The criterion of score selection is the maximisation of the trace.  
% "group" is the saisir file of group, "among is" the number of the first components 
% on which the selection is applied
% "max var" is the maximum number of components possibly introduced in the model
[nrow ncol]=size(pcatype.score.d);
C=pcatype.score.d(:,1:among);
Y=normc(C);
%bid=Y'*Y
ngroup=max(group.d);
aux=zeros(nrow,ngroup);
for i=1:nrow
   aux(i,group.d(i))=1;
end   
w=sum(aux);
P=diag(1./w)*aux'*Y;% gravity center of the normalised scores
diago=diag(P'*diag(w)*P);
[diago,rank]=sort(-diago);
aux=[];
%size(rank)
step=0;
predict=zeros(1,nrow);
for i=rank(1:maxvar)'
   disp([step+1 i maxvar]);
   aux=[aux i];
   P1=P(:,aux);   
   %P1=diag(sqrt(w))*P(:,aux); à vérifier ********************
   Y1=Y(:,aux);
   xpcatype=xpca(P1);% PCA on the gravity centers   
   S=Y1*xpcatype.eigenvec;% scores of the data 
   J=P1*xpcatype.eigenvec;% scores of the gravity centers
   %size(J)
   %size(S)
   for j=1:nrow
   	%if(mod(j,10000)==0)
    %    disp([j nrow]);
    %end
       delta=J-ones(ngroup,1)*S(j,:);   
      dist=sum((delta.*delta)',1);   
      [aux1 predicted_group]=min(dist);
   	predict(j)=predicted_group;   
   end      
step=step+1;   
ncorrect.d(step)=sum(predict'==group.d);
end
ranked=rank(1:maxvar);
V=pcatype.eigenvec.d(:,ranked)*diag(1./sqrt(pcatype.eigenval.d(ranked)))*xpcatype.eigenvec;
fdatype.introduced.d=rank(1:maxvar);
fdatype.introduced.i=pcatype.score.v(rank(1:maxvar),:);
fdatype.introduced.v='introduced component';
fdatype.ncorrect.i=pcatype.score.v(rank(1:maxvar),:);
fdatype.ncorrect.v='number of correct classifications';
fdatype.ncorrect.d=ncorrect.d'
fdatype.beta.d = V/sqrt(nrow);fdatype.beta.i=pcatype.eigenvec.i; 
for i=1:size(V,2)
   chaine=['F' num2str(i) '        '];
   fdatype.beta.v(i,:)=chaine(1:6);
end
fdatype.datafactor.d=S;
fdatype.centroidfactor.d=J;
fdatype.centroidfactor.v=fdatype.beta.v;
fdatype.datafactor.i=pcatype.score.i;
fdatype.datafactor.v=fdatype.beta.v;
fdatype.eigenval.d=xpcatype.eigenval;
fdatype.eigenval.i='eigenvalues';
for i=1:ngroup
   chaine=['G' num2str(i) '        '];
   fdatype.centroidfactor.i(i,:)=chaine(1:6);
end

confusion=zeros(ngroup,ngroup);
for i=1:nrow
   confusion(group.d(i),predict(i))=confusion(group.d(i),predict(i))+1;
end
fdatype.confusion=matrix2saisir(confusion,'actual','predi ');
fdatype.average=pcatype.average;