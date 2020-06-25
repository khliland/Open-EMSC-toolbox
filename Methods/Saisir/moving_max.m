function [saisir] = moving_max(saisir1,window_size)
%moving_max         - replaces the central point of a moving window by the maximum value 
%function [saisir] = moving_max(saisir1,window_size)
% window_size is preferably an odd number
[nrow ncol]=size(saisir1.d);
    gap=floor(window_size/2);

for row= 1:nrow
    signal=saisir1.d(row,:);
    for col=1:ncol
        deb=col-gap; xend=col+gap;
        if(deb<1); deb=1;end
        if(xend>ncol); xend=ncol;end;
        saisir.d(row,col)=max(signal(deb:xend));
        
    end
end
saisir.i=saisir1.i;
saisir.v=saisir1.v;
