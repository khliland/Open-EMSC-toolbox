function[res]=nuee(saisir,ngroup,nchanged)
%nuee				- Nuee dynamique (KCmeans)
%function[res]=nuee(X,ngroup,(nchanged))
%Clusters the data into ngroup according to the KCmeans method ("nuée dynamique");
%If nchanged defined, stop iteration when there are still nchanged groups which changed
%from one iteration to another. 
%This allows sparing some time. nchanged must be small in comparison with
%the number of rows of X 

[n,p]=size(saisir.d);
% for i=1:n
%     if(mod(i,10000)==0)
%         disp(num2str([i n]));
%     end
%     group(i)=ceil(rand*ngroup);
% end;
group=ceil(rand(n,1)*ngroup);
if(nargin<3)
    nchanged=0;
end

moved=nchanged+1;
iter=0;
disp('computing ...');
while moved>nchanged;
   iter=iter+1;
   disp(iter);
   moved=0;
   nlost=0;
   lost=[];
   for i=1:ngroup
      %disp([i ngroup]);
       if(sum(group==i)==0)
         %centre(i,:)=[];
         nlost=nlost+1;
         disp(['Warning a group is empty. Reduced to ' num2str(ngroup-nlost)]);
         lost(nlost)=i;
         %new=round(random('Uniform',1,n));
         %centre(i,:)=saisir.d(new,:);   
      else   
         centre(i,:)=mean(saisir.d(group==i,:));
      end;
   end
   if(nlost>0)
   centre(lost,:)=[];
   %size(centre)
   ngroup=ngroup-nlost;
   end
   
   for j=1:n
       if(mod(j,100000)==0)
         disp(num2str([j n]));
       end
      x=saisir.d(j,:);
      for g=1:ngroup
         d(g)=0;
         for var=1:p
            delta=centre(g,var)-x(var);
         	d(g)=d(g)+delta*delta;   
         end
      end
      [bid,index]=min(d(1:ngroup));
      if(index~=group(j));
	      group(j)=index;
         moved=moved+1;
      end
    end
    disp(moved);    
end
%bid=sum((centre.*centre)');
%bid=sum(centre');
%[bid1,ind]=sort(centre(:,1));
%centre(:,1)'
%bid1'
%ind'
%index(ind)=1:ngroup;
%ind=index;

%for i=1:n;
%   group(i)=ind(group(i));
%end
%size(centre(1:ngroup,:))
%size(centre(ind,:));
%centre(1:ngroup,:)=centre(ind,:);
res.group.d=group;
res.group.i=saisir.i;
res.group.v='group';
if(n<1000)
    res.name=num2str(group);
end
res.centre.d=centre;
res.centre.v=saisir.v;

for i=1:ngroup
   chaine=['G' num2str(i) '             '];
   %eigenvec.v(i,:)=chaine(1:6);
 	res.centre.i(i,:)=chaine(1:10);
end
disp([num2str(ngroup) ' actually found']);
