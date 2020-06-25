function discrimination()
%discrimination 		- List of routines related to discrimination
%Routine related to discrimination available on 16 may 2001
%MAHA
%function[discrtype]=maha(saisir,group,maxvar)
%forward quadratic discriminant analysis, introduction in the order of
%rightly classified calibration sample 
%
%BMAHA
%function[discrtype]=bmaha(saisir,group)
%backward quadratic discriminant analysis, introduction in the order of
%rightly classified calibration sample 
%
%MAHA1
%function[discrtype]=maha1(saisir,group,maxvar,test,testgroup)
%forward quadratic discriminant analysis, introduction in the order of
%rightly classified calibration sample 
%with verification samples 
%
%MAHA3
%function[discrtype]=maha3(saisir,group,maxvar)
%forward LINEAR discriminant analysis, introduction by maximisation of the trace of T-1B
%
%MAHA4
%function[discrtype]=maha4(saisir,group,maxvar)
%forward LINEAR discriminant analysis, by maximisation of the percentage rightly classified
%
%MAHA5
%function[discrtype]=maha5(saisir,group,maxvar, selected)
%forward LINEAR discriminant analysis, by maximisation of the percentage rightly classified
%Like MAHA4, but with test observations 
%
%MAHA6
%function[discrtype]=maha6(saisir,group,maxvar, selected)
%forward LINEAR discriminant analysis, by maximisation of the trace of T-1B
%Like MAHA3, but with test observations 
%
%FDA1
%function[fdatype]=fda1(pcatype, group, among, maxvar)
%forward discrimination on PC scores, introduction by maximisation of the trace of T-1B 
%
%FDA2 
%function[fdatype]=fda2(x,g,among, maxvar,selected)
%forward discrimination on PC scores, introduction by maximisation of the trace of T-1B 
%selected : 1: observations in verification set; 0 : in calibration set
%
%APPYFDA1
%function[res]=applyfda1(saisir,fda1type,actual_group)
%application of fda1 on supplementary observations
%
%CROSSMAHA1
%function[discrtype2]=crossmaha1(saisir,group,among,maxvar,ntest)
%application of maha1 on the score of PCA, dividing the collection in calibration and verif set
%It is quadratic discriminant analysis on score  
%
%CROSSMAHA2
%function[discrtype2]=crossmaha2(saisir,group,among,maxvar,ntest,nrepeat)
%application of maha1 on the score of PCA, dividing the collection in calibration and verif set
%It is quadratic discriminant analysis on score  
%differences between crossmaha1 and crossmaha2 is only the way of
%selecting verification samples.

%PLSDA
%function[type]=plsda(x,group,ndim)
%Assess PLS discriminant model in the more standard ways.

%APPLYPLSDA
%function[pred]=applyplsda(x,model)
%apply the PLS discriminant analysis models (obtained from function PLSDA)
%on unknown data

%CROSSPLSDA cross-validation on PLS discriminant analysis
%function[res]=crossplsda(x,group,dim,selected)
%selected is a VECTOR with 0= calibration sample, 1= verification sample

edit discrimination
