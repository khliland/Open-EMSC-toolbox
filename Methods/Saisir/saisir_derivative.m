function [saisir]=saisir_derivative(saisir1,K,F,Dn)
%saisir_derivative      - n-th order derivative using the Savitzky-Golay coefficients
%[saisir]=saisir_derivative(saisir1,polynome_order,window_size,derivative_order)
%example: res=saisir_derivative(x,3,21,2);
%Compute the second derivative using a polynom of power 3 as model
%and a window size of 21

[~,g]=sgolaycoef(K,F);
[nrow,ncol]=size(saisir1.d);
M=zeros(nrow,ncol);
% z=zeros(1,ncol);
% for i=1:nrow
%     y=saisir1.d(i,:);
%     for j =(F+1)/2:ncol-(F-1)/2%Calculate the n-th derivative of the i-th spectrum
%         if Dn==0
%             z(j)=g(:,1)'*y(j - (F+1)/2 + 1: j + (F+1)/2 - 1)';
%         else
%             z(j)=Dn*g(:,Dn+1)'*y(j - (F+1)/2 + 1:j + (F+1)/2 - 1)';
%         end
%     end
%     M(i,:)=z;
% end

F1 = (F+1)/2;
F2 = -F1+1:F1-1;

for j = F1:ncol-(F-1)/2 %Calculate the n-th derivative of the i-th spectrum
    if Dn == 0
        z = saisir1.d(:,j + F2)*g(:,1);
    else
        z = saisir1.d(:,j + F2)*(Dn*g(:,Dn+1));
    end
    M(:,j) = z;
end

saisir.d=M;
saisir.i=saisir1.i;
saisir.v=saisir1.v;




