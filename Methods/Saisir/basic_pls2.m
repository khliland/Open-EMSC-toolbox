function res1=basic_pls2(x,y,maxdim)
%basic_pls2            - PLS2 on several variables, several dimensions
%function result=basic_pls2(x,y,maxdim)
% returns result.T : the latent variables
%result.res: cells corresponding to each final predicted variable
X=x.d;
Y=y.d;
[n p2]=size(X);
[n p1]=size(Y);
ybar=mean(Y);
xbar=mean(X);
X=X-ones(n,1)*xbar;
Xkept=X;
Y=Y-ones(n,1)*ybar;    
Ykept=Y;
R=eye(size(X,2));
I=R;
BET=zeros(p2,p1,maxdim);
previous=BET(:,:,1);

NormStartX=sum(sum(X.*X));
NormStartY=sum(sum(Y.*Y));

for i=1:maxdim
    XY=X'*Y;      
    [u,s,v]=svd(XY,0);    
    w=u(:,1);
    W.d(:,i)=w; % ako: store the orthogonal loading weights
    t=X*w;
   	T.d(:,i)=t;	 % common scores  
    e=t'*t;  % norm of t
    c=Y'*t/e;  % calculate the loadings of y
    C.d(:,i)=c  % ako: store the loadings of y
    u=Y*c/(c'*c); %calculate the individual scores of Y
    U.d(:,i)=u;  % ako: store the individual scores of Y
    p=X'*t/e;  % calculate the loadings of X
    P.d(:,i)=p; % ako: store the loadings of X
    z=X*p/(p'*p); % ako calculate the individual scores of X
    Z.d(:,i)=z;  % ako: store the individual scores of X
    disp([i u'*t]); 
    temp=I-w*p';%% Keeping linear transformation on X: this step
    beta=R*w*c';%OK2
    BET(:,:,i)=beta+previous;
    
    Xhut=t*p';  % ako
    Yhut=t*c';  % ako
    NormX=sum(sum(Xhut.*Xhut));
    NormY=sum(sum(Yhut.*Yhut));
    ExVarX(i)=100*NormX/NormStartX;
    ExVarY(i)=100*NormY/NormStartY;
    
    X=X-t*p';  % ako: deflation of X
    Y=Y-t*c';  % ako: deflation of Y
    proj(:,i)=R*w;
    R=R*temp;% Keeping linear transformation on X: all the steps
    previous=BET(:,:,i);
    
end





temp=[];
for var=1:p1
    temp.d=reshape(BET(:,var,:),p2,maxdim);
    temp.i=x.i;
    temp.v=num2str((1:maxdim)');
    res{var}.nom=y.v(var,:);
    res{var}.BETA=temp;
    temp1.d=ybar(var)*ones(1,maxdim)-xbar*temp.d;
    temp1.i='Constant';
    temp1.v=temp.v;
    res{var}.BETA0=temp1;
    temp3.d=x.d*temp.d + ones(n,1)*temp1.d;
    temp3.i=y.i;
    temp3.v=temp.v;
    res{var}.PREDY=temp3;
    delta=y.d(:,var)*ones(1,maxdim)-temp3.d;
    temp4.d=sqrt(sum(delta.*delta)/n);
    temp4.i='Root mean square error of calibration';
    temp4.v=temp.v;
    res{var}.RMSEC=temp4;
    this_y=selectcol(y,var);
    temp5=cormap(this_y,res{var}.PREDY);
    temp5.d=temp5.d.*temp5.d;%% here error in previous version corrected 16/6/2005 !!!!!
    res{var}.r2=temp5;
end
T.i=x.i;
T.v=temp.v;
res1.res=res;
res1.T=T;
res1.loadings.d=proj;
res1.loadings.i=x.v;
res1.loadings.v=num2str((1:maxdim)');
% ako
res1.U=U;
res1.U.i=x.i;;
res1.U.v=temp.v;
res1.Z=Z;
res1.Z.i=x.i;;
res1.Z.v=temp.v;
res1.W=W;
res1.W.i=x.v;
res1.W.v=num2str((1:maxdim)');
res1.P=P;
res1.P.i=x.v;
res1.P.v=num2str((1:maxdim)');
res1.C=C; % loadings of y to be finished

res1.ExVarX=ExVarX;
res1.ExVarY=ExVarY;

% end of akos changes
res1.meanx=saisir_mean(x);





