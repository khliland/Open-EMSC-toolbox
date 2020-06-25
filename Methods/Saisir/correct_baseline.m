function [saisir] = correct_baseline (saisir1,col1,col2)
%correct_baseline  			- simple linear baseline correction, using intensity
%function [saisir] = correct_baseline (saisir1,col1,col2)
%The baseline is modelled by a straight line going from data points col1 to col2

[nrow ncol]=size(saisir1.d);
for i=1:nrow
    spectre=saisir1.d(i,:);
    val1=spectre(col1);
    val2=spectre(col2);
    delta=(val2-val1)/(col2-col1);
    start=val1-(col1)*delta;
    baseline=start+(1:ncol)*delta;
    saisir.d(i,:)=spectre-baseline;    
end
%plot(baseline)
saisir.v=saisir1.v;
saisir.i=saisir1.i;