function[discrtype2]=crossmaha(saisir,group,maxvar,ntest)
%crossmaha			- crossvalidation on discrimination according to maha1 (directly on data) 
%function[discrtype2]=crossmaha(saisir,group,maxvar,ntest)
%apply maha1 by dividing the sample in saisir into calibration and verification set
%ntest observations in each group are randomly (with no repeat) placed in test group.
%applied directly on saisir data
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
%function[discrtype]=maha1(saisir,group,maxvar,test,testgroup)
cal=deleterow(saisir,(selected==1));
val=selectrow(saisir,(selected==1));
cal_group=deleterow(group,(selected==1));
val_group=selectrow(group,(selected==1));
discrtype2=maha1(cal,cal_group,maxvar,val,val_group)
discrtype2.selected=selected
for i=1:size(cal_group.d,1)
   confusion.cal(cal_group.d(i),discrtype2.classed.d(i))=confusion.cal(cal_group.d(i),discrtype2.classed.d(i))+1;
end
for i=1:size(val_group.d,1)
   confusion.val(val_group.d(i),discrtype2.testclassed.d(i))=confusion.val(val_group.d(i),discrtype2.testclassed.d(i))+1;
end
% for the final step !!!!!!
discrtype2.confusion.cal=confusion.cal;
discrtype2.confusion.val=confusion.val;

