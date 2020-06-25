function browse(saisir)
%browse			- browses a series of curves
%function browse(X)
%Display the rows of the matrix X as curves
%Right button to go down, Left button to go up, Ctrl C to exit
disp('Right button to go down, Left button to go up, Ctrl C to exit');
right=3; left=1;
[n,p]=size(saisir.d);
i=0;
while i<n
   i=i+1;
   courbe(saisir,i);
%   echo off;
	[x,y,button]=ginput(1);
   if(button==1)
      i=i-2;
      if(i<1)
         i=0;
      end
   end
end
