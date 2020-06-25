function[group]=apply_nuee(saisir,xcentre)
%apply_nuee				- apply Nuee dynamique (KCmeans)
%function[res]=nuee(X,barycenter)
%X              :a matrix of dimension n x p
%barycenter     : a matrix defining the barycenter k x p with k groups 
%Barycenter is possibly the field "center" of the output of function "nuee"  
[n,p]=size(saisir.d);
[ngroup p1]=size(xcentre.d);
%disp('computing ...');
%group.d=zeros(n,1);

% for j=1:n
%        if(mod(j,100000)==0)
%        disp(num2str([j n]));
%        end
%     x=ones(ngroup,1)*saisir.d(j,:);
% %     for g=1:ngroup
% %          d(g)=0;
% %          delta=xcentre.d(g,:)-x;
% %         d(g)=sum(delta.*delta);   
% %     end
%     delta=x-xcentre.d; 
%     delta=delta.*delta;
%     d=sum(delta');
%     [bid,index]=min(d);
%      group.d(j)=index;
% end
%% far better algorithm !!!
for g=1:ngroup
    aux=ones(n,1)*xcentre.d(g,:);
    delta=saisir.d-aux;
    aux=delta.*delta;
    aux1(:,g)=sum(aux,2);
end   
[bid index]=min(aux1');
group.d=index';

group.i=saisir.i;
group.v='group';

