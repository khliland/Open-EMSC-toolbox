function[discrtype]=maha6(saisir1,group1,maxvar,selected)
%maha6 	- simple discriminant analysis forward introducing variables with validation samples 
%function[discrtype]=maha6(saisir,group,maxvar,selected)
%assess a linear discriminant analysis introducing up to maxvar variable
%at each step, the more discriminating variable
%according to the maximisation of the trace of T-1B is introduced
%the collection is divided in cal. sample and test samples according to selected: 
%selected=0 , sample placed in calibration, =1 verification
huge=100000000000;
saisir=selectrow(saisir1,selected==0);
group=selectrow(group1,selected==0);
xval=selectrow(saisir1,selected==1);
gval=selectrow(group1,selected==1);

[sn,p]=size(xval.d);

[n,p]=size(saisir.d);
average=mean(saisir.d);
X=(saisir.d-ones(n,1)*average)/sqrt(n);% 
XVAL=(xval.d-ones(sn,1)*average)/sqrt(n);% 

ngroup=max(group.d);
barycentre=zeros(ngroup,p);
model=zeros(n,p);
for g=1:ngroup
   if(sum(group.d==g)==0)
       gn(g)=1;
       barycentre(g,:)=ones(1,p)*huge;%% a group does not exist in calibration set 
   else
        barycentre(g,:)=mean(X(group.d==g,:));
        gn(g)=sum(group.d==1);
   end
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
for row=1:n
   %size(m)
   %size(x(row,:))
   delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
   dist=diag(delta*M*delta');   
   [aux1 predicted_group]=min(dist);
	predict(row)=predicted_group;   
end;
ncorrect.d(var)=sum(predict'==group.d);
%disp(ncorrect.d(var));

%sup. obs. **************************************
x=XVAL(:,selected(1:var));
for row=1:sn
   %size(m)
   %size(x(row,:))
   delta=bary-ones(ngroup,1)*x(row,:);% delta from all the gavity center and current x g*p
   dist=diag(delta*M*delta');   
   [aux1 predicted_group]=min(dist);
	spredict(row)=predicted_group;   
end;
nscorrect.d(var)=sum(spredict'==gval.d);
%disp(nscorrect.d(var));
% ***********************************************
end
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
discrtype.nscorrect.d=nscorrect.d;
discrtype.nscorrect.v=saisir.v(selected(1:maxvar),:);
discrtype.nscorrect.i='Number of correct classifications (test set)';

discrtype.classed.d=predict;
discrtype.classed.i=saisir.i;
discrtype.classed.v='predicted group';

discrtype.sclassed.d=spredict;
discrtype.sclassed.i=gval.i;
discrtype.sclassed.v='predicted group';


discrtype.confusion=confusion;
discrtype.varrank=selected(1:maxvar);
discrtype.sconfusion=sconfusion;
