function[res]=apply_stepwise_regression(type,x,y)
%apply_stepwise_regression			- applies stepwise_regression on "unknown" data
%function[res]=apply_stepwise_regression("type",x,(y))
%Using the models (in "type") as returned by stepwise_regression
%build as many models as available in "type"
%if y (optional) is given, gives also the Root mean square error on y
%SAISIR FUNCTION


[n,p]=size(x.d);
[n1,p1]=size(y.d);
nmodel=size(type,2);
for model=1:nmodel
   aux=type{model};
   if(isempty(aux));break;end;
   intercept=aux.intercept;
   rang=aux.res.d(:,7)';
   coeff=aux.res.d(:,1);
   mat=x.d(:,rang);
   res.ypred.d(:,model)=mat*coeff+intercept;
   res.ypred.i=x.i;
   aux=[num2str(model) '               '];
   res.ypred.v(model,:)=aux(1:10);
	if(nargin>2)   
      delta=y.d(:,1)-res.ypred.d(:,model);
      res.rmsecv.d(model)=sqrt(sum(delta.*delta)/n);   
    if(n1>1)% impossible to calculate corr if size(y.d,1)<2
        s=std(y.d);
        if(s>0)% impossible to assess corr if y always the same
            co=corrcoef(res.ypred.d(:,model),y.d);
	        res.corr.d(model)=co(1,2);
        else
            disp('all the y identical, impossible to assess correlation coefficient');
        end
    end
end
end
if(nargin>2)
	   res.rmsecv.v=res.ypred.v;
	res.corr.v=res.rmsecv.v;
	res.corr.i='Correlation coefficient';
    res.rmsecv.i='RMSECV';
end
