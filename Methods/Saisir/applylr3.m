function[predy]=applylr3(xcal, ycal, x, stop_level, dim)
%applylr3    - applies latent root 3 model on saisir data x
% function[predy]=applylr3(xcal, ycal, x, stop_level, dim) 
% apply a latent root model using a "missing data" approach
% xcal, ycal : x and y values of the calibration set
% x : x values on which y must be predicted
% stop_level: when the absolute difference on y obtained from two iterations is less than 
% stop_level, the iterative step is ended
% dim number of components involved in the model

average.d=mean(xcal.d);
[n,p]=size(xcal.d);
[n1,p1]=size(x.d);
xcal.d=xcal.d-ones(n,1)*average.d;
averagey=mean(ycal.d);
ycal.d=ycal.d-averagey*ones(n,1);
normx=norm(xcal.d,'fro');
normy=norm(ycal.d)*100000000;
xcal.d=xcal.d/normx;ycal.d=ycal.d/normy;
ycalxcal=appendcol(ycal,xcal);
x1.v=[ycal.v;xcal.v];
for i=1:n1 % for all the samples to be predicted
   i
   newy=100.00;% first estimation of y (on centered data )=0
	previousy=10000;% large value
   j=0;
   xtest=(x.d(i,:)-average.d)/normx;   
   while(abs(newy-previousy)>stop_level)
      x1.d=[newy xtest]; 
      %x1.d=[ycal.d(i) xtest];
      x1.i=x.i(i,:);
   	yx=appendrow(ycalxcal,x1);% 
 		pcatype=pca(yx);
   	eigenvec=pcatype.eigenvec.d(1,1:dim);% it is only needed to reconstruct y of the last row of scores
      %eigenvec
      %sco=score.d(:,1:maxdim);
		%res.d=sqrt(n1)*sco*eigenvec';

      sco=pcatype.score.d(n+1,1:dim);% score of the last row of matrix xy
      %sco
      previousy=newy
      newy=sqrt(n+1)*sco*eigenvec'+pcatype.average.d(1)
      newy
      sco
      eigenvec
      %ycali=ycal.d(i)
      j=j+1
      gap=abs(newy-previousy)
   end;      
end;  
      
