function h=tcourbes(s,range,xlab,ylab,titre)
%tcourbes 			- represents several columns of a matrix as curves
%usage handle=Tcourbes(X, select_col, (xlabel),(ylabel),(title))
%select_col gives the indices of the selected columns

s1=saisir_transpose(s);
switch nargin
case 2
   h=courbes(s1,range);
case 3
   h=courbes(s1,range,xlab);
case 4
   h=courbes(s1,range,xlab,ylab);
case 5
   h=courbes(s1,range,xlab,titre);
otherwise
   error('wrong number of arguments');
end; 
 