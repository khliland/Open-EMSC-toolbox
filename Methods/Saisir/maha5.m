function[discrtype]=maha5(saisir1,group1,maxvar,selected)
%maha5	- simple discriminant analysis forward introducing variables with validation samples 
%function[discrtype]=maha5(saisir,group,maxvar,selected)
%assesses a linear discriminant analysis introducing up to maxvar variable
%at each step, the more discriminating variables are selected  
%according to the maximisation of the number of correctly classifed samples


saisir=selectrow(saisir1,selected==0);
group=selectrow(group1,selected==0);
xval=selectrow(saisir1,selected==1);
gval=selectrow(group1,selected==1);

[n,p]=size(saisir.d);
[sn,p]=size(xval.d);

average=mean(saisir.d);
X=(saisir.d-ones(n,1)*average)/sqrt(n);% 
Xval=(xval.d-ones(sn,1)*average)/sqrt(n);

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
   disp([var maxvar]); 
    maxclassed=0;
   for scan=1:p;   
      %if(mod(scan,10)==0)
      %   disp([var scan]);
      %end
      if(sel(scan)==0);% variable not currenlty selected
         	selected(var)=scan;
   			x=X(:,selected(1:var));      
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
               %disp(nclassed);
               maxclassed=nclassed;
               kept=scan;
            end%nclassed
         end;%sel(scan)         
	end %forscan   
   selected(var)=kept;     
	sel(kept)=1;
	%disp(['Introduced : ' saisir.v(selected(var),:)]);
 	ncorrect.d(var)=maxclassed;   
   % assessing supplementary obs ******************** 
   x1=X(:,selected(1:var));
   M=inv(x1'*x1);
   x=Xval(:,selected(1:var));      
  	bary=barycentre(:,selected(1:var));
	for row=1:sn
		delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
		dist=diag(delta*M*delta');   
		[aux1 predicted_group]=min(dist);
		spredict(row)=predicted_group;   
   end;%for row
   nscorrect.d(var)=sum(spredict'==gval.d);
	% ************************************************   
   %sum(spredict-predict)   
end%forvar

% reconstructing final step of princ  ******************** 
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

sconfusion=zeros(ngroup,ngroup);
for i=1:sn
   sconfusion(gval.d(i),spredict(i))=sconfusion(gval.d(i),spredict(i))+1;
end

discrtype.ncorrect.d=ncorrect.d;
discrtype.ncorrect.v=saisir.v(selected(1:maxvar),:);
discrtype.ncorrect.i='Number of correct classifications';
discrtype.classed.d=predict;
discrtype.classed.i=saisir.i;
discrtype.classed.v='predicted group';
discrtype.confusion=confusion;
discrtype.sconfusion=sconfusion;
discrtype.sclassed.d=spredict;
discrtype.sclassed.i=gval.i;
discrtype.sclassed.v='predicted group (supplementary obs)';
discrtype.nscorrect.v=saisir.v(selected(1:maxvar),:);
discrtype.nscorrect.d=nscorrect.d;
discrtype.nscorrect.i='Number of correct classifications (supplementary obs)';
