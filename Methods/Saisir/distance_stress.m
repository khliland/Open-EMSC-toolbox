function [stress] = distance_stress(x,dist)
%distance_stress    - Estimates the stress (default of the reconstruction of distances) 
%function [stress] = distance_stress(x,dist)
%X is a file of scores, dist is the observed distance
% cette version est celle utilsiée par le MDS de Philippe Courcoux
pred_dist=distance(x,x);
aux=dist.d-pred_dist.d;
num=sum(sum(aux.*aux));
%meandist=mean(mean(dist.d));
%aux1=dist.d-meandist;
aux1=dist.d;
denum=sum(sum(aux1.*aux1));

stress=sqrt(num/denum);

