function x = moving_average(saisir1,window_size)
%moving_average   - Moving average of signals
% the data points are supposed to be regularly spaced
%function res=moving_averagesaisir1,window_size)
%window_size (number of data points involved in the calculation)
%is preferably an odd number
[n,p1]=size(saisir1.d);
gap=ceil(window_size/2);
%first: smoothing the data
x=saisir1.d(:,1:(p1-window_size+1));
for i=2:window_size
    x=x+saisir1.d(:,i:(p1-window_size+i));
end
x=x/window_size;
x.d=x;
x.i=saisir1.i;
x.v=saisir1.v(gap:(p1-gap+1),:);