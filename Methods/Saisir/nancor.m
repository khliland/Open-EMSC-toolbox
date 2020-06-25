function[cor]=nancor(x1,x2)
%nancor            - Matrix of correlation with missing data  
%function[cor]=nan_cor(x1,x2)
%the tables must have the same number of rows
%The results is a p1 x p2 matrix (with p1 and p2 the numbers of rows of X1 and X2 respectively)
%An element cor.d(a,b) is the correlation coefficient between the column a of X1 and b of X2
%If cor_cov different from 0, calculates the covariance matrix
%(default :correlation matrix)

if(nargin<3); cor_cov=0; end


[n1,p1]=size(x1.d);
[n2,p2]=size(x2.d);
cor.d=zeros(p1,p2);
for i=1:p1
    for j=1:p2
        aux1=x1.d(:,i);
        aux2=x2.d(:,j);
        miss=isnan(aux1)+isnan(aux2);
        aux1=aux1(miss==0);
        aux2=aux2(miss==0);
        cor.d(i,j)=(aux1-mean(aux1))'*(aux2-mean(aux2))/(std(aux1,1)*std(aux2,1))/size(aux1,1);
    end
end
cor.i=x1.v;
cor.v=x2.v;
