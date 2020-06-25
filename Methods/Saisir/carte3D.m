function carte3d(s,col1,col2,col3,labcol1,labcol2,labcol3,titre,charsize)
%carte3d 			- Draws a 3D map 
%function carte3D(X,col1,col2,col3,(labcol1),(labcol2),(labcol3),(title),(charsize))
%Display columns co1, col2, col3 as X, Y and Z values of a 3D plot.
%Options: labcol: label of axes
%charsize: size of the characters (default :6)

cla;
csize=6;
if(nargin>8)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));
miny=min(s.d(:,col2));
maxy=max(s.d(:,col2));
minz=min(s.d(:,col3));
maxz=max(s.d(:,col3));


%minx=minx-(maxx-minx);
%miny=miny-(maxy-miny);
%minz=minz-(maxz-minz);
%maxx=maxx+(maxx-minx);
%maxy=maxy+(maxy-miny);
%maxz=maxz+(maxz-minz);

axis([minx maxx miny maxy minz maxz]); 
text(s.d(:,col1),s.d(:,col2),s.d(:,col3),s.i,'FontSize',csize) %,'Color',[0 0 1]);
if(nargin >4) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>5) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>6) zlabel(labcol3);
	else zlabel(s.v(col3,:));   
end;
if(nargin>7) title(titre);end;
grid;
% cameramenu is usefull
