function[res]  = basic_pls1(saisirx,saisiry,K)
%basic_pls1          - basic pls with keeping loadings and scores 
%function[res]  = basic_pls(X,y,ndim)
%Only the final beta (with ndim dimensions) is given 
%A single y and a single (final) dimension 
meanx=mean(saisirx.d);
meany=mean(saisiry.d);
sizex=size(saisirx.d);
X=saisirx.d-ones(sizex(1),1)*meanx;
y=saisiry.d-ones(sizex(1),1)*meany;
keptX=X;
W=zeros(sizex(2),K);
P=zeros(sizex(2),K);
T=zeros(sizex(1),K);
Q=zeros(K,1);
R=eye(sizex(2),sizex(2));
I=R;
previous=zeros(sizex(2),1);
for i = 1:K
    disp([num2str(i) ' dimensions among ' num2str(K)]);
    w=X'*y;
    w=w/sqrt(w'*w);
    W(:,i)=w;
    t=X*w;
    c=t'*t;
    p=X'*(t/c);
    P(:,i)=p;
    q=(y'*t)/c;
    Q(i,1)=q;
    X=X-t*p';
    y=y-q*t;
 	T(:,i)=t;	   
    %%trying to directly assess BETA       
    BETA(:,i)=R*w*q+previous;
    R=R*(I-w*p');
    previous=BETA(:,i);
    % p*p p*1 1x1 
end
b=W*((P'*W)\Q);
res.T.d=T;
res.T.v=num2str((1:K)');
res.T.i=saisirx.i;
res.P.d=P';% P seen as pure spectra
res.P.i=num2str((1:K)');
res.P.v=saisirx.v; 
res.beta.d=b;%
res.beta.v=saisirx.v;
res.beta.i=[ 'Model with ' num2str(K) ' dimensions']; 
res.beta0.d=meany-meanx*res.beta.d;
res.beta0.i='beta0';
res.beta0.v='beta0';
res.meanx.d=meanx;
res.meanx.i='Average of X';
res.meanx.v=saisirx.v;
res.meany.d=meany;
res.meany.i='Average of y';
res.meany.v=saisiry.v;
%res.predy.d=keptX*res.beta.d +ones(sizex(1),1)*meany;
res.predy.d=saisirx.d*res.beta.d +res.beta0.d;
res.predy.v=['Predicted y with ' num2str(K) ' dimensions'];
res.predy.i=saisirx.i;
res.error.d= std(res.predy.d-saisiry.d,1);
res.error.i=['Standard error with ' num2str(K) ' dimensions'];
res.error.v=['Standard error with ' num2str(K) ' dimensions'];
cor=cormap(res.predy,saisiry);
res.corcoef.d=cor.d(1);
res.corcoef.i=['Correlation coefficient with ' num2str(K) ' dimensions'];;
res.corcoef.v=['Correlation coefficient with ' num2str(K) ' dimensions'];;
res.BETA.d=BETA;
res.BETA.i=saisirx.v;
res.BETA.v=num2str((1:K)');
res.BETA0.d=meany-meanx*res.BETA.d;
res.BETA0.v=res.BETA.v;
res.BETA0.i='Constant';
res.PREDY.d=saisirx.d*res.BETA.d+ ones(sizex(1),1)*res.BETA0.d;
res.PREDY.i=saisiry.i;
res.PREDY.v=[res.BETA.v char(ones(K,1)*saisiry.v(1,:))];
delta=(saisiry.d*ones(1,K)-res.PREDY.d);
res.RMSEC.d=sqrt(sum(delta.*delta)/sizex(1));
res.RMSEC.i='Root mean square error of calibration';
res.RMSEC.v=res.BETA.v;
res.r2=cormap(saisiry,res.PREDY);
res.r2.d=res.r2.d.*res.r2.d;