function h=tcourbe(s1,ncol,xlab,ylab,titre)
%tcourbe 			- representation of a column of a given matrix 
%function tcourbe(X, ncol, (xlabel),(ylabel),(title))

s=saisir_transpose(s1);
if(~isempty(str2num(s.v))) h=plot(str2num(s.v),s.d(ncol,:));
else
   h=plot(s.d(ncol,:));end;

set(h,'LineWidth',2);% utilisation du handle
axis('tight'); 
if(nargin >2) xlabel(xlab);end;
if(nargin>3)ylabel(ylab);end;
t=s.i(ncol,:);
if(nargin<5) title(s.i(ncol,:)); else title(titre); end
