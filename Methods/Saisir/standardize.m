function[s1]=standardize(s2)
%standardize     	- divide each column of a matrix with the corresponding standard deviation
%function[X1]=standardize(X2)
sd=std(s2.d,1);
%size(s2.d)
%size(sd)
%size(ones(size(s2.d,1),1))
s1.d=s2.d./(ones(size(s2.d,1),1)*sd);
s1.v=s2.v;
s1.i=s2.i;
