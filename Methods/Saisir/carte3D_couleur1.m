function carte3d_couleur1(s,col1,col2,col3,startpos,endpos)
%carte3d_couleur1		- Draws a colored 3D map from a Saisir file
%function carte3D_couleur1(s,col1,col2,col3,startpos,endpos)

couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
cla;
csize=10;
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
%=============================
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
text(s.d(i,col1),s.d(i,col2),s.d(i,col3),s.i(i,startpos:endpos),'FontSize',csize,'Color',couleur(mod(indice,15)+1,:));
end;
xlabel(s.v(col1,:));   
ylabel(s.v(col2,:));   
zlabel(s.v(col3,:));
grid;
% cameramenu is usefull
