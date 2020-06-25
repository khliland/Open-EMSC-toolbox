function submap(s,col1,col2,xstring,labcol1,labcol2,titre,charsize,marg)
%submap				- represents only the observations whose indentifiers contains the string xstring
%function submap(X,col1,col2,xstring,labcol1,labcol2,titre,charsize,marg)
%The scale of the COMPLETE map is used. 

margin=0.05;
if(nargin>8) margin=marg;end;
cla;
csize=6;
if(nargin>7)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;
index=seekstring(s.i,xstring);
axis([minx maxx miny maxy]); 
s1=selectrow(s,index);
text(s1.d(:,col1),s1.d(:,col2),s1.i,'FontSize',csize)
if(nargin >4) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>5) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>6) title(titre);end;
