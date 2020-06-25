function[fdatype]=fda2(x,g,among, maxvar,selected)
%fda2				- stepwise factorial discriminant analysis on PCA scores with verification
%function[fdatype]=fda2(x,g,among, maxvar,selected)
%criterion: maximisation of trace of T-1B
%selected : VECTOR indicating samples in calbration set( 0), or in validation set (1); 

xcal=selectrow(x,selected==0);
group=selectrow(g,selected==0);
xval=selectrow(x,selected==1);
gval=selectrow(g,selected==1);

pcatype=pca(xcal);
sup=applypca(pcatype,xval);
[nsuprow ncol1]=size(sup.d);
[nrow ncol]=size(pcatype.score.d);

C=pcatype.score.d(:,1:among);
Y=normc(C);
K=sup.d(:,1:among);%
YS=normc(K);% normed supplementary obs. 
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
for i=rank(1:maxvar)'
   aux=[aux i];
   P1=P(:,aux);   
   Y1=Y(:,aux);
   YS1=YS(:,aux);
   xpcatype=xpca(P1);% PCA on the gravity centers   
   S=Y1*xpcatype.eigenvec;% scores of the data 
   J=P1*xpcatype.eigenvec;% scores of the gravity centers
   L=YS1*xpcatype.eigenvec;% score of the sup. data
   %size(J)
   %size(S)
   
   for j=1:nrow
   	delta=J-ones(ngroup,1)*S(j,:);   
      dist=sum((delta.*delta)',1);   
      [aux1 predicted_group]=min(dist);
   	predict(j)=predicted_group;   
   end
   
   for j=1:nsuprow
      delta=J-ones(ngroup,1)*L(j,:);   
      dist=sum((delta.*delta)',1);   
      [aux1 predicted_group]=min(dist);
   	spredict(j)=predicted_group;   
	end      
   
 step=step+1;   
ncorrect.d(step)=sum(predict'==group.d);
nscorrect.d(step)=sum(spredict'==gval.d);
end
ranked=rank(1:maxvar);
V=pcatype.eigenvec.d(:,ranked)*diag(1./sqrt(pcatype.eigenval.d(ranked)))*xpcatype.eigenvec;
fdatype.introduced.d=rank(1:maxvar);
fdatype.introduced.i=pcatype.score.v(rank(1:maxvar),:);
fdatype.introduced.v='introduced component';
fdatype.ncorrect.i=pcatype.score.v(rank(1:maxvar),:);
fdatype.ncorrect.v='number of correct classifications (calibration set)';
fdatype.ncorrect.d=ncorrect.d';

fdatype.nscorrect.i=pcatype.score.v(rank(1:maxvar),:);
fdatype.nscorrect.v='number of correct classifications (validation set)';
fdatype.nscorrect.d=nscorrect.d';

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
fdatype.confusion=confusion;
fdatype.average=pcatype.average;

sconfusion=zeros(ngroup,ngroup);
for i=1:nsuprow
   sconfusion(gval.d(i),spredict(i))=sconfusion(gval.d(i),spredict(i))+1;
end
fdatype.sconfusion=sconfusion;

