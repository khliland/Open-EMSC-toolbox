function [saisir,x] = derivative2(saisir1,window_size)
%derivative2           - Simple computation of second derivative
%function [saisir] = derivative2(saisir1,window_size)
[n,p1]=size(saisir1.d);
gap=ceil(window_size/2);
%first: smoothing the data
x=saisir1.d(:,1:(p1-window_size+1));
for i=2:window_size
    x=x+saisir1.d(:,i:(p1-window_size+i));
end
x=x/window_size;
[n,p]=size(x);
saisir.d=-2*x(:,2:(p-1))+x(:,1:(p-2))+x(:,3:p);
saisir.i=saisir1.i;
saisir.v=saisir1.v((gap+1):(p1-gap),:);
