function [stress,pred_dist] = individual_distance_stress(score,obs_dist,weight,number)
%individual_distance_stress         - knowing a result of INDSCAL, assess the stress of an individual configuration        
%function [stress,pred_dist] = individual_distance_stress(score, obs_dist,(weight),(number))
% "score" contains the consensus model,
%"weight" gives the weight of all the matrices (product assessed by panellist) 
%"obs_dist" is the distance as initially assessed by the panellist "number"
%If weight and number not given: the weight is assumed to be equal to 1 for the considered 
%panellist.
x=score;

if(nargin>2)
	w=weight.d(number,:);
	x.d=x.d*diag(w);
end
   
pred_dist=distance(x,x);
aux=obs_dist.d-pred_dist.d;
num=sum(sum(aux.*aux));
%meandist=mean(mean(obs_dist.d));
aux1=obs_dist.d;%-meandist;
denum=sum(sum(aux1.*aux1));
stress=sqrt(num/denum);

