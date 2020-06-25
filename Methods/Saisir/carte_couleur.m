function carte_couleur(s,col1,col2,labcol1,labcol2,titre,charsize,marg)
%carte_couleur				- colored map : using the identifiers as labels 
%representation de deux colonnes sous forme d'une carte colorée 
%carte_couleur(saisir,col1,col2,(col1label),(col2label),(title),(charsize),(margin))
%margin: expension of axis in order to cope with the long indentifiers
% default value: 0.05
% les identificateurs différents ont des couleurs également différente
couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
   
margin=0.05;
if(nargin>7) margin=marg;end;
cla;
csize=6;
if(nargin>6)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 
model(1,:)=s.i(1,:);
nmodel=1;
for i=1:size(s.i,1)
   trouve=0;
   for j=1:nmodel
         %[model(j,:) ' ' s.i(i,:)]
       
       if(strcmp(model(j,:),s.i(i,:))==1)
         indice=j;
         trouve=1;
       end         
   end
   if(trouve==0)
      nmodel=nmodel+1;
      indice=nmodel;
      model(nmodel,:)=s.i(i,:);
   end   
text(s.d(i,col1),s.d(i,col2),s.i(i,:),'FontSize',csize,'Color',couleur(mod(indice,15)+1,:));
end   
if(nargin >3) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>4) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>5) title(titre);end;
