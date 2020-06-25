function[res]=applyfda1(saisir,fda1type,actual_group)
%applyfda1		- application of factorial discriminant analysis on PCA scores 
%function[res]=applyfda1(saisir,fda1type,(actual_group))
%predict the qualitative group on saisir data, the model is contained in fda1type
% if actual_group is given, assess also the confusion matrix (actual versus predicted)
[n,p]=size(saisir.d);
centred=saisir.d-ones(n,1)*fda1type.average.d;
S=centred*fda1type.beta.d;
J=fda1type.centroidfactor.d;
ngroup=size(J,1);
predict=zeros(n,1);
for j=1:n
   	if(mod(j,10000)==0)
        disp([j n]);
    end
    delta=J-ones(ngroup,1)*S(j,:);   
      dist=sum((delta.*delta)',1);   
      [aux1 predicted_group]=min(dist);
   	predict(j)=predicted_group;   
 end      
 res.datafactor.d=S;
 res.datafactor.i=saisir.i;
 res.datafactor.v=fda1type.beta.v;
 res.predicted_group.d=predict';
 res.predicted_group.i=saisir.i;
 res.predicted_group.v='predicted group';
if(nargin>2)
	confusion=zeros(ngroup,ngroup);
	for i=1:n
   	confusion(actual_group.d(i),predict(i))=confusion(actual_group.d(i),predict(i))+1;
	end
res.confusion=confusion;
res.nclassed=sum(predict'==actual_group.d)/n;
end
