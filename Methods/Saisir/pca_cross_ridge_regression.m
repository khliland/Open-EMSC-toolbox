function[res]=pca_cross_ridge_regression(x,y,range,selected)
%pca_cross_ridge_regression	- PCA ridge regression with crossvalidation 
% divide a collection in calibration and verification set
% apply ridge_regression on the validation set
% function[res]=cross_ridge_regression(x,y,krange,selected)
% some trick about range (which is the cutting component)
% see PCA_ridge_regression

%nind=size(x.d,1);
%nend=sum(selected);

[xval, xcal]=splitrow(x,selected==1);
[yval, ycal]=splitrow(y,selected==1);
pcatype=pca(xcal);
%'[ridgetype]=pca_ridge_regression(pcatype,ycal,range);'
[ridgetype]=pca_ridge_regression(pcatype,ycal,range);
%'res1=apply_ridge_regression(ridgetype, xval,yval);'

res1=apply_ridge_regression(ridgetype, xval,yval);

res.predy=res1.predy;
res.obsy=yval;   
res.corr=res1.corr;
res.rmsecv=res1.rmsecv;
res.ridgetype=ridgetype;