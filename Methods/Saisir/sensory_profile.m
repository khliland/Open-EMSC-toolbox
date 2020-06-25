function[h]=sensory_profile(X,range,max_score,xtitle)
%sensory_profile         - Graphical representation of sensory profile 
%function[h]=sensory_profile(X,range,max_score,(title))
%Graphical display of sensory profiles in a "circular" representation.
%-Saisir file:  matrix of data to be displayed
%-range      :  vector of the indices of the rows to be displayed
%-max_score  :  maximal score used in the scale  
%-title      : (optional) title of the graph.
%Warning: will not work properly with more than 15 variables
%Preferably reduce the identifiers of variables to 3-4 characters
couleur=[0 0 0; 0 0 1; 0 0.7 0; 1 0 0; 0.5 0.5 0; 0.5 0 0.5; 0 0.5 0.5 ; 0.25 0.25 0.25 ; 0.5 0 0; 0 0.5 0; 0 0.5 0; 0.1 0.2 0.3; 0.3 0.2 0.1; 0.5 0.5 0.8; 0.1 0.8 0.1 ];  
%size(couleur)
axis square;
%axis([-1 1 -1 1]); 
%axis off;
tested=selectrow(X,range);
%tested.d=tested.d/max_score;
[n,p]=size(tested.d);
angle=2*pi/p;
if(mod(p,2)==0);%even number
    first_angle=0;
else
    %first_angle=pi/4+angle/2-angle;
    %first_angle=pi/4+angle/2-angle;
    first_angle=-pi+pi/2-angle/2;
end
a1=first_angle;
for a=1:p
    %a1=first_angle+a*angle;
    myangle(a)=a1;
    a1=first_angle+a*angle;
end
myangle(p+1)=first_angle;%+angle;
hold on;
h=rectangle('Position', [-max_score*1.40 -max_score*1.40 max_score*2*1.40 max_score*2*1.40]);
set(h,'FaceColor',[1 1 1]);
set(h,'EdgeColor','none');
for i=1:n
    myrow=tested.d(i,:);
    myrow=[myrow myrow(1)];
    h=plot(cos(myangle).*myrow,sin(myangle).*myrow);
    set(h,'Color',couleur((mod(i-1,15)+1),:));
    set(h,'LineWidth',2);
    H(i)=h;%% keeping the handles associated with profiles
end
%myangle(p+1)=first_angle;
grid=ones(1,p+1)*max_score;
h=plot(cos(myangle).*grid,sin(myangle).*grid);
set(h,'Color',[0 0 0]);
set(h,'LineWidth',1);
%set(h)
set(h,'LineStyle','--');
grid=ones(1,p+1)*max_score/2;
h=plot(cos(myangle).*grid,sin(myangle).*grid);
set(h,'Color',[0 0 0]);
set(h,'LineWidth',1);
set(h,'LineStyle','--');

a1=first_angle;
for a=1:p+1
    h=line([0 cos(a1)]*max_score*1.1, [0 sin(a1)]*max_score*1.1);
    set(h,'Color',[0 0 0]);
    set(h,'LineWidth',1);
    set(h,'LineStyle','--');
    a1=first_angle+a*angle;
end

a1=first_angle;
for a=1:p
    place=cos(a1)*max_score*1.1;
    %place=cos(a1)*max_score;
        if(place<0)
        place=place-max_score*0.1;%% it generally gives a smart position to text on left side
    end
    h=text(place, sin(a1)*max_score*1.1,X.v(a,:),'FontSize',8);
%     X.v(a,:)
%     a1*45
%     set(h,'Rotation',a1*45);
    a1=first_angle+a*angle;
end

%axis square;
axis off;
hold off;
if(n<6)% impossible to display a smart legend with more than 5 profiles
    test=cellstr(tested.i);
    legend(H,test);
end;
if(nargin>3)
h=title(xtitle);
set(h,'FontSize',15);
end
h=H;%% returning the vector of handles of the profiles (possible use ???)