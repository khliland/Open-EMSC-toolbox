function[res]=crossplsda(x,group,dim,selected)
%crossplsda - cross-validation on PLS discriminant analysis
%selected is a VECTOR with 0= calibration sample, 1= verification sample
%function[res]=crossplsda(x,group,dim,selected)

ngroup=max(group.d);
[n,p]=size(x.d);
xcal=selectrow(x,selected==0);
gcal=selectrow(group,selected==0);
xval=selectrow(x,selected==1);
gval=selectrow(group,selected==1);
model=plsda(xcal,gcal,dim);
xres=applyplsda(xval,model,gval);
confusion1=zeros(ngroup,ngroup);
%for i=1:size(xval.d,1)
%   confusion1(gval.d(i),res.predgroup1.d(i))=confusion1(gval.d(i),res.predgroup1.d(i)) + 1;
%end
res.confusion1=model.confusion1;
res.ncorrect1=model.ncorrect1;
res.nscorrect1=xres.ncorrect1;
res.sconfusion1=xres.confusion1;

res.confusion=model.confusion;
res.ncorrect=model.ncorrect;
res.nscorrect=xres.ncorrect;
res.sconfusion=xres.confusion;
res.info=model.info;
