function[ridgetype]=ridge_regression(x,y,krange)
%ridge_regression		- Basic ridge regression
% function [ridgetype]=ridge_regression(x,y,krange)
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
% return as many beta as the number of elements in krange

[n,p]=size(x.d);
meanX=mean(x.d);
meanY=mean(y.d);
X=x.d-ones(n,1)*meanX;
Y=y.d-ones(n,1)*meanY;
tmp=X'*Y;% avoiding assessing that each time
XpX=X'*X;
iter=0;
for k=krange
   iter=iter+1;
   disp(iter);
   disp(k);
   beta(:,iter)=inv((XpX+k*eye(p)))*tmp;
   %beta(:,iter)=pinv((XpX+k*eye(p)))*tmp;
   predy(:,iter)=X*beta(:,iter)+meanY;   
   tmp1=predy(:,iter)-y.d;
   rmsec(iter)=sqrt(sum(tmp1.*tmp1)/n);
	disp(rmsec(iter));   
end
ridgetype.beta.d=beta;
ridgetype.beta.i=x.v;
ridgetype.beta.v=num2str(krange');

ridgetype.averagex.d=meanX;
ridgetype.averagex.i='Average of X';
ridgetype.averagex.v=x.v;

ridgetype.averagey.d=meanY;
ridgetype.averagey.i='Average of Y';
ridgetype.averagey.v=y.v;

ridgetype.rmsec.d=rmsec;
ridgetype.rmsec.v=num2str(krange');
ridgetype.rmsec.i='root mean square sum of square';

ridgetype.predy.d=predy;
ridgetype.predy.v=num2str(krange');
ridgetype.predy.i=x.i;

corr.d=zeros(1,iter);
for i=1:iter
   aux=corrcoef(y.d,predy(:,i));
   ridgetype.corr.d(1,i)=aux(1,2);
end;   
ridgetype.corr.i='correlation coefficient';
ridgetype.corr.v=num2str(krange');



