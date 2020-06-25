function ca_map(s,col1,col2,startpos,endpos,labcol1,labcol2,titre,charsize,marg)
%ca_map 			- colored map for correspondence analysis: using a portion of the identifiers as labels 
%ca_map(X,col1,col2,startpos,endpos,(col1label),(col2label),(title),(charsize),(margin))
%Biplot of two columns as colored map useful for correspondance analysis (from function ca) 
%The coloration of the displayed descriptors depends on the arguments
%startpos and endpos. If one of this argument is zero: single (black) color
%Otherwise, from the names of individual, the string name(sartpos:endpos) is extracted. Two observations
%for which these strings are different, are also colored differently.   
%%SPECIFIC TO CORRESPONDANCE ANALYSIS:
%If the first letter of the identifier is either c(column) or r (row), this letter is removed in the name. 
%The letter c produces an italic display. This allows a representation in
%which the variables are in italic letter

%clf;
%cla;
%figure;
%couleur=[0 0 0;  1 0 1; 0 0 1; 0 0.7 0;  0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
%couleur=[0 0 1;  1 0 0; 0 0 1; 0 0.7 0;  0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
couleur=[0 0 0; 1 0 0; 0 0 1; 0 0.7 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];
cla;
color_flag=1;
if((startpos==0)||(endpos==0))
    color_flag=0;
end
title('');   
margin=0.05;
if(nargin>9) margin=marg;end;
%figure;
csize=8;
if(nargin>8)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 
%model(1,:)=s.i(1,startpos:endpos);
nmodel=1;
%[bid,index]=sort(x.d);
%x=selectrow(x,index);
if(color_flag==1)
    gr=create_group1(s,startpos,endpos);
    indice=gr.d;
else
    indice=zeros(size(s.d,1),1);
end

for i=1:size(s.i,1)
%    trouve=0;
%    for j=1:nmodel
%          %[model(j,:) ' ' s.i(i,:)]
%        
%        if(strcmp(model(j,:),s.i(i,startpos:endpos))==1)
%          indice=j;
%          trouve=1;
%        end         
%    end
%    if(trouve==0)
%       nmodel=nmodel+1;
%       indice=nmodel;
%       model(nmodel,:)=s.i(i,startpos:endpos);
%    end   
% 
%%FontAngle: [ {normal} | italic | oblique ]
xtext=s.i(i,:);
if(xtext(1)=='c')
    xtext(1)=[];
    h= text(s.d(i,col1),s.d(i,col2),xtext,'FontSize',csize,'FontAngle','italic','Color',couleur(mod(indice(i),15)+1,:));
else
    if(xtext(1)=='r')
        xtext(1)=[];
        h= text(s.d(i,col1),s.d(i,col2),xtext,'FontSize',csize,'FontAngle','normal','Color',couleur(mod(indice(i),15)+1,:));
    else
        h= text(s.d(i,col1),s.d(i,col2),xtext,'FontSize',csize,'FontAngle','normal','Color',couleur(mod(indice(i),15)+1,:));
    end
end

end   
%get(h)
%set(h)
if(nargin >5) xlabel(labcol1)
	else xlabel(s.v(col1,:));   
end;
if(nargin>6) ylabel(labcol2);
	else ylabel(s.v(col2,:));   
end;
if(nargin>7) title(titre);end;
hold off;
