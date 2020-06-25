function[predy]=applylr1(lr1type, x)
%applylr1         - Apply basic latent root model on saisir data x
%function [predy]=applylr1(lr1type,x)
%creates as many y predicted as allowed by the dimensions in lr1type
%lr1type is the output argument of the function LR1
[n,p]=size(x.d);
x.d=x.d-ones(n,1)*lr1type.averagex.d;
predy.d=x.d*lr1type.beta.d + lr1type.averagey*ones(size(x.d,1),size(lr1type.beta.d,2));
predy.i=x.i;
predy.v=lr1type.beta.v;
