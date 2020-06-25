function edge=labelled_hist(s,col,startpos,endpos,nclass,charsize,str1)
%labelled_hist			- draws an histogram in which each name is considered as a label
%function labelled_hist(s,col,startpos,endpos,(nclass),(charsize),(car))
%with
%	s 						: a saisir structure
%	col						: the column from which the histogram is drawn
%	startpos and endpos	    : the position in the row identifier strings considered as keys for coloration
%	nclass					: number of desired classes
%	charsize				: the size of character on the graph
%   str                     : (optional)  if str (a string) is defined, all the observations are represented with this string 
%                           by choosing str='--' (for example),it is possible to avoid overlapping identifiers.
clf;
couleur=[0 0 0; 1 0 0; 0 0 1; 0 0.7 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];
str=[];
if(nargin>6)
    str=str1;
end
if(nargin<5) nclass=30;end
[n,p]=size(s.d);
x=selectcol(s,col);
[bid,index]=sort(x.d);
x=selectrow(x,index);
gr=create_group1(x,startpos,endpos);
gr.g.i;
%cla;
csize=8;
if(nargin>5);csize=charsize;end;
axis('auto');
[N,class_center]=hist(x.d,nclass);
max_N=max(N);
%axis([min(class_center)-1 max(class_center)+1 0 max_N+1]);
gap=(class_center(2)-class_center(1));
axis([min(class_center)-gap max(class_center)+gap 0 max_N+1]);
%size(class_center)
low_edge=class_center(1)-gap/2;
%low_edge=7;
currentclass=0;
currenty=0;
nclass=size(class_center,2);
ymax=0;
for i=1:n
   while(x.d(i)>=low_edge);
    %low_edge
    %x.d(i)
    low_edge=low_edge+gap;
   	currentclass=currentclass+1;   
   	   
   if(currentclass>nclass);
       currentclass=nclass;
       break; 
   end
   currenty=0;
   end
   currenty=currenty+1;
   if(currentclass==0); currentclass=1;end
   if(~isempty(str))
       xcode=str;
   else
       xcode=x.i(i,startpos:endpos);
   end
   text(class_center(currentclass),currenty,class_center(currentclass),xcode,'FontSize',csize,'Color',couleur(mod(gr.d(i),15)+1,:));
  if(currenty>ymax)
       ymax=currenty;
   end
   %pause
end
title(s.v(col,:));
edge=(class_center(1)-gap/2):gap:(max(x.d)+gap);
% give the legend of color if the option string is activated ==============
if(~isempty(str))
    [n,p]=size(gr.g.d);
    cy=ymax;
    mygap=ymax/20;
    for i=1:n 
        xcode=[str '  ' gr.g.i(i,:)];
        cy=cy-mygap;
        text(class_center(ceil(currentclass*0.7)),cy,xcode,'FontSize',14,'Color',couleur(mod((i-1),15)+1,:));
    end
end