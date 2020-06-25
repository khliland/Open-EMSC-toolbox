function carte_barycentre(s,col1,col2,gr,charsize)
%carte_barycentre 			- graph of map of barycentre
%Display two columns as a map
%Each observation is linked to its own barycentre by a straight line 
%function carte_barycentre(s,col1,col2,gr,(charsize))
%s saisir data file;
%col1 col2: index of the columns to be displayed 
%gr : qualitatitative groups  

%figure;
couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
[n,p]=size(s.d);
maxgr=max(gr.d);
barycentre=zeros(maxgr,p);
for i=1:maxgr
   barycentre(i,:)=mean(s.d(gr.d==i,:));
end

margin=0.05;
if(nargin>7) margin=marg;end;
cla;
csize=7;
if(nargin>4)csize=charsize;end;
axis('auto');
%axis([min(s.d(:,col1))*1.1 max(s.d(:,col1))*1.1 min(s.d(:,col2))*1.1 max(s.d(:,col2))*1.1]); 
minx=min(s.d(:,col1));maxx=max(s.d(:,col1));miny=min(s.d(:,col2));maxy=max(s.d(:,col2));
minx=minx-(maxx-minx)*margin;
miny=miny-(maxy-miny)*margin;
maxx=maxx+(maxx-minx)*margin;
maxy=maxy+(maxy-miny)*margin;

axis([minx maxx miny maxy]); 

for i=1:n
    pos=s.d(i,[col1 col2]);
    %pos
    g=gr.d(i);
    bar=barycentre(g,[col1 col2]); % defined above
    
    h=line([pos(1) bar(1)], [pos(2) bar(2)]);
    set(h,'Color',couleur(mod(g,15)+1,:));
    set(h,'LineWidth',1);
    %pause
end

for i=1:n
    g=gr.d(i);
    %text(s.d(i,col1),s.d(i,col2),s.i(i,:),'FontSize',csize,'Color',couleur(mod(g,15)+1,:),'BackgroundColor',[1 1 1] );
    text(s.d(i,col1),s.d(i,col2),s.i(i,:),'FontSize',csize,'Color',couleur(mod(g,15)+1,:));
end;
xlabel(s.v(col1,:));
ylabel(s.v(col2,:));

