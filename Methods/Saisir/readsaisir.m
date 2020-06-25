function [saisir] = readsaisir(generic,namesize)
%readsaisir			- reads the format of Dominique Bertrand
% Saisir means "statistique appliquée à l'interpretation des spectres infrarouge"
%or "statistics applied to the interpretation of IR spectra' 
% charge les trois fichiers saisir, en formatant les noms
% selon namesize
% usage: [saisir]=readsaisir(fichier, (path),(taille des noms)) 
% saisir est une structure de type i,v,d 
size=10;
if(nargin>1); size=namesize;end;
['i' generic]
[i,nind]=readident(['i' generic], size);
[v,nvar]=readident(['v' generic], size);	
nind;
nvar;
saisir.d=readmatrix(generic,'',nind,nvar);
saisir.i=i;
saisir.v=v;
saisir.nrow=nind;
saisir.ncol=nvar;
