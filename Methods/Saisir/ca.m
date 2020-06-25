function ca_type=ca(N);
%ca         - CORRESPONDENCE ANALYSIS
%function ca_type=ca(N);
%Compute correspondence analysis from the contingency table in N 
%If only groupings are available, the contigency table must be computed 
%before using this function (see for example function "contingency_table")
%
% ==============================================================
%Fields of the output
%score          :CA scores of rows followed by CA scores of columns
%eigenval       :eigenvalues, percentage of inertia, cumulated percentage
%contribution   :contribution to the component rows, then columns
%squared_cos    :squared cosinus row, then columns
%khi2           :khi2 of the contingency table
%df             :degree of freedom 
%probability    :probability of random values in contigency table
% ==============================================================
%
%The identifiers of rows of 'score' (whic are the identifiers of rows and columns of N (N.i and N.v) 
%are preceded with the letter 'r' or 'c'. 
%It is therefore possible to use color for emphazising row and columns in
%the simultaneous biplot of rows and columns   
%
%Source         : G. Saporta. Probabilités, analyse des données et statistiques.
%               : Edition Technip, page 198 and followings. 
%REMARK : use function "ca_map" to plot the biplot observation/variable



[n,p]=size(N.d);
transpose_flag=0;
if(n<p)%% working on the more convenient matrix
    transpose_flag=1;
    N=saisir_transpose(N);
    [n,p]=size(N.d);
end

D2=sum(N.d,1);
D1=sum(N.d,2);
tot=sum(sum(N.d));

D1_1=diag(1./D1);
D2_1=diag(1./D2);

aux=D2_1*N.d'*D1_1*N.d;
%%[U,S,V] = svd(aux);
[V,D] = eig(aux);

% Warning function eig does not sort the eigenvalues and eigenvectors!!

[eigenval.d, index]=sort(-abs(diag(D)'));% eigenvalues in increasing order!
eigenval.d=-eigenval.d(2:end); % removing trivial eigenvalue
eigenval.i='eigenvalues';
eigenvec.d=V(:,index);
eigenvec.d(:,1)=[];% removing trivial eigenvector

%% computing score for factorial representation
r=sqrt(1./diag((eigenvec.d'*diag(D2)*eigenvec.d)/tot));%Normalizing factor (see Saporta , page 204));
r=diag(r)*diag(sqrt(eigenval.d));
column_score.d=eigenvec.d*r;
row_score.d=D1_1*N.d*column_score.d*diag(1./sqrt(eigenval.d));
row_score.i=N.i;
column_score.i=N.v;
[n,p]=size(row_score.d);
row_score.v=addcode(num2str((1:p)'),'PC#');
column_score.v=row_score.v;
column_score.i=addcode(column_score.i,'c');
row_score.i=addcode(row_score.i,'r');
if(transpose_flag==0)
    score=appendrow(row_score,column_score);
else
    score=appendrow(column_score,row_score);
end    
ca_type.score=score;% a single saisir file by merging scores of rows and columns

%%assessing contributions
row_contribution.d=diag(D1)*row_score.d.*row_score.d*diag(1./(eigenval.d))/tot
row_contribution.i=N.i;
row_contribution.v=row_score.v;

column_contribution.d=diag(D2)*column_score.d.*column_score.d*diag(1./(eigenval.d))/tot
column_contribution.i=N.v;
column_contribution.v=column_score.v;

%%computing squared cos 
aux=score.d.*score.d;
norm2=sum(aux,2);
squared_cos.d=diag(1./norm2)*aux;
squared_cos.i=score.i;
squared_cos.v=score.v;

%computing cumulated eigenvalues and inertia
clear aux;
aux(1)=eigenval.d(1);
for i=2:p
    aux(i)=aux(i-1)+eigenval.d(i);
end
khi2=sum(eigenval.d)*tot;


eigenval.d=[eigenval.d;eigenval.d/aux(p);aux/aux(p)];

eigenval.i=char({'eigenvalues';'percentage of inertia';'percentage of cumulated inertia'});
eigenval.v=row_score.v;
ca_type.eigenval=eigenval;
if(transpose_flag==0)
    ca_type.contribution=appendrow(row_contribution,column_contribution);
else
    ca_type.contribution=appendrow(column_contribution,row_contribution);
end
ca_type.squared_cos=squared_cos;
ca_type.khi2.d=khi2;
ca_type.khi2.i='Khi2 value of the contingency table';
ca_type.khi2.v='Khi2 value of the contingency table';

[n,p]=size(N.d);
df.d=(n-1)*(p-1);
df.i='degree of freedom';
df.v='degree of freedom';
P.d=(1-chi2cdf(ca_type.khi2.d,df.d));
P.i='Probability';
P.v='Probability';
ca_type.df=df;
ca_type.probability=P;

%% Warning remark: there is an error in the mentionned book concerning the SQUARED
%% cosinus. The figures given page 209 are the cosinus themselves.
%% the second column in table 10.5 and 10.6 are indeed
%% sqrt(cos2(PC#1)+cos2(PC#2)), which is the cosinus value to the first
%% factorial plan