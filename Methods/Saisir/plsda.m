function[type]=plsda(x,group,ndim)
%plsda				- Pls discriminant analysis following the saisir format
%function[type]=plsda(x,group,ndim)
%returns (in structure type):
%beta			:coeff for predicting the indicator matrix 
%beta0		:intercept for predicting the indicator matrix
%t				:PLS latent variable
%predy		:predicted indicator matrix
%classed		:predicted groups according to method #0
%ncorrect	:number of rightly classified samples according to method #0
%(attribution to index of max of predicted Y)
%confusion	:confusion matrix according to method #0
%ncorrect1	:number of rightly classified samples according to method #1
%(mahalanobis distance on latent variable t)
%confusion1	:confusion matrix according to method #1
%tbeta		:coeff for predicting the latent variables t
%tbeta0		:intercept for predicting the indicator matrix
%linear		:linear form for direct prediction of group 
%linear0    :%the min of x'*linear + linear0 gives the predicted group  
%(this is equivalent with considering Mahalanobis distances)

%transform the file of group into an indicator matrix (1: the obs belongs to this group)
[n,p]=size(x.d);
ngroup=max(group.d);
y=ones(n,ngroup)*(-1);

for i=1:n
   y(i,group.d(i))=1;
end

mx=mean(x.d);
xc = x.d-ones(size(x.d,1),1)*mx;
my=mean(y);
yc=y-ones(size(y,1),1)*my;
[beta.d,ypred,t.d,tbeta.d]=pls(xc,yc,ndim);

% vérification de la justesse de tbeta
%sum(sum((t.d-xc*tbeta.d).*(t.d-xc*tbeta.d)))/sum(sum(t.d.*t.d)) % ceci vaut normalement 0

beta.i=x.v;
beta0.d=-mx*beta.d+my; % intercept
beta0.i='beta0';
predy.d= x.d*beta.d+ones(size(x.d,1),1)*beta0.d;
predy.i=x.i;
%predy.v=y.v;
t.i=x.i;
% building identifier t1, t2, ... , tp
for i=1:ndim
   chaine=['t' num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	t.v(i,:)=chaine(1:10);
end
% building identifier g1, g2, ... , gngroup
for i=1:ngroup
   chaine=['g' num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	predy.v(i,:)=chaine(1:10);
end

beta.v= predy.v;
beta0.v=predy.v;
type.beta=beta;
type.beta0=beta0;
type.t=t;
type.predy=predy;

%first method for the prediction of groups
[dummy,index]=max(predy.d');
classed.d=index';
classed.i=x.i;
classed.v='predicted group';
type.classed=classed;
confusion=zeros(ngroup,ngroup);
for i=1:n
   confusion(group.d(i),classed.d(i))=confusion(group.d(i),classed.d(i))+1;
end
type.ncorrect=trace(confusion);
aux.d=confusion;
aux.i=predy.v;
aux.v=predy.v;
type.confusion=aux;

% second method for the prediction of the groups
bary.d=zeros(ngroup,ndim);
for g=1:ngroup
   bary.d(g,:)=mean(t.d(group.d==g,:));
end
bary.i=predy.v;
bary.v=t.v;

% assessing the Mahalanobis metric on t
m.d=(inv(t.d'*t.d));
m.i=t.v;
m.v=t.v;
%m.d=eye(ndim);% trying the metric identity on t

% Mahalanobis distance between t-barycentres and t
dist=mdistance(t,bary,m);
[bid classed1.d]=min(dist.d');
classed1.d=classed1.d';
classed1.i=x.i;
classed1.v='predicted group';
type.classed1=classed1;
confusion1=zeros(ngroup,ngroup);
for i=1:n
   confusion1(group.d(i),classed1.d(i))=confusion1(group.d(i),classed1.d(i))+1;
end
type.ncorrect1=trace(confusion1);
aux.v=predy.v;
aux.i=predy.v;
aux.d=confusion1;
type.confusion1=aux;

% keeping tbeta
tbeta0.d=-mx*tbeta.d;
tbeta0.i='tbeta0';
tbeta0.v=t.v;

tbeta.i=x.v;
tbeta.v=t.v;

type.tbeta=tbeta;
type.tbeta0=tbeta0;
% verification rapid assessment of t
%res=t.d-(x.d*tbeta.d+ones(size(x.d,1),1)*tbeta0.d);
%sum(sum(res.*res))/sum(sum(t.d))

% assessment of linear forms for rapid prediction of groups 
linear.d=-2*tbeta.d*m.d*bary.d';
%p*g=    	p*ndim ndim*ndim*ndim*g
linear0.d=diag(bary.d*m.d*bary.d')'-2*tbeta0.d*m.d*(bary.d') ;
%1*g									     1*ndim* ndim*ndim ndim*g;
linear.i=x.v;
linear.v=predy.v;
type.linear=linear;
linear0.i='constant';
linear0.v=predy.v;
type.linear0=linear0;

% verification of linear form (applied to non centred x)
%aux=ones(n,1)*linear0.d;
%aux1=x.d*linear.d+ones(n,1)*linear0.d;
%[bid index]=min(aux1');
%pred=index';
%disp('This must be equal to 0');
%disp(sum(pred-classed1.d));
type.info=' no index: max of predicted Y; 1: mahalanobis distance on latent variables t';