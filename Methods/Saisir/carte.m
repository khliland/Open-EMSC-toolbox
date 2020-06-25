function carte(s,col1,col2,labcol1,labcol2,titre,charsize,marg)
%carte			- ('map' in french) 	graph of map of data using identifiers as names
%function carte(X,col1,col2,(col1label),(col2label),(title),(charsize),(margin))
%Biplot of two columns as a map, with display of the identifiers  
%margin: expension of axis in order to cope with the long indentifiers
%default value: 0.05
margin=0.05;
if(nargin>7) margin=marg;end;
cla;
csize=10;
if(nargin>6)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 
text(s.d(:,col1),s.d(:,col2),s.i,'FontSize',csize) %,'Color',[0 0 1]);
if(nargin >3) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>4) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>5) title(titre);end;
