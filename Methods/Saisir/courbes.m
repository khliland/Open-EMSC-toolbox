function h=courbes(s,range,xlab,ylab,titre)
%courbes 			- represents several rows of a matrix as curves
%usage handle=courbes(saisir,range,(xlabel),(ylabel),(title))
%range is a vector indicating the rows to be displayed

[n,p]=size(s.d);
if(nargin==1)
   nstart=1;
   nend=n;
	range=nstart:nend;   
end;   
%if(nstart>n); nstart=n; end;
%if(nend>n);nend=n;end;
[bid,n1]=size(range);
if(range(1)<0); range(1)=1;end;
if(~isempty(str2num(s.v))) h=plot(str2num(s.v),s.d(range(1),:),'k');
set(h,'LineWidth',1);% utilisation du handle
else
   h=plot(s.d(range(1),:));end;
	set(h,'LineWidth',2);% utilisation du handle
hold on
for i=range(2:n1)
   if((i<=n)&(i>0))
      if(~isempty(str2num(s.v)))
      	h=plot(str2num(s.v),s.d(i,:),'k');
		else
   	   h=plot(s.d(i,:));
   	end;
    end  
    set(h,'LineWidth',2);% utilisation du handle
end;   
set(h,'LineWidth',2);% utilisation du handle
axis('tight'); 
if(nargin >2) xlabel(xlab);end;
if(nargin>3)ylabel(ylab);end;
if(nargin>5) title(titre); end
hold off