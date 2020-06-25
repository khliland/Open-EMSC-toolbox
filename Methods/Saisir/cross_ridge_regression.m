function[res]=cross_ridge_regression(x,y,krange,selected)
%cross_ridge_regression		    - ridge regression with crossvalidation 
%function[res]=cross_ridge_regression(x,y,krange,selected)
%divides a collection in calibration and verification set
%applies ridge_regression on the validation set

nind=size(x.d,1);
nend=sum(selected);

[xval, xcal]=splitrow(x,selected==1);
[yval, ycal]=splitrow(y,selected==1);

[ridgetype]=ridge_regression(xcal,ycal,krange)

res1=apply_ridge_regression(ridgetype, xval,yval);

res.predy=res1.predy;
res.obsy=yval;   
res.corr=res1.corr;
res.rmsecv=res1.rmsecv;
res.ridgetype=ridgetype;