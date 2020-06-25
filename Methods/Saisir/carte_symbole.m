function carte_symbole(s,col1,col2,startpos,endpos,labcol1,labcol2,titre,charsize)
%carte_symbole			- map with symbols : using a portion of the identifiers for
%carte_symbole(X,col1,col2,startpos,endpos,(col1label),(col2label),(title),(charsize))
%Biplot of two columns as a map with symbols 
%The symbols of the different observations depend on the arguments
%startpos and endpos.
%From the names of individual, the string name(sartpos:endpos) is extracted. Two observations
%for which this strings are different, are represented with different symbols.   

%symbole=['o';'s';'p';'s';'^';'^';'p';'h';'p';'h';'+';'*';'>';'<';'v'] ;
%bold=['none';'b   ';'none';'k   ';'none';'k   ';'none';'k   ';'k   ';'k   ';'none';'none';'none';'none'];

symbole=['s';'s';'s';'o';'s';'s';'s';'s';'s';'h';'+';'*';'>';'<';'v'] ;
bold=['none';'none';'none';'m   ';'r   ';'none';'none';'none';'k   ';'k   ';'none';'none';'none';'none'];


title('');   
margin=0.05;
if(nargin>9) margin=marg;end;
cla;
csize=6;
if(nargin>8)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 
model(1,:)=s.i(1,startpos:endpos);
nmodel=1;
for i=1:size(s.i,1)
   trouve=0;
   for j=1:nmodel
         %[model(j,:) ' ' s.i(i,:)]
       
       if(strcmp(model(j,:),s.i(i,startpos:endpos))==1)
         indice=j;
         trouve=1;
       end         
   end
   if(trouve==0)
      nmodel=nmodel+1;
      indice=nmodel;
      model(nmodel,:)=s.i(i,startpos:endpos);
   end   
   hold on;
   h=plot(s.d(i,col1),s.d(i,col2),['k' symbole(mod(indice,14-1)+1,:)],'MarkerSize',csize,'MarkerFaceColor',bold(mod(indice,14-1)+1,:));
   hold off;   
end   
%get(h);

if(nargin >5) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>6) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>7) title(titre);end;
