function [saisir] = msc(saisir1,reference)
%msc        - Multiplicative scatter correction on spectra
% function [x] = msc(x1,(reference))
% multiplicative scatter correction, reference is the reference spectrum
%if nargin=1, the reference is the average spectrum
if(nargin==1)
   model=mean(saisir1.d);
else
   model=reference.d;
end;   
[n p]=size(saisir1.d);
y=[ones(p,1) model'];
saisir.d=zeros(n,p);
for i=1:n
   beta=regress(saisir1.d(i,:)',y);
   saisir.d(i,:)=(saisir1.d(i,:)-beta(1)*ones(1,p))/beta(2);
end   
saisir.v=saisir1.v;
saisir.i=saisir1.i;