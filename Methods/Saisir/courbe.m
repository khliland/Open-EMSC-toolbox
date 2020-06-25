function h=courbe(s,nligne,xlab,ylab,titre)
%courbe				- represents a row of a matrix as a curve
%usage handle=courbe(X,(nrow), (xlabel),(ylabel),(title))

if(nargin<2);nligne=1;end;

if(~isempty(str2num(s.v))) h=plot(str2num(s.v),s.d(nligne,:));
else
   h=plot(s.d(nligne,:));end;

set(h,'LineWidth',2);% utilisation du handle
axis('tight'); 
if(nargin >2) xlabel(xlab);end;
if(nargin>3)ylabel(ylab);end;
t=s.i(nligne,:);
if(nargin<5) title(s.i(nligne,:)); else title(titre); end
