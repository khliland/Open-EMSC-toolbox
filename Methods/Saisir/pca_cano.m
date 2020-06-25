function res=pca_cano(col,ndim,graph);
%pca_cano         - generalized canonical analysis after PCAs on each table  
%function res=pca_cano(col,ndim,graph);
%% ========================================================================
% input argument : 
%col   :array of CELLS containing all the 2-D data tables
%ndim  : dimension of each individual PCA (must be less than the smallest
%number of variables
%graph : if different from 0 : display examples of graph  
%
%fields of the output:
%let n be the number of observations in each table, k the number of tables
%compromise         : PCA giving the compromise 
%observation_score  : scores of each observation of each table (nxk rows)
%id_group           : groups identifying each observation in observation_score (for graph)
%projector          : array of celles giving the vectors allowing the projection of each data set
%table_average      : array of cells giving the average of each original

%Adapted from       : G. Saporta. Probabilités, analyse des données et statistiques.
%                   : Edition Technip, page 192 and followings. 
%% ========================================================================



if(nargin<3)
    graph=0;%% default : no representation
end
    
ntable=size(col,2);
for i=1:ntable
   chaine=['t' num2str(i) '             '];
   table_name(i,:)=chaine(1:10);
end

obs_name=col{1}.i;% the identifiers of the first table taken as observation name
x=[];
previousn=1;
previousp=1;

for(i=1:ntable)
    disp(['Single PCA on table # ' num2str(i)]); 
    p(i)=pca(col{i});    
    aux=p(i).score;
    xcode=num2str1(i,3);
    aux.v=addcode(aux.v,xcode);
    x=appendcol(x, selectcol(aux,1:ndim));
    ave{i}=p(i).average;
    aux=selectcol(p(i).eigenvec,1:ndim);
    [n1,p1]=size(aux.d);
    projector1(previousn:(n1+previousn-1),previousp:(p1+previousp-1))=aux.d;
    previousn=n1+previousn;
    previousp=p1+previousp;
end;
%res.concatened_pca=x;
std1=std(x.d,1);
x=norm_col(x);
res.compromise=pca(x);% 

%%Attempt to find the projection vector from the ORIGINAL data set
x1=[];
for(i=1:ntable)
    x1=appendcol(x1,col{i});
end
[n,p]=size(x1.d);
aux=diag(1./std1)*res.compromise.eigenvec.d;
projector.d=projector1*aux/n;%% final final projector 
clear projector1;
projector.i=x1.v;
size(projector.d)
aux=num2str((1:size(projector.d,2))');
projector.v=addcode(aux,'A');
%res.projector=projector;

%Attempt to project each part and use a barycenter approach 
previousn=1;
[n1,p1]=size(col{1}.d);
aux1=(1:n1)';
clear aux;
observation_score=[];
id_group.d=[];

for table=1:ntable
    id_group.d=[id_group.d;aux1];
    proj{table}=selectrow(projector,previousn:(p1+previousn-1));
    previousn=p1+previousn;
    this_table=col{table};
    x=center(this_table);
    aux.d=x.d*proj{table}.d*ntable;%% to give a scale comparable to the barycenter 
    aux.i=this_table.i;
    aux.v=proj{table}.v;
    aux.i=addcode(aux.i,num2str1(table,2));
    observation_score=appendrow1(observation_score,aux);
end
res.observation_score=observation_score;
id_group.i=res.observation_score.i;
id_group.v='grouping according to observation';
res.id_group=id_group;
res.projector=proj;
res.table_average=ave;
disp('Maps of observation scores can be obtained using commands such as ''carte_barycentre(res.observation_score,col1,col2, res.id_group)''');
if(graph>0)
    carte(res.compromise.score,1,2);
    title('Compromise');
    carte_barycentre(res.observation_score,1,2,res.id_group)
    title('Barycentric presentation');
    figure;
    ellipse_map(res.observation_score,1,2,res.id_group,0,0.05);
    title('Confidence ellipse representation');
end

