function vect=find_peaks(saisir,row,threshold,gap,min_max)
%find_peaks   - find peaks greater than a threshold value 
% inside a window of size (data points) defined by gap. gap is a odd number
% return the VECTOR of positions (name of variable converted into numbers) 
% function vect=find_peaks(saisir,row,threshold,gap,(min_max))
% if min_max is larger than 0, the minimum are also identified 
vect=[];
[n,p]=size(saisir.d);
peak.d=zeros(n,8);
if(nargin<4)
    min_max=0;
end
nel=0;
for i=row
   %disp(i);
   courbe(saisir,i);
   x=saisir.d(i,:);
   aux=(gap+1)/2;
   aux1=aux-1;
   for j=aux:p-aux;
      if(x(j)>threshold)
         [a,b]=sort(-x(j-aux1:j+aux1));
         if (b(1)==aux)
            posx=str2num(saisir.v(j,:));
            nel=nel+1;
            vect(nel)=posx;
            line([posx posx],[0 x(j)]);
         	text(posx,x(j),saisir.v(j,:),'FontSize',8);   
         end   
      end;   
    end   
 end
vect1=vect;
if(min_max>0)
clear vect;
nel=0;
for i=row
   %disp(i);
   %courbe(saisir,i);
   x=saisir.d(i,:);
   aux=(gap+1)/2;
   aux1=aux-1;
   for j=aux:p-aux;
      if(abs(x(j))>threshold)
      [a,b]=sort(-x(j-aux1:j+aux1));
      %   [b(end) aux]
         if (b(end)==aux)
            'ici'
            posx=str2num(saisir.v(j,:));
            nel=nel+1;
            vect(nel)=posx;
            line([posx posx],[0 x(j)]);
         	text(posx,x(j),saisir.v(j,:),'FontSize',8);   
         end   
      end;   
    end   
 end
 vect=[vect1 vect];
end