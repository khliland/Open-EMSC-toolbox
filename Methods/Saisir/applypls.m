function res=applypls(x,plsmodel, knowny)
%applypls		- applies a pls model on an unknown data set
%function res=applypls(x,plsmodel, knowny)
%	apply a pls1 model on files following the saisir format
%	plsmodel is the structure obtained from saisirpls, basic_pls or basic_pls2 
if(~isfield(plsmodel,'BETA'))
    predy.d= x.d*plsmodel.beta.d+ones(size(x.d,1),1)*plsmodel.beta0.d;
    predy.i=x.i;
    predy.v='predicted y';
    res.predy=predy;
%    if((nargin>2)&(size(knowny.d,1)>1))% avoiding assessing RMSEV and r2 with a single unknown obs 
    if((nargin>2))   % changed by ako for CV
      delta=(knowny.d*ones(1,size(plsmodel.beta.d,2))-res.predy.d);
      res.RMSEV.v=plsmodel.beta.v;
      res.RMSEV.d=sqrt(sum(delta.*delta)/size(knowny.d,1));
      res.RMSEV.i='Root mean square error of validation';
      res.r2=cormap(knowny,res.predy);    
      res.r2.d=res.r2.d.*res.r2.d;
      res.r2.i='r2 of observed/predicted y';
  end
end
%applypls is also applicable with models obtained with cpls

if(isfield(plsmodel,'BETA'))
  PREDY.d=x.d*plsmodel.BETA.d+ ones(size(x.d,1),1)*plsmodel.BETA0.d;
  PREDY.v=plsmodel.PREDY.v;
  PREDY.i=x.i;
  res.PREDY=PREDY;
%  if((nargin>2)&(size(knowny.d,1)>1))% avoiding assessing RMSEV and r2 with a single unknown obs
  if((nargin>2))   % changed by ako for CV
      delta=(knowny.d*ones(1,size(plsmodel.BETA.d,2))-res.PREDY.d);
      res.RMSEV.v=plsmodel.BETA.v;
      res.RMSEV.d=sqrt(sum(delta.*delta)/size(knowny.d,1));
      res.RMSEV.i='Root mean square error of validation';
      res.r2=cormap(knowny,res.PREDY);    
      res.r2.d=res.r2.d.*res.r2.d;
      res.r2.i='r2 of observed/predicted y';
  end
end
[n,p]=size(x.d);
if(isfield(plsmodel,'loadings'))%% if the methods gives the loadings, the T values of supppementary set are assessed
centred=x.d-ones(n,1)*plsmodel.meanx.d;
T.d=centred*plsmodel.loadings.d;
T.i=x.i;
T.v=plsmodel.loadings.v;
res.T=T;
end
