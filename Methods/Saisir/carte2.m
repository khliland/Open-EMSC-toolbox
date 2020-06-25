function carte2(s,col1,col2,startpos,endpos,labcol1,labcol2,titre,charsize,marg)
%carte2			- black and white map : using a portion of the identifiers as labels 
%representation de deux colonnes sous forme d'une carte colorée 
%function carte2(s,col1,col2,startpos,endpos,labcol1,labcol2,titre,charsize,marg)
%margin: expension of axis in order to cope with the long indentifiers
% default value: 0.05
% les identificateurs différents ont des couleurs également différente
couleur=[0 0 0];  
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
text(s.d(i,col1),s.d(i,col2),s.i(i,startpos:endpos),'FontSize',csize);
end   
if(nargin >5) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>6) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>7) title(titre);end;
