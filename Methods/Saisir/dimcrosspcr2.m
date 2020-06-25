function[pcrres]=dimcrosspcr2(x,y,dimmax,nverif)
%dimcrosspcr2 			- PCR with cross validation on randomly selected samples
%  function [pcrres]=dimcrosspcr2(x,y,dimmax,nverif)
%  dimmax= max number of PCR dimension;
%  nverif number of samples in verification set
%  components introduced in the order of the eigenvalues 
%  Only one test
pcrres=dimcrosspcr1(x,y,dimmax,random_select(size(x.d,1),nverif));