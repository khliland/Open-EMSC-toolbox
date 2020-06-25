function[res]=crossvalpls1a(x,y,ndim,selected)
%crossvalpls1a			- crossvalidation of pls with up to ndim dimensions. 
%function [res]=crossvalpls1a(x,y,ndim,selected)
%ndim= PLS dimension;
%Performs a single crossvalidation test. "selected" is a vector  
%giving the samples in verification set. 1= in verification; 0 = in calibration set 
%returns predicted y and observed y in cross validation obtain from 1 to
%ndim dimension
%returns also rmsev the root mean square error of crossvalidation and corr the correlation
%coefficient

nind=size(x.d,1);
nend=nind;
%disp(['dimension ' num2str(ndim)]);
%disp(['test ' num2str(i) ' among ' num2str(ntest) ]);
%selected=random_select(nind,inval);
[xval, xcal]=splitrow(x,selected==1);
[yval, ycal]=splitrow(y,selected==1);
%plsmodel=saisirpls(xcal,ycal,ndim);
plsmodel=basic_pls(xcal,ycal,ndim);
[res1]=applypls(xval,plsmodel,yval);
res.calibration=plsmodel;
res.validation=res1;
