function [ftype] = d2_factorial_map(saisir)
%d2_factorial_map    - assesses a factorial map from a table of squared distance
%function [ftype] = d2_factorial_map(saisir)
%Uses the Torgerson approach to transform squared distance into pseudo
%scalar products. 

[n p]=size(saisir.d)
%Dist=-saisir.d-ones(n,1)*mean(saisir.d,1)-ones(p,1)*mean(saisir.d,2);
%Dist=Dist-mean(mean(Dist,));
n_1=1/n;
%DONT TOUCH ANYTHING THERE
wij=0.5*(ones(n,1)*sum(saisir.d,1)*(n_1)+sum(saisir.d,2)*ones(1,p)*(n_1)-saisir.d-((n_1))*sum(sum(saisir.d)));

%[U,S,V] = svd(wij);
%ftype.U.d=U*sqrt(S); ftype.S.d=S;ftype.V.d=V;
%ftype.U.i=saisir.i;
[v,d]=eig(wij);
%'sort'
[eigenval.d, index]=sort(-abs(diag(d)'));% eigenvalues in increasing order!
%index
ftype.eigenval.d=-eigenval.d(2:p);
eigenvec.d=v(:,index(2:p))*diag(sqrt(ftype.eigenval.d));

for i=1:p-1
   chaine=['A' num2str(i) '        '];
   ftype.score.v(i,:)=chaine(1:6);
end
ftype.eigenval.i=ftype.score.v;
ftype.score.v=[ftype.score.v num2str(round(1000*ftype.eigenval.d'/sum(ftype.eigenval.d))/10) char(ones(n-1,1)*'%')];
ftype.score.i=saisir.i;
ftype.score.d=eigenvec.d;
ftype.eigenval.d=[ftype.eigenval.d' zeros(p-1,1)];
ftype.eigenval.d(1,2)=ftype.eigenval.d(1,1);
for i=2:p-1
   ftype.eigenval.d(i,2)=(ftype.eigenval.d(i-1,2)+ftype.eigenval.d(i,1));
end
s=sum(ftype.eigenval.d(:,1));
ftype.eigenval.d(p-1,2);
ftype.eigenval.d(:,2)=ftype.eigenval.d(:,2)/s*100;
ftype.eigenval.v=['eigenvalues';'%sum eigval'] ;

%Below an example of validation test 
%essai=random_saisir(200,20);
%dist=distance(essai,essai);
%dist2=dist;
%dist2.d=dist.d.*dist.d;
%factres=d2_factorial_map(dist2);
%pred_dist=distance(factres.U,factres.U);
%aux=dist.d-pred_dist.d;
%num=sum(sum(aux.*aux))
%denum=sum(sum(dist.d.*dist.d))
%ratio=num/denum*100
% The ratio is about 0 

