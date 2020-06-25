function res=mfa(col);
%mfa             - Multiple factor analysis
%function res=mfa(collection);
%collection : ARRAY OF CELL of SAISIR structure
%example of building a collection : collection col{1}=table1;col{2}=table2; col{3}=table3
%in which table1, table2, table are SAISIR structure
%NOTE HERE THE USE OF {} (ACCOLADE)  AND NOT () (BRACKET); 
%Each table must include the same observations, but not necessarily the same variables.
%WARNING! In this version, the variables are not normalised ! 
% 
%Let n be the number of observations, and t the number of tables
%Let WHOLE be the matrix of appended tables normalized according to MFA (dimensions n x m) 
%Let k be the rank of WHOLE
%
%Fields of the output           :  
%===============================
%   score (n x k)               : scores of the individuals (compromise)
%   eigenvec ( m x k)           : eigenvectors of the PCA on WHOLE (no direct use)
%   eigenval (1 x k)            : eigenvalues of the PCA on WHOLE 
%   average (1 x m)             : averages of the variables of WHOLE  
%   var_score (m x k)           : scores of the variables 
%   proj {1xt cell}             : projectors for computing the projection of new observations of each table 
%   first_eigenval (1xt)        : first eigenvalues of the individual PCAS on each table
%   trajectory   (q x k) : individual score of each row of each table (q = total number of rows in all the tables) 
%   id_group            (q x 1) : identification of the belonging of the observation_score into a given table
%   table_score (t x k)         : scores of the tables 
% Information on FMA can be found in SPAD TM Version 5.0 (procédure AFMUL);

ntable=size(col,2);
for i=1:ntable
   chaine=['t' num2str(i) '             '];
   table_name(i,:)=chaine(1:3);
end

obs_name=col{1}.i;% the identifiers of the first table taken as observation name
code_table=[];
code_table1=[];

for i=1:ntable
    aux=col{i};
    this_pca=pca(aux);
    eigenval(i)=this_pca.eigenval.d(1);%% this is the very core of mfa
    [n,p]=size(aux.d);
    code_table=[code_table;ones(p,1)*i];%% each variable is numbered from its table 
    code_table1=[code_table1;ones(n,1)*i];%% each observation is numbered from its table
end;
whole.d=[];
id_group.d=[];
aux1=(1:n)';
for i=1:ntable
    aux=col{i};
    [n1,p1]=size(aux.d);
    id_group.d=[id_group.d;aux1];
    whole.d=[whole.d aux.d/sqrt(eigenval(i))];            
    variable{i}=aux.v;
end
whole.i=obs_name;
%variable
%whole.v=
whole.v=[num2str(code_table) char(variable)];
%whole
res=pca(whole);
[n1,p1]=size(whole.d);
res.score.d=res.score.d*sqrt(n1);%% in order to respect the standard mfa presentation
%% equivalent to multiply the elements of the eigenvectors by the square root of the eigenval of the separated first PCAs 
res.var_score=cormap(whole,res.score);
deb=1;
xend=0;
for i=1:ntable
    xend=size(col{i}.d,2)+xend;    
    res.proj{i}=selectrow(res.eigenvec,deb:xend);
    res.proj{i}.d=res.proj{i}.d*ntable;
    deb=xend+1;
end
whole=center(whole);
deb=1;
obs.d=[];
obs.i=[];
deb=1;xend=0;
for i=1:ntable
    xend=size(col{i}.d,2)+xend;    
    this_table=whole.d(:,deb:xend);
    this_proj=this_table*res.proj{i}.d;
    obs.d=[obs.d;this_proj];
    deb=xend+1;
    obs.i=[obs.i; col{i}.i]; 
end
obs.i=[num2str(code_table1) obs.i];%% a number indicating the origin table is added to identifiers

%%computation of table scores
cor=cormap(whole,res.score);
cor.d=cor.d.*cor.d;
for i=1:ntable
aux=selectrow(cor,code_table==i);
aux2(i,:)=nansum(aux.d);%% protection from variables with variance=0;
end
aux2=diag(1./eigenval)*aux2;
res.first_eigenval.d=eigenval;
res.first_eigenval.v=table_name;
res.first_eigenval.i='First eigenvalues of the individual PCA';
res.trajectory=obs;
res.trajectory.v=res.score.v(:,1:10);
res.var_score=cormap(whole,res.score);
res.id_group.i=res.trajectory.i;
res.id_group.v='group of individual identifiers';
res.id_group.d=id_group.d;
res.table_score.d=aux2;
res.table_score.i=table_name;
res.table_score.v=res.score.v;
res.cor=cor;
disp('Maps of observation scores can be obtained using commands such as ''carte_barycentre(res.trajectory,col1,col2, res.id_group)''');