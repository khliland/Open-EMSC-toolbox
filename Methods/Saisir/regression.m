%regression     - list of methods related to regression 
% SAISIRPLS
% function [plstype]=saisirpls(x,y,dim)
% assess a pls1 model on files following the saisir format
% returns plstype.beta, plstype.beta0,plstype.predy
% "dim" models are calculated
% 
% APPLYPLS		apply a pls model on an unknown data set
% function [predy]=applypls(x,plsmodel)
% apply a pls1 model on files following the saisir format
% plsmodel is the structure obtained from saisirpls 
% returns saisir predy  
% As many prediction as "dim" in saisirpls
% 
% CROSSVALPLS1			-crossvalidation of pls with ndim dimensions. 
% function [predy,obsy,rmsecv,corr]=crossvalpls1(x,y,ndim,inval,ntest)
% ndim= PLS dimension; inval: number of observations in cross-validation
% RANDOMLY SELECTED
% ntest: number of independant test 
% return predicted y in cross validation
% returns also rmsecv the root mean square error of crossvalidation and corr the correlation
% coefficient
% 
% CROSSVALPLS1a			-crossvalidation of pls with ndim dimensions. 
% function [predy,obsy,rmsecv,corr]=crossvalpls1a(x,y,ndim,selected)
% ndim= PLS dimension; inval: number of observations in cross-validation
% Performs a single crossvalidation test. "selected" is a vector  
% giving the samples in verification set. 1= in verification; 0 = in calibration set 
% return predicted y and observed y in cross validation
% returns also rmsecv the root mean square error of crossvalidation and corr the correlation
% coefficient
% ONLY results of crossvalidation with ndim dimensions
% 
% DIMCROSSPLS1 		- crossvalidation of PLS (changing the dimensions)
% function [plsres]=dimcrosspls1(x,y,dimmax,inval,ntest)
% dimmax= max number of PLS dimension;
% inval: number of observations randomy selected in cross-validation at each step
% returns rmsecv,corr
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both predy and rmsecv are saisir files
% results with up to dimmax dimensions, by cumulating the results from ntest
% (and nval samples in each test)
% 
% DIMCROSSPLS1a 		- crossvalidation of PLS (changing the dimensions)
% function [plsres]=dimcrosspls1a(x,y,dimmax,selected)
% dimmax= max number of PLS dimension;
% "selected": vector giving the samples in validation. 1: in validation; 0 in calibration
% returns rmsecv,corr as a function of the number of introduced components
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both predy and rmsecv are saisir files
% results with up to dimmax dimensions, in a single corss-validation test
% 
% =====================================================================================
% PCR 		-assess a basic model of PCR (components introduced in the order of eigenvalues)
% function [pcrtype]=pcr(x,y,maxdim)
% assess a basic pcr model on files following the saisir format
% returns pcrtype: pca, beta, predy, correlation coeff with 1 to maxdim elements, averagey  
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
% 
% APPLYPCR 		- assesses a basic PCR on data  
% function [predy]=applypcr(pcrtype,x)
% apply a basic pcr (in pcrtype) on saisir data x
% creates as many y predicted as allowed by the dimensions in pcrtype
% 
% SPCR				-stepwise Principal component regression
% function [spcrtype]=spcr(x,y,maxdim, (maxrank))
% assess a pcr model on files following the saisir format
% returns spcrtype: pca, beta, selected_component, predy, 
% correlation coeff with 1 to maxdim elements, averagey  
% Model with selection of components 
% which are introduced in the order of their partial coefficient with y
% maxdim: maximal number of components in the model
% maxrank: maximal rank of the components possibly introduced in the model (the components
% of higher rank are not considered). Default value: all components possibly introduced.  
% 
% APPLYSPCR		-apply a stepwise PCR
% function [predy]=applyspcr(spcrtype,x)
% apply a pcr with selection (in spcrtype) on saisir data x
% creates as many y predicted as allowed by the dimensions in pcrtype
% 
% SDIMCROSSPCR		-crossvalidation of stepwise PCR (changing dimensions) 
% function [spcrres]=sdimcrosspcr(x,y,dimmax,maxrank,inval)
% dimmax= max number of components in the model;
% maxrank maximum rank of the considered components
% inval: number of observations (in sequence) in cross-validation at each step
% returns predy,rmsecv,corr
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both predy and rmsecv are saisir files
% 
% SDIMCROSSPCR1			- crossvalidation of stepwisePCR 
% (samples in validation are selected) 
% function [pcrres]=sdimcrosspcr1(x,y,dimmax,maxrank,selected)
% dimmax= max number of PCR dimension;
% selected: vector of samples selected as calibration set (==0)
% and verification set (==1)
% returns predy,rmsecv,corr
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both predy and rmsecv are saisir files
% 
% DIMCROSSPCR1			- crossvalidation of PCR (samples in validation are selected) 
% function [pcrres]=dimcrosspcr1(x,y,dimmax,selected)
% dimmax= max number of PCR dimension;
% selected: vector of samples selected as calibration set (==0)
% and verification set (==1)
% returns predy,rmsecv,corr
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both predy and rmsecv are saisir files
% components introduced in the order of the eigenvalues
% 
% DIMCROSSPCR2 			assess a PCR with cross validation on randomly selected samples
% function [pcrres]=dimcrosspcr2(x,y,dimmax,nverif)
% dimmax= max number of PCR dimension;
% nverif number of samples in verification set
% components introduced in the order of the eigenvalues 
% Only one test
% 
% ===================================================================================
% WARNING! BEST RESULTS WITH LRR1 !!!!!
% LR1			-assesses a Latent root 1 model  
% function [lr1type]=lr1(x,y,maxdim,ratioxy)
% assess a basic lr1 model on files following the saisir format
% returns lr1type
% first trial on 3/12/99
% returns the individual predictors and the y predicted with 1 to maxdim latent variables  
% best choice obtained from a weighted sum of the predicted y according to Vigneau et al. 
% ratioxy(optional): positive number greater than 0 less than 1
% giving the relative importance of x and y. 1: x important; 0 x not important
% default : 0.5 (x and y have the same importance)
% 
% APPLYLR1         - Apply basic latent root model on saisir data x
% function [predy]=applylr1(lr1type,x)
% creates as many y predicted as allowed by the dimensions in lr1type
% 
% APPLYLR2      - apply Latent root model 2 on saisir data x
% function [predy]=applylr2(lr2type,x)
% apply a basic latent root model (in lr2type) on saisir data x
% creates as many y predicted as allowed by the dimensions in lr2type
% 
% APPLYLR3     - apply latent root 3 model on saisir data x
% function[predy]=applylr3(xcal, ycal, x, stop_level, dim) 
% apply a latent root model using a "missing data" approach
% xcal, ycal : x and y values of the calibration set
% x : x values on which y must be predicted
% stop_level: when the absolute difference on y obtained from two iterations is less than 
% stop_level, the iterative step is ended
% dim number of components involved in the model
% 
% DIMCROSSLR1a 					-cross validation of latent root model LRR1 
% function[lr1res]=dimcrosslr1a(x,y,dimmax,selected,ratioxy)
% dimmax= max number of lr dimension;
% selected: number of observations selected in verification set (=1)
% ratioxy: importance given to x (norm of x divided by this ratio. default:1 ) 
% returns rmsecv,corr
% rmsecv is the root mean square error of crossvalidation
% y must contain a single variable! 
% both corr and rmsecv are saisir files
% 
% =========================================================================================
% RIDGE_REGRESSION 		-assess a basic ridge regression
% function [ridgetype]=ridge_regression(x,y,krange)
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
% return as many beta as the number of elements in krange
% ridge_regression 		-assess a basic ridge regression
% 
% APPLY_RIDGE_REGRESSION      - apply ridge regression on "unknown data"
% function[res]=apply_ridge_regression(ridgetype,x,(y))
% if y is given, the verification stats (RMSECV are also assessed)
% 
% CROSS_RIDGE_REGRESSION		ridge regression with crossvalidation 
% divide a collection in calibration and verification set
% apply ridge_regression on the validation set
% function[res]=cross_ridge_regression(x,y,krange,selected)
% function[res]=cross_ridge_regression(x,y,krange,selected)
% 
% PCA_RIDGE_REGRESSION		assess a basic ridge regression after PCA
% ONLY ONE VARIABLE TO BE PREDICTED (scan the dimensions)
% return as many beta as the number of elements in range
% warning! range is NOT a range of kvalue
% it is a rank of a component.
% k is in fact the eigenvalue of this component
% 
% PCA_CROSS_RIDGE_REGRESSION		PCA ridge regression with crossvalidation 
% divide a collection in calibration and verification set
% apply ridge_regression on the validation set
% some trick about range (which is the cutting component)
% 
% =========================================================================================
% XRMCPCA			Method proposed to chemolab
% function res=xrmcpca(X0,Y0,X0test,Y0test,m,alpha,maxdim)
% XO, Y0: calibration samples, X0test, Y0test: validation sample
% alpha : weight of Y; (1-alpha: weight on X)
% maxdim: dimensions of the model
% function regression model through Constrained Principal Components Analysis
% Work with Evelyne Vigneau and Mostafa Qannari 19/12/2001
% returns in structure res:
% pourx: proportion of calibration x explained
% poury: proportion of calibration y explained
% beta: [1x1 struct] beta coefficients for predicting Y 
% gamma: [1x1 struct] beta coefficients for predicting X
% MSRX: Mean square residual error on verification X
% MSRY: Mean square residual error on verification Y
% ypred: [1x1 struct] predicted verification Y
% xpred: [1x1 struct] predicted verification X
% =========================================================================================
% STEPWISE_REGRESSION 				- stepwise regression between x and y
% function[type]=stepwise_regression(x,y,Pthres,(confidence),(xval),(yval))
% P is the probability threshold for entering or discarding a variable
% confidence (default=0.05) is the probability of the confidence interval
% for the limit of the regression coefficients
% 
% APPLY_STEPWISE_REGRESSION				apply stepwise_regression on "unknown" data
% Using the models (in "type") as returned by stepwise_regression
% build as many models as available in "type"
% function[res]=apply_stepwise_regression("type",x,(y))
% 
% 
edit regression