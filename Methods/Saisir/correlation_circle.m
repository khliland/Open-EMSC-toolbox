function[saisir]=correlation_circle(pcatype,saisir,col1,col2,startpos,endpos)
%correlation_circle  		- Displays the correlation circle after PCA
%function[res]=correlation_circle(pcatype,X,col1,col2,(startpos),(endpos))
%pcatype is the result of the order pcatype=pca(X)
%X is the original data matrix
%col1 and col2 are the ranks of the components to be represented. 
%%disp('new')
couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
[n,p]=size(saisir.d)
%size(pcatype.score.d)
a=corrcoef([saisir.d pcatype.score.d]);
b=size(a,2);
saisir.d=a(1:size(saisir.d,2),size(saisir.d,2)+1:b);
saisir.i=saisir.v;
saisir.v=pcatype.score.v;
axis square;
t=0:pi/20:2*pi;
plot(sin(t),cos(t))
if(nargin>4)
    g=create_group1(saisir,startpos,endpos);
end
if(nargin>4)
    for i=1:p
        m=g.d(i);
        text(saisir.d(i,col1),saisir.d(i,col2),saisir.i(i,:),'FontSize',8,'Color',couleur((mod(m-1,15)+1),:));
    end
else
    text(saisir.d(:,col1),saisir.d(:,col2),saisir.i,'FontSize',8,'Color',couleur(1,:));
end
%hold on
% for i=1:p 
%     h=line([0 saisir.d(i,col1)], [0 saisir.d(i,col2)] );
%     if(nargin>4)
%     m=g.d(i);
%     set(h,'Color',couleur((mod(m-1,15)+1),:));
%     set(h,'LineWidth',1);
%     end
% end
line([-1 1],[0 0]);
line([0 0],[-1 1]);
axis square
xlabel(pcatype.score.v(col1,:));
ylabel(pcatype.score.v(col2,:));

hold off 




