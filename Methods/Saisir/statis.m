function res=statis(col);
%statis          - Multiway method STATIS
%function res=statis(col);
%The STATIS method is described in "C.Lavit, Analyse conjointe de tableaux qualitatif, Masson pub, 1988."
%Basically the method attempts to establish a factorial compromise between table having
%the same number of observations.
%col is an array of cells containing all the 2-D data tables (SAISIR format).
%Each table must include the same observations, but not necessarily the same variables.
%
%Let n be the number of observations, and t the number of tables
%the field of the outpout argument res are:
%
%-RV: [1x1 struct] matrix t x t of the RV value indicating the agreement
%between the table (max value = 1)
%
%-eigenval1: [1x1 struct] first eigenvalue of the RV matrix
%
%-eigenvec1: [1x1 struct] first eigenvector of the RV matrix (t x 1) . Indicates the
%weight associated with each table
%
%-Wk: {1xt cell} cell of n x n array giving the scalar products between observations
%
%-W_compromise n x n array giving the compromise of the array WK
%
%-eigenval2: [1x1 struct] r eigenvalues of W_compromise, with r the rank of
%W_compromise.
%
%-score: [1x1 struct] (n x r ) Scores of the compromise of the observations. Can be
%represented as factorial map
%
%-trajectory: [1x1 struct] (n*t x r) Projection of each row vector of each table in the space of observation_score
%
%-group: [1x1 struct] (n*t x 1) table giving the belonging of a given
%row_vector to a table
%group is useful with the command 'carte_barycentre'
%For example, a command such as "carte_barycentre(res.trajectory,2,3, res.group)" will produce the representation of 
%the row vector of each table for the score 2 and 3. The representation shows the compromise point and its link
%to each vector of the tables.  
%
%- table_score: [1x1 struct] (t x r) scores of the tables obtained from
%diagonalisation of RV. 
%- table_eigenval: [1x1 struct] (r x 1) eigenvalues of RV . The first one
%is the same as eigenval1


%Version 17 august 2003

ntable=size(col,2);
for i=1:ntable
   chaine=['t' num2str(i) '             '];
   table_name(i,:)=chaine(1:10);
end

obs_name=col{1}.i;% the identifiers of the first table taken as observation name
% centring the tables and assessement of the Wk matrices
for(i=1:ntable)
   x=col{i}.d;
   [nrow ncol]=size(x);
   ave=mean(x);
   %X=(1/nrow)*(x-ones(nrow,1)*ave);
   X=(x-ones(nrow,1)*ave);
   %norm(X,'fro')
   %X=x-ones(nrow,1)*ave;
   Wk=X*X';
   Wk=Wk/norm(Wk,'fro');%% normed objects !!! 
   aux(i,:)=reshape(Wk,1,nrow*nrow);
   WK{i}.d=Wk;
   WK{i}.v=col{i}.i;
   aux1=[num2str(i) '     '];
   aux1=aux1(1:3);
   aux1=char(ones(nrow,1)*aux1);
   %aux1
   WK{i}.i=[aux1 col{i}.i];
end;
%aux1=sqrt(sum(aux'.*aux'));
%size(aux)
%size(aux1'*ones(1,nrow*nrow))
%aux2=aux./(aux1'*ones(1,nrow*nrow));
%RV=aux2*aux2';
RV=aux*aux';
%res=RV;
res.RV.d=RV;
res.RV.i=table_name;
res.RV.v=table_name;
[V,D] = eigs(RV,1);
%V=abs(V);% as the sign of the eigenvector is random
D=abs(D);
V=abs(V);
res.eigenval1.d=D;
res.eigenval1.i='First eigenvalue of RV';
res.eigenval1.v='First eigenvalue of RV';
res.eigenvec1.d=V;
res.eigenvec1.i=table_name;
res.eigenvec1.v='First eigenvector of RV';
res.Wk=WK;
% assessment of the W compromise
%V=V*sqrt(D(1));
aux=WK{1}.d;
W=V(1)*aux;
size(W)
for i=2:ntable
    aux=WK{i}.d;
    W=W+V(i)*aux;
end
W=W/ntable;
res.W_compromise.d=W; 
res.W_compromise.i=obs_name;
res.W_compromise.v=obs_name;
% scores of the tables 
r=rank(W);
[V1,D1] = eigs(W,r);
res.eigenval2.d=diag(D1);
res.eigenval2.v='eigenvalues of W compromise';
res.eigenval2.i=num2str((1:r)');
res.eigenvec2.d=V1;
res.eigenvec2.i=obs_name;
res.eigenvec2.v=res.eigenval2.i;
%size(D1)
res.score.d=W*V1/sqrt(D1);
res.score.i=obs_name;
res.score.v=res.eigenval2.i;
%res.table_score=res.W*V1*(D1);
%assessment of the trajectory of the observation according to the tables
t.d=[];
t.i=[];
g.d=[];
for i=1:ntable
    aux=WK{i}.d;
    aux1=V(i)*aux;
    t.d=[t.d;aux1];
    t.i=[t.i;WK{i}.i;];
    g.d=[g.d; (1:nrow)'];
end
t.d=t.d*V1/sqrt(D1);
t.v=res.eigenval2.i;
res.trajectory=t;
g.i=t.i;
g.v='Rank of the observation';
res.group=g;
%carte_barycentre(t,1,2,g)
disp('Maps of trajectory available using commands such as ''carte_barycentre(res.trajectory,col1,col2, res.group)'''); 
% assessing the factorial map of tables
[V,D]=eig(RV);
[D,index]=sort(-diag(D));
D=-D;
V=V(:,index);
res.table_score.d=V*sqrt(diag(D));
res.table_score.i=table_name;
res.table_score.v=num2str((1:size(V,2))');
res.table_eigenval.d=D;
res.table_eigenval.v='eigenvalues of RV';
res.table_eigenval.i=res.table_score.v;