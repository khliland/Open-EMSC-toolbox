function [saisir] = curve_erosion(saisir1,window_size)
%curve_erosion 			- erosion of a curve
%window_size prefrably an odd number
[nrow ncol]=size(saisir1.d);
gap=ceil(window_size/2);
for col= 1:ncol
    low=col-gap;
    high=col+gap;
    if(low<=0) 
        low=1;
    end
    if(high>ncol) 
        high=ncol;
    end
    %low
    %high
    aux=min(saisir1.d(:,low:high)');
    saisir.d(:,col)=aux';
end
saisir.v=saisir1.v;
saisir.i=saisir1.i;