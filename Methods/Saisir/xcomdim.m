function[Q, saliences, explained]=xcomdim(table,threshold,ndim)

%xcomdim				- Finding common dimensions in multitable data
% function[Q, saliences, explained]=xcomdim(col,threshold,ndim)
% Finding common dimensions in multitable according to method 'level3' 
% proposed by E.M. Qannari, I. Wakeling, P. Courcoux and H. J. H. MacFie
% in Food quality and Preference 11 (2000) 151-154
% table is an array of matrices with the same number of row
% threshold (optional): if the difference of fit<threshold then break the iterative loop 
% ndim : number of common dimensions
% default: threshold=1E-10; ndim=number of tables
% returns Q: nrow x ndim the observations loadings
if(nargin<2)
   threshold=1E-10;
end;   
ntable=size(table,2);
if(nargin<3)
   ndim=ntable;
end;   
nrow=size(table{1},1)
W=zeros(ntable+1,nrow,nrow);% average assoc. matrix in last element
prescale=zeros(ntable);
LAMBDA=zeros(ntable,ndim);
Q=zeros(nrow,ndim);

% centring and rescaling the tables ***************************
for(i=1:ntable)
   disp([i ntable]);
   X=table{i};
   average{i}=mean(X);
   table{i}=X-ones(nrow,1)*average{i};
   aux=table{i};
   xnorm=sqrt(sum(sum(aux.*aux)));
   initial_norm(i)= xnorm;
   table{i}=table{i}/xnorm;
   W(i,:,:)=table{i}*table{i}';
   W(ntable+1,:,:)=W(ntable+1,:,:)+W(i,:,:);
end;
% end centring and rescaling	
% main loop
unexplained=ntable; % Warning!: true only because the tables were set to norm=1
for dim=1:ndim
   dim
   previousfit=10000;
   %step a
   lambda=ones(ntable,1);
   %step b
   deltafit=1000000;
   while(deltafit>threshold)
      W(ntable+1,:,:)=zeros(1,nrow,nrow);
      bid=0;
      for ta=1:ntable
			W(ntable+1,:,:)=W(ntable+1,:,:)+lambda(ta)*W(ta,:,:);
      end         
		[UW, SW, VW]=svd(reshape(W(ntable+1,:,:),nrow,nrow));
		q=UW(:,1);
      fit=0;
      for ta=1:ntable
         % estimating residuals
         lambda(ta)=q'*reshape(W(ta,:,:),nrow,nrow)*q;  
         aux=reshape(W(ta,:,:),nrow,nrow)-lambda(ta)*q*q';
		  	fit=fit+sum(sum(aux.*aux));   
      end
      deltafit=previousfit-fit;
      previousfit=fit;
   end %deltafit>threshold      
   fit
   explained(dim)=(unexplained-fit)/ntable*100;
   unexplained=fit;
   LAMBDA(:,dim)=lambda;
   Q(:,dim)=q;
% updating residuals   
	aux=eye(nrow,nrow)-q*q';
	for ta=1:ntable
		table{ta}=aux*table{ta};
		W(ta,:,:)=table{ta}*table{ta}';
   end				      
end
aux1=0;
aux2=0;
saliences=LAMBDA;
