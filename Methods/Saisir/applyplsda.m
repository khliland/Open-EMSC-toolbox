function[res]=applyplsda(x,model,actual_group)
%applyplsda - Applies pls discriminant analysis after model assessment using plsda
%return the predicted group on (unknown data x
%'model' is the structure returned by function 'plsda'
%function[res]=applyplsda(x,model,actual_group)
ngroup=size(model.linear.v,1);
[n,p]=size(x.d);
%aux=ones(n,1)*model.linear0.d;
aux1=x.d*model.linear.d+ones(n,1)*model.linear0.d;% prediction of scores T
[bid index]=min(aux1');
pred.d=index';
pred.i=x.i;
pred.v='predicted group (according to Mahalanobis distance on t)';

if(nargin>2)
	confusion=zeros(ngroup,ngroup);
	for i=1:n
   	confusion(actual_group.d(i),pred.d(i))=confusion(actual_group.d(i),pred.d(i))+1;
	end
res.confusion1=confusion;
res.ncorrect1=sum(pred.d==actual_group.d);
end
res.predgroup1=pred;

%aux=ones(n,1)*model.beta0.d;
aux1=x.d*model.beta.d+ones(n,1)*model.beta0.d;%% predictions of indicators
%================
[dummy,index]=max(aux1');
classed=index';
confusion=zeros(ngroup,ngroup);
for i=1:n
   confusion(actual_group.d(i),classed(i))=confusion(actual_group.d(i),classed(i))+1;
end
res.ncorrect=trace(confusion);
res.confusion=confusion;
res.predgroup.d=classed;
res.predgroup.i=x.i;
res.predgroup.v='predicted group (according to max of pred y)';
res.info=model.info;
%=================
