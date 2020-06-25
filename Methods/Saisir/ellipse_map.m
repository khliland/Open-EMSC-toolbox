function ellipse_map(D,i,j,gr,centroid_variability,confidence,start_pos,end_pos)
%ellipse_map    -  plots the ellipse confidence interval of groups
%(usefull in discriminant analysis and related methods=
%function ellipse_map(X,col1,col2,gr,centroid_variability,confidence,(start_pos),(end_pos))
%arguments:
%   - X: data matrix
%   - col1, col2: represented columns
%   - gr: qualitative groups (referred as integer number)
%   - centroid_variability  : either 0 (variability of individual data
%   points), or 1 : variability of the centroid itself (default: 0)
%   confidence: P value of the confidence interval (default: 0.05)      

confi=0.05;
centr_var=0;
if(nargin>4)
    centr_var=centroid_variability;
end
if(nargin>5)
    confi=confidence;
end
couleur=[ 0 0 1; 0 0 0; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
cla;
%e=matrix2saisir(X);
n=max(gr.d);

hold on;
%% coloration from the names 

[n1,p1]=size(D.i);
if(nargin<=6);
    start_pos=1; end_pos=p1;
end
mycolor=create_group1(D,start_pos,end_pos);
if(nargin<=6);
    mycolor.d=ones(n1,1);
end
maxgroup=max(gr.d);

for k=1:maxgroup
   l=find(gr.d==k);
   X=selectrow(D,l');
   X=selectcol(X,[i j]);
	G=mean(X.d);
	%%size(X.i,1)
    if(size(X.i,1)<3)
        continue;
    end
    res=pca(X);
	vec=res.eigenvec.d;
    l1=res.eigenval.d(1);
	l2=res.eigenval.d(2);
	t=0:0.01:2*pi;
 	n1=size(X.d,1);
    c=tinv(1-(confi/2),n1-1);
    if(centr_var==1); c=c/sqrt(n1);end
    x=c*sqrt(l1)*cos(t);y=c*sqrt(l2)*sin(t);
 	u=(vec(1)*x-vec(2)*y)+G(1,1);v=(vec(2)*x+vec(1)*y)+G(1,2);
 	h=plot(u,v);
    k1=mycolor.d(l(1));
    if(nargin<6); k1=1;end
    %k1
    set(h,'Color',couleur(mod(k1,15)+1,:));
    set(h,'LineWidth',1.5)
    text(G(1,1),G(1,2),X.i(1,:),'Color',couleur(mod(k1,15)+1,:));
end;
xlabel(D.v(i,:));
ylabel(D.v(j,:));
%plot(X(:,1),X(:,2),'+');
%carte_couleur1(D,i,j,4,4);
%hold on;




