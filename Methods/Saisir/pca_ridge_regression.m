function[ridgetype]=pca_ridge_regression(pcatype,y,range)
%pca_ridge_regression						- Basic ridge regression after PCA
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
% return as many beta as the number of elements in range
%function[ridgetype]=pca_ridge_regression(pcatype,y,range)
% warning! range is NOT a range of kvalue
% it is a rank of component.
% k is in fact the eigenvalue of the corresponding PCA component
% The rationale of this, is that k in ridge_regression is very difficult to find
% it is a good idea to test a value in the range of the observed eigenvalues

meanX=pcatype.average.d;
meanY=mean(y.d);
X=pcatype.score.d;%-ones(n,1)*meanX;
[n,p]=size(X);
Y=y.d;%-ones(n,1)*meanY;
tmp=X'*Y;% avoiding assessing that each time
XpX=X'*X;
iter=0;
krange=pcatype.eigenval.d(range);
for k=krange
   iter=iter+1;
   %disp(iter);
   %disp(k);
   beta(:,iter)=inv((XpX+k*eye(p)))*tmp;
   %beta(:,iter)=pinv((XpX+k*eye(p)))*tmp;
   predy(:,iter)=X*beta(:,iter)+meanY;   
   tmp1=predy(:,iter)-y.d;
   rmsec(iter)=sqrt(sum(tmp1.*tmp1)/n);
	%disp(rmsec(iter));   
end
% beta from original data
ridgetype.beta.d=pcatype.eigenvec.d*beta/sqrt(n);
ridgetype.beta.i=pcatype.eigenvec.i;
ridgetype.beta.v=num2str(krange');
ridgetype.krange.v=num2str(range');
ridgetype.krange.d=krange;
ridgetype.krange.i='k /component';
ridgetype.averagex.d=meanX;
ridgetype.averagex.i='Average of X';
ridgetype.averagex.v=pcatype.average.v;

ridgetype.averagey.d=meanY;
ridgetype.averagey.i='Average of Y';
ridgetype.averagey.v=y.v;

ridgetype.rmsec.d=rmsec;
ridgetype.rmsec.v=num2str(krange');
ridgetype.rmsec.i='root mean square sum of square';

ridgetype.predy.d=predy;
ridgetype.predy.v=num2str(krange');
ridgetype.predy.i=pcatype.score.i;

corr.d=zeros(1,iter);
for i=1:iter
   aux=corrcoef(y.d,predy(:,i));
   ridgetype.corr.d(1,i)=aux(1,2);
end;   
ridgetype.corr.i='correlation coefficient';
ridgetype.corr.v=num2str(krange');



