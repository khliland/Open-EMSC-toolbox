function [covariance_type]=cumulate_covariance(x,covariance_type1);
%cumulate_covariance    - Covariance on huge data set
%function [covariance_type]=cumulate_covariance(x,covariance_type1);
%if status=0 or undefined calculate X'X in X_X, Sum of row in SX, 
%and n the number of processed observation
%if the first argument =[], assess the covariance in the SAISIR format
% single argument : starting the work 
%A complete script must therefore be something like
%cov=cumulate_covariance(collection1);%% starting
%cov=cumulate_covariance(collection2,cov);%% cumulating values
%cov=cumulate_covariance(collection3,cov);%% cumulating values
%...
%cov=cumulate_covariance(collection_n,cov);%% cumulating values
%covariance=cumulate_covariance([],cov);%% finishing
if(~isempty(x))
%cumulating the values 
    if(nargin==1)
        covariance_type.X_X=x.d'*x.d;
        covariance_type.SX=sum(x.d);
        covariance_type.n=size(x.d,1);
        covariance_type.v=x.v;   
    else
        covariance_type.X_X=x.d'*x.d+covariance_type1.X_X;
        covariance_type.SX=sum(x.d)+covariance_type1.SX;
        covariance_type.n=size(x.d,1)+covariance_type1.n;
        covariance_type.v=covariance_type1.v;
    end
else
% final calculation    
n=covariance_type1.n;
m=covariance_type1.SX/n;
%thisone=ones(n,1);
thisone=ones(size(covariance_type1.X_X,1),1);
covariance_type.d=covariance_type1.X_X/n-2*m'*m+(m'*thisone'*thisone*m)/n;
covariance_type.i=covariance_type1.v;
covariance_type.v=covariance_type1.v;
covariance_type.n=n;
covariance_type.average.d=m;
covariance_type.average.i='average';
covariance_type.average.v=covariance_type1.v;


% x=rand(20,5);
% test=matrix2saisir(x);
% cov=covmap(test,test);
% x_x=zeros(5,5);
% sx=zeros(1,5);
% [n,p]=size(x);
% for i=1:n
%     a=x(i,:);
%     sx=sx+a;
%     x_x=x_x+a'*a;
% end
% m=sx/n;
% thisone=ones(n,1);
% thiscov=x_x/20-2*m'*m+(m'*thisone'*thisone*m)/n;

end



