function h=show_vector(s,nligne,csize,xlab,ylab,titre)
%show_vector				- represents a row of a matrix as a succession identifiers
%function handle=show_vector(X, (nrow) ,(csize),(xlab),(ylab),(title))
%The identifiers of the columns are plotted with X being the index of the variable and Y the actual
%value of the variable for the selected row nrow
%xlab, ylab, title: optional xlabel, ylabel, title 
cla;
margin=0.05;
if(nargin==1)
    nligne=1;
end
if(nargin<3)
    csize=10;
end
[n,p]=size(s.d);
miny=min(s.d(nligne,:));maxy=max(s.d(nligne,:));
minx=1;maxx=p;
axis('auto');
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;
axis([minx maxx miny maxy]); 
text((1:p),s.d(nligne,:),s.v,'FontSize',csize,'Color',[0 0 0]);
%set(h,'LineWidth',2);% utilisation du handle
axis('tight'); 
if(nargin >3) xlabel(xlab);end;
if(nargin>4)ylabel(ylab);end;
t=s.i(nligne,:);
if(nargin<6) title(s.i(nligne,:)); else title(titre); end
