function handle=xy_plot(x, xcol, y, ycol, start_pos, end_pos);
%xy_plot         - Biplot of one column of X versus one column of Y
%function handle=xy_plot(x, xcol, y, ycol,start_pos,end_pos);
% x,y : saisir files 
% xcol, ycol : rank number of the columns to be plotted  
%if start_pos and end_pos defined: colored plot according
%to the characters of the row identifiers at position start_pos:end_pos

[n1,p1]=size(x.d);
[n2 p2]=size(y.d);
if(n1~=n2)
    error('x and y must have the same number of rows');
end

aux=appendcol(selectcol(x,xcol),selectcol(y,ycol));
if(nargin<6)
    carte(aux,1,2);
else
    carte_couleur1(aux,1,2,start_pos,end_pos);
end
