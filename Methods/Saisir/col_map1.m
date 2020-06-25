function col_map1(s,col1,col2,char_range,labcol1,labcol2,titre,charsize,marg)
%col_map1			- colored map : using a portion of the identifiers as labels 
%col_map1(X,col1,col2,char_range,(col1label),(col2label),(title),(charsize),(margin))
%Biplot of two columns as colored map 

%From the names of individual, the string name(char_range) is extracted. Two observations
%for which these strings are different, are alos colored differently.   

%clf;
%cla;
%figure;
%couleur=[0 0 0;  1 0 1; 0 0 1; 0 0.7 0;  0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
%couleur=[0 0 1;  1 0 0; 0 0 1; 0 0.7 0;  0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
couleur=[0 0 0; 1 0 0; 0 0 1; 0 0.7 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];
cla;

title('');   
margin=0.05;
if(nargin>9) margin=marg;end;
%figure;
csize=8;
if(nargin>7)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 
model(1,:)=s.i(1,char_range);
nmodel=1;
%[bid,index]=sort(x.d);
%x=selectrow(x,index);
s.i=s.i(:,char_range);%% tricky idea
[aux1 aux2]=size(s.i);
gr=create_group1(s,1,aux2);
indice=gr.d;
for i=1:size(s.i,1)
%    trouve=0;
%    for j=1:nmodel
%          %[model(j,:) ' ' s.i(i,:)]
%        
%        if(strcmp(model(j,:),s.i(i,char_range))==1)
%          indice=j;
%          trouve=1;
%        end         
%    end
%    if(trouve==0)
%       nmodel=nmodel+1;
%       indice=nmodel;
%       model(nmodel,:)=s.i(i,char_range);
%    end   
% 
text(s.d(i,col1),s.d(i,col2),s.i(i,1:aux2),'FontSize',csize,'Color',couleur(mod(indice(i),15)+1,:));
end   
if(nargin >5) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>6) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>7) title(titre);end;
hold off;
