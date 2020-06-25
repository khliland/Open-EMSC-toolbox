function[type]=stepwise_regression(x,y,Pthres,confidence,xval,yval)
%stepwise_regression 				- stepwise regression between x and y
%function[result]=stepwise_regression(x,y,Pthres,(confidence))
%P is the probability threshold for entering or discarding a variable
%confidence (default=0.05) is the probability of the confidence interval
%for the limit of the regression coefficients
% Returns an array of cells corresponding to each step of the regression
% message: gives the name of the entered or discarded variable'
% res           : a structure described below
% intercept     : constant value (beta0) of the current model
% RMSE          : root mean square error of the model 
% r2            : determination coefficient 
% adjusted_r2   : adjusted determination coefficient (taking into account of the dimensions
% F             : Fisher F value of the current model
% probF         : probaility value assiciated with F
% ypred         : predicted y values 
%
% res           : the rows indicate the variables introduced  
%                 the columns give information on the corresponding
%                 regression coefficients:
%regression coefficients 
%Lower confidence limit 
%Higher confidence limit 
%Std of regression coeff.
%t value of reg. coeff.
%Prob. of reg. coef.
%Rank of variables 


%if(nargin<3)
if(nargin<4)
   confidence=0.05;
end
conf=confidence/2;
resv(1,:)='regression coefficients ';
resv(2,:)='Lower confidence limit  ';
resv(3,:)='Higher confidence limit ';
resv(4,:)='Std of regression coeff.';
resv(5,:)='t value of reg. coeff.  ';
resv(6,:)='Prob. of reg. coef.     ';
resv(7,:)='Rank of variables       ';

[n,p]=size(x.d);
meanx=mean(x.d);
x.d=x.d-ones(n,1)*meanx;
meany=mean(y.d);
y.d=y.d-meany;

x1=[];

i=0;step=0;
y1=y.d;
SST=y1'*y1;%Sum of square total
MST=SST/(n-1);%Mean square total
%x1=x.d;
xcons=x.d;
rang(1)=-10;%dummy value
while(1);
i=i+1;   
step=step+1;
%size(y.d)
%size(x.d)
warning off MATLAB:divideByZero
co=cormap(y,x);
warning on MATLAB:divideByZero

[xmax index]=max(abs(co.d));% corrélation between residual of x and residual of y
%max
%index
%disp(['Entering variable ' x.v(index,:) ' Partial Corrélation coefficient =' num2str(max)]);
disp(['Entering variable ' x.v(index,:) ]);

if(sum(rang==index)>0)
   disp(['Variable previously introduced : work finished']);
	return;   
end
%x1(:,i)=xcons(:,index);% creation of the current set of selected x variables
rang(i)=index;%keeping the variable introduced
x1=xcons(:,rang);
%size(x1)
aux1=pinv(x1'*x1);
beta=aux1*x1'*y1;% assessment of beta at this step
ypred=x1*beta;% assessment of predicted y
xpred=x1*aux1*x1'*xcons;%assessment of predicted x
y.d=y1-ypred;% residuals of y
x.d=xcons-xpred;%residuals of x
dl=n-i-1;% degrees of freedom
%dl=n-i;
SSE=sum(y.d.*y.d);%Sum of square of Error
MSE=SSE/dl;%Mean  square error
sd=sqrt(MSE);%RMSEC
SSR=SST-SSE;%Sum of square of regression
MSR=SSR/(i);
F=MSR/MSE;
%sd=sqrt(sum(y.d.*y.d)/n);
disp(['error = ' num2str(sd)]);
beta_sd=sd*sqrt(diag(aux1));
t=beta./beta_sd;%t value
%disp('t');
%disp(t);
P=(1-tcdf(abs(t),dl))*2;%probability of beta(i)=0
%disp('p');
%disp(P);
%disp('beta')
%disp(beta);
lowlim=beta+beta_sd*tinv(conf,dl);
highlim=beta-beta_sd*tinv(conf,dl);
%disp('lowlim')
%disp(lowlim);
%disp('highlim');
%disp(highlim);
%x.d(:,index)=0;
block.message=['Entering variable ' x.v(index,:) ' at step ' num2str(step)];
clear res;
res.i=x.v(rang,:);
res.v=resv;
res.d(:,1)=beta;
res.d(:,2)=lowlim;
res.d(:,3)=highlim;
res.d(:,4)=beta_sd;
res.d(:,5)=t;
res.d(:,6)=P;
res.d(:,7)=rang;
block.res=res;
block.intercept=meany-meanx(rang)*beta;
block.RMSE=sd;
block.r2= 1-SSE/SST;
block.adjusted_r2=1-MSE/MST;
block.F=F;
block.probF=1-fcdf(F,i,dl);
%++
xutile=xcons(:,res.d(:,7));
block.ypred.d=xutile*res.d(:,1)+meany;
block.ypred.i=y.i;
block.ypred.v=y.v;
%++
type{step}=block;
if(sum(P>Pthres)>0)
   [bid,index]=max(P);
   if(index==i)
      disp('Finished at previous step ')
      type{step}=[];
      break;   
   end
   step=step+1;
   disp(['Discarding variable ' x.v(rang(index),:) ' Probability = ' num2str(bid)]);
   rang(index)=[];
   x1=xcons(:,rang);
   i=i-1;
   %=============
   aux1=pinv(x1'*x1);
	beta=aux1*x1'*y1;% assessment of beta at this step
	ypred=x1*beta;% assessment of predicted y
	xpred=x1*aux1*x1'*xcons;%assessment of predicted x
	y.d=y1-ypred;% residuals of y
	%x.d=xcons-xpred;%residuals of x
	dl=n-i-1;% degrees of freedom
	sd=sqrt(sum(y.d.*y.d)/dl);%RMSEC
	%sd=sqrt(sum(y.d.*y.d)/n);
	disp(['error = ' num2str(sd)]);
	beta_sd=sd*sqrt(diag(aux1));
	t=beta./beta_sd;%t value
	%disp('t');
	%disp(t);
	P=(1-tcdf(abs(t),dl))*2;%probability of beta(i)=0
	lowlim=beta-beta_sd*tinv(conf,dl);
	highlim=beta+beta_sd*tinv(conf,dl);
%===   
block.message=['Discarding variable ' x.v(index,:) ' at step ' num2str(step)];
clear res;
res.i=x.v(rang,:);
res.v=resv;
res.d(:,1)=beta;
res.d(:,2)=lowlim;
res.d(:,3)=highlim;
res.d(:,4)=beta_sd;
res.d(:,5)=t;
res.d(:,6)=P;
res.d(:,7)=rang;
block.res=res;
block.intercept=meany-meanx(rang)*beta;
block.RMSE=sd;
block.r2= 1-SSE/SST;
block.adjusted_r2=1-MSE/MST;
block.F=F;
block.probF=1-fcdf(F,i,dl);
xutile=xcons(:,res.d(:,7));
block.ypred.d=xutile*res.d(:,1)+meany;
block.ypred.i=y.i;
block.ypred.v=y.v;
type{step}=block;
%===
end
if(i>=p)
   break;
end
%pause
end;



