function[res]=crossfda1(saisir,group,among,maxvar,ntest)
%crossfda1		- crossvalidation on discrimination according to fda1 (directly on data) 
%function[res]=crossfda1(saisir,group,among,maxvar,ntest)
%apply fda1 by dividing the sample in saisir into calibration and verification set
%ntest observations in each group are randomly (with no repeat) placed in test group.
%applied directly on saisir data
% maxvar ins the maximum number of components introduced, among is the range of choice
maxgroup=max(group.d);
selected=zeros(1,size(saisir.d,1));
aux=1:size(saisir.d,1);
confusion.cal=zeros(maxgroup,maxgroup);
confusion.val=zeros(maxgroup,maxgroup);
for i=1:maxgroup
   nsample=sum(group.d==i);
   %suite=i
   aux1=aux(group.d==i);
   found=0;
   while found<ntest
    number=uint32(random('Uniform',1,nsample+0.5));
   	if(selected(1,aux1(number))==0)
      	selected(1,aux1(number))=1;
      	found=found+1;
   	end;
   end;
end;
cal=deleterow(saisir,(selected==1));
val=selectrow(saisir,(selected==1));
cal_group=deleterow(group,(selected==1));
val_group=selectrow(group,(selected==1));
pcatype=pca(cal);
fdatype=fda1(pcatype,cal_group,among, maxvar);
res1=applyfda1(val,fdatype,val_group);
res.fdatype=fdatype;
res.verification=res1;
