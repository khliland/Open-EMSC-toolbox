function[discrtype]=maha3(saisir,group,maxvar)
%maha3 	- simple discriminant analysis forward introducing variables no validation samples 
%function[discrtype]=maha3(saisir,group,maxvar)
%assess a linear discriminant analysis introducing up to maxvar variable
%at each step, the more discriminating variable
%(according to the maximisation of the trace of T-1B is introduced)

[n,p]=size(saisir.d);
average=mean(saisir.d);
X=(saisir.d-ones(n,1)*average)/sqrt(n);% 
ngroup=max(group.d);
barycentre=zeros(ngroup,p);
model=zeros(n,p);
for g=1:ngroup
   barycentre(g,:)=mean(X(group.d==g,:));
   gn(g)=sum(group.d==1);
end
model=barycentre(group.d,:);
selected=zeros(1,maxvar);% index of the variables currently selected
sel=zeros(1,p);% boolean =1 variable already selected
for var=1:maxvar;
   maxtrace=0;
   for scan=1:p;   
 	      %if(mod(scan,10)==0)
      	%   disp([var scan]);
		   %end
      	if(sel(scan)==0);% variable not currenlty selected
         selected(var)=scan;
         x=X(:,selected(1:var));      
         m=model(:,selected(1:var));
         mytrace=trace(pinv(x'*x)*(m'*m));
         if(mytrace>maxtrace)
            %disp(saisir.v(scan,:));
            maxtrace=mytrace;
            kept=scan;
         end
     	end;      
	end;         
selected(var)=kept;     
sel(kept)=1;
%disp(['step : ' num2str(var) ', Introduced : ' saisir.v(selected(var),:)]);
x=X(:,selected(1:var));
bary=barycentre(:,selected(1:var));
M=pinv(x'*x);
predict=zeros(1,n);
for row=1:n
%    if(mod(row,1000)==0);
%        disp([row n]);
%    end
%    %size(m)
   %size(x(row,:))
   delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
   dist=diag(delta*M*delta');   
   [aux1 predicted_group]=min(dist);
	predict(row)=predicted_group;   
end;
ncorrect.d(var)=sum(predict'==group.d);
disp(ncorrect.d(var));
disp([var maxvar]);
end
confusion=zeros(ngroup,ngroup);
for i=1:n
   confusion(group.d(i),predict(i))=confusion(group.d(i),predict(i))+1;
end
discrtype.ncorrect.d=ncorrect.d;
discrtype.ncorrect.v=saisir.v(selected(1:maxvar),:);
discrtype.ncorrect.i='Number of correct classifications';
discrtype.classed.d=predict;
discrtype.classed.i=saisir.i;
discrtype.classed.v='predicted group';
discrtype.confusion=matrix2saisir(confusion,'actual', 'predi');
discrtype.varrank=selected(1:maxvar);
discrtype.classed.d=discrtype.classed.d';