function res = anovan1(saisir,model,varargin)
%anovan1           -  N-way analysis of variance (ANOVA) on data matrices.
%function res = anovan1(X,model,gr1, gr2, ...)
%Performs as many N-way analyses of variance as the number of columns in X
%X: matrix of response values
%model: see ANOVAN, gives the level of desired interactions
%(1= no interactions studied; 2: first degree of interactions ... )
%gr1; gr2 ... (variable number of arguments): qualitative groups 
%forming a factor of the ANOVA
%The function returns: res.F the F value associated with each effect and
%interaction
%res.P: probability
%res.df (characters): degrees of freedom
%res.singular: singularity of the model. If the singularity == 1, the model
%is redundant and a lowest level of interaction must be tested. 
%see also: ANOVAN, ANOVA, ANAVAR1 
%SAISIR FUNCTION


[a,nfactor]=size(varargin);
for i=1:nfactor
factor{i}=varargin{i}.d;
end
%sum(factor{1})
%sum(factor{2})
[n,p]=size(saisir.d);
[P,resu]=anovan(saisir.d(:,1),factor,model,3,[],'off');
nlig=size(resu,1);

%     Source'    'Sum Sq.'    'd.f.'    'Singular?'    'Mean Sq.'    'F'       
%     'X1'        [ 7.1462]    [   5]    [        0]    [  1.4292]    [230.4472]
%     'X2'        [ 2.7299]    [   5]    [        0]    [  0.5460]    [ 88.0315]'Prob>F'
%     'Error'     [ 6.5432]    [1055]    [        0]    [  0.0062]            []
%     'Total'     [17.5739]    [1065]    [        0]            []            []
disp('entering loop');
for i=1:p
    if(mod(i,100)==0)
        disp(i);
    end
    [P,resu]=anovan(saisir.d(:,i),factor,model,3,[],'off');
    k=0;
    for j=2:nlig-2
        k=k+1;
        res.F.d(k,i)=resu{j,6};
        res.P.d(k,i)=resu{j,7};
    end
end
res.F.v=saisir.v;
res.P.i=saisir.v;
k=0;
for j=2:nlig-2
    k=k+1;
    aux1{k}=resu{j,1};        
    aux2{k}=[num2str(resu{j,3}) '/' num2str(resu{nlig-1,3})]; 
    aux3(k)=resu{j,4};
end
res.F.i=char(aux1);
res.P.i=char(aux1);
res.P.v=saisir.v;
res.df=char(aux2);
res.singular.d=aux3';
res.singular.v='singular no=0/yes=1';
res.singular.i=char(aux1);
% res.intens=res.F;
% res.intens.d=-log(res.P.d);