function[discrtype]=maha4(saisir,group,maxvar)
%maha4 	- simple discriminant analysis forward introducing variables no validation samples 
%function[discrtype]=maha(saisir,group,maxvar)
%assess a linear discriminant analysis introducing up to maxvar variable
%at each step, the more discriminating variable
%(according to the maximisation of the number of correctly classifed samples
%begun on 7/52001
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
warning off MATLAB:singularMatrix;
for var=1:maxvar;
   maxclassed=0;
   for scan=1:p;   
      %if(mod(scan,100)==0)
      %   disp([var scan]);
      %end
      if(sel(scan)==0);% variable not currenlty selected
         	selected(var)=scan;
   			x=X(:,selected(1:var));      
         	m=model(:,selected(1:var));
         	bary=barycentre(:,selected(1:var));
				M=inv(x'*x);
				for row=1:n
					delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
				   dist=diag(delta*M*delta');   
					[aux1 predicted_group]=min(dist);
					predict(row)=predicted_group;   
            end;%for row
            nclassed=sum(predict'==group.d);
            if(nclassed>maxclassed) 
               disp(nclassed);
               maxclassed=nclassed;
               kept=scan;
            end%nclassed
         end;%sel(scan)         
	end %forscan   
   selected(var)=kept;     
	sel(kept)=1;
	disp(var);
    disp(['Introduced : ' saisir.v(selected(var),:)]);
 	ncorrect.d(var)=maxclassed;   
end%forvar
% reconstructing the final step
x=X(:,selected(1:var));
bary=barycentre(:,selected(1:var));
M=inv(x'*x);
for row=1:n
  	%size(m)
  	%size(x(row,:))
  	delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
  	dist=diag(delta*M*delta');   
  	[aux1 predicted_group]=min(dist);
	predict(row)=predicted_group;   
end;
confusion=zeros(ngroup,ngroup);
for i=1:n
   confusion(group.d(i),predict(i))=confusion(group.d(i),predict(i))+1;
end
discrtype.ncorrect.d=ncorrect.d;
discrtype.ncorrect.v=saisir.v(selected(1:maxvar),:);
discrtype.ncorrect.i='Number of correct classifications';
discrtype.classed.d=predict';
discrtype.classed.i=saisir.i;
discrtype.classed.v='predicted group';
discrtype.confusion=confusion;
discrtype.rang_var=selected(1:maxvar);