function[predy,obsy,rmsecv,corr]=crossvalpls1(x,y,ndim,inval,ntest)
%crossvalpls1			- crossvalidation of pls with ndim dimensions. 
%function [predy,obsy,rmsecv,corr]=crossvalpls1(x,y,ndim,inval,ntest)
%ndim= PLS dimension; inval: number of observations in cross-validation
%RANDOMLY SELECTED
%ntest: number of independant test 
%return predicted y in cross validation
%  returns also rmsecv the root mean square error of crossvalidation and corr the correlation
% coefficient
nind=size(x.d,1);
nend=nind;
for i=1:ntest;
   disp(['dimension ' num2str(ndim)]);
   disp(['test ' num2str(i) ' among ' num2str(ntest) ]);
   selected=random_select(nind,inval);
   [xval, xcal]=splitrow(x,selected==1);
   [yval, ycal]=splitrow(y,selected==1);
   plsmodel=saisirpls(xcal,ycal,ndim);
   crossvaly=applypls(xval,plsmodel);
   if(i==1)
      predy=crossvaly;
   	obsy=yval;   
   	else
      predy= appendrow(predy,crossvaly);
      obsy = appendrow(obsy,yval);
   end;
end;   
nend=inval*ntest;
rmsecv=sqrt(((predy.d-obsy.d)'*(predy.d-obsy.d))/nend);
co=corrcoef(predy.d,obsy.d);
corr=co(1,2);