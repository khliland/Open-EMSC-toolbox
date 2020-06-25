function[res]  = basic_pls(saisirx,saisiry,K)
%basic_pls        - basic pls with keeping loadings and scores 
%function[res]  = basic_pls(X,y,ndim)
%A single y and 1 to ndim dimensions 
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
    c1=t'*t;
    p=X'*(t/c1);
    P(:,i)=p;
    q=(y'*t)/c1;
    Q(i,1)=q;
    X=X-t*p';
    y=y-q*t;
 	T(:,i)=t;	   
    %%Directly assessing BETA       
    XBETA(:,i)=R*w*q+previous;
    proj(:,i)=R*w;
    R=R*(I-w*p');
    previous=XBETA(:,i);
    % p*p p*1 1x1 
end
%Tessai=keptX*proj;
%delta=Tessai-T;
%'somme1'
%sum(sum(delta.*delta))
%pause
b=W*((P'*W)\Q);% obsolete
res.T.d=T;
res.T.v=num2str((1:K)');
res.T.i=saisirx.i;
res.P.d=P';% P seen as pure spectra
res.P.i=num2str((1:K)');
res.P.v=saisirx.v; 
res.beta.d=b;%% obsolete
res.beta.v=saisirx.v;% obsolete
res.beta.i=[ 'Model with ' num2str(K) ' dimensions']; 
res.beta0.d=meany-meanx*res.beta.d;
res.beta0.i='beta0';% obsolete
res.beta0.v='beta0';% obsolete
res.meanx.d=meanx;
res.meanx.i='Average of X';
res.meanx.v=saisirx.v;
res.meany.d=meany;
res.meany.i='Average of y';
res.meany.v=saisiry.v;
%res.predy.d=keptX*res.beta.d +ones(sizex(1),1)*meany;
res.predy.d=saisirx.d*res.beta.d +res.beta0.d;% obsolete
res.predy.v=['Predicted y with ' num2str(K) ' dimensions'];% obsolete
res.predy.i=saisirx.i;
res.error.d= std(res.predy.d-saisiry.d,1);
res.error.i=['Standard error with ' num2str(K) ' dimensions'];
res.error.v=['Standard error with ' num2str(K) ' dimensions'];
cor=cormap(res.predy,saisiry);
res.corcoef.d=cor.d(1);
res.corcoef.i=['Correlation coefficient with ' num2str(K) ' dimensions'];;
res.corcoef.v=['Correlation coefficient with ' num2str(K) ' dimensions'];;
res.BETA.d=XBETA;
res.BETA.i=saisirx.v;
res.BETA.v=num2str((1:K)');
res.BETA0.d=meany-meanx*res.BETA.d;
res.BETA0.v=res.BETA.v;
res.BETA0.i='Constant';
res.loadings.d=proj;
res.loadings.v=res.BETA.v;
res.loadings.i=saisirx.v;
res.Q.d=Q;
res.Q.i=res.BETA.v;
res.Q.v='Coeff of regression using T';
res.PREDY.d=saisirx.d*res.BETA.d+ ones(sizex(1),1)*res.BETA0.d;
res.PREDY.i=saisiry.i;
res.PREDY.v=[res.BETA.v char(ones(K,1)*saisiry.v(1,:))];
delta=(saisiry.d*ones(1,K)-res.PREDY.d);
res.RMSEC.d=sqrt(sum(delta.*delta)/sizex(1));
res.RMSEC.i='Root mean square error of calibration';
res.RMSEC.v=res.BETA.v;
res.r2=cormap(saisiry,res.PREDY);
res.r2.d=res.r2.d.*res.r2.d;
