function[res]=dimcross_stepwise_regression(x,y,selected,Pthres,confidence)
%dimcross_stepwise_regression		- Tests models obtained from stepwise regression
%function[res]=dimcross_stepwise_regression(x,y,selected,Pthres,(confidence))
%divides the collection into calibration and verification samples using "selected"
%in selected: 0 calibration samples; 1 verification samples
%Pthres probability threshold of entering or discarding variable
%confidence (optional): confidence interval for the correlation coefficient 
%function[res]=dimcross_stepwise_regression(x,y,selected,Pthres,(confidence))
if(nargin<5);confidence=0.05;end;

if(size(y.d,2)~=1)
   help dimcrosspls;
   error('y must have only one column');
end;   
[xcal, xval]=splitrow(x,selected==0);
[ycal, yval]=splitrow(y,selected==0);
res.calibration=stepwise_regression(xcal,ycal,Pthres,confidence);
res.validation=apply_stepwise_regression(res.calibration,xval,yval);
res.validation.observed_y=yval;