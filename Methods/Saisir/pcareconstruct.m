function[res]=pcareconstruct(pcatype,score,maxdim)
%pcareconstruct		- reconstructs original x data from PCA and a file of score
%function[res]=pcareconstruct(pcatype,score,maxdim)
% from the previously assessed score rebuild the original data matrix.
% the precision of the reconstruction is depending on the number of introduced components
% in maxdim)
[n,p]=size(score.d);
[n1,p1]=size(pcatype.score.d);
if(maxdim>=n1)
   maxdim=n1-1;
   disp('Maxdim set at the highest possible value');
end;   

%if(p~=size(pcatype.average.d))
%   help pcareconstruct;
%   error('irrelevant dimensions in score or pcatype data');
%end   
eigenvec=pcatype.eigenvec.d(:,1:maxdim);
sco=score.d(:,1:maxdim);
res.d=sqrt(n1)*sco*eigenvec';
res.d=res.d+ones(n,1)*pcatype.average.d;
res.v=pcatype.average.v;
res.i=score.i;