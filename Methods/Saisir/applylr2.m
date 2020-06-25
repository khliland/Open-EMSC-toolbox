function[predy]=applylr2(lr2type, x)
%applylr2      - applies Latent root model 2 on saisir data x
% function [predy]=applylr2(lr2type,x)
% apply a basic latent root model (in lr2type) on saisir data x
% creates as many y predicted as allowed by the dimensions in lr2type
[n,p]=size(x.d);
x.d=x.d-ones(n,1)*lr2type.averagex.d;
predy.d=x.d*lr2type.beta.d + lr2type.averagey*ones(size(x.d,1),size(lr2type.beta.d,2));
predy.i=x.i;
predy.v=lr2type.beta.v;
