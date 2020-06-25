function carte_couleur3(s1,col1,col2,xstring,startpos,endpos)
%carte_couleur3			- colored map : using a portion of the identifiers as labels 
%function carte_couleur3(s1,col1,col2,xstring,startpos,endpos)
%representation de deux colonnes sous forme d'une carte colorée 
%carte_couleur1(saisir,col1,col2,startpos,endpos,(col1label),(col2label),(title),(charsize),(margin))
%margin: expension of axis in order to cope with the long indentifiers
% default value: 0.05
% les identificateurs différents ont des couleurs également différente
% ICI L'IDENTIFICATEUR COMPLET EST DONNE (contrairement à carte_couleur1)
couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
   
margin=0.05;
if(nargin>9) margin=marg;end;
cla;
csize=6;
if(nargin>8)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s1.d(:,col1));maxx=max(s1.d(:,col1));miny=min(s1.d(:,col2));maxy=max(s1.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;
index=seekstring(s1.i,xstring);
s=selectrow(s1,index);
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
%text(s.d(i,col1),s.d(i,col2),s.i(i,startpos:endpos),'FontSize',csize,'Color',couleur(MOD(indice,15)+1,:));
text(s.d(i,col1),s.d(i,col2),s.i(i,:),'FontSize',csize,'Color',couleur(MOD(indice,15)+1,:));
end   
