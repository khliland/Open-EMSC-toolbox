function[moyenne]=saisir_mean(saisir)
%saisir_mean  	- computes the mean of the columns, following the saisir format
%function[moyenne]=saisir_mean(saisir)
m=mean(saisir.d);
moyenne.d=m;
moyenne.v=saisir.v;
moyenne.i='average';

