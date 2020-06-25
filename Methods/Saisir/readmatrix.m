function d = readmatrix(generic,mypath,nind,nvar)
%readmatrix 		- reads a data matrix from file 
% charge le fichier des données de saisir, sous la forme
% d'une matrice unique
%(identificateurs non chargés, pour gagner du temps)
% usage: [d]=readmatrix(generic, (path),(nind),(nvar)) 
aux='\';
chaine1=['i' generic];
chaine2=['v' generic];

switch nargin
case 1,
	currentpath='';
	nind=wc(chaine1);
	nvar=wc(chaine2);
case 2,
	currentpath=[mypath aux];
	nind=wc(chaine1,mypath);
	nvar=wc(chaine2,mypath);
case 3
   ;
case 4
   ;
otherwise
	help readmatrix
 	error('Nombre d''arguments incorrect')
end
if(~isempty(mypath))
	cd(mypath);
end;
file=['D' generic];
%d=load (file,'-ASCII');
file
d=textread(file,'%f');% to be tested on 16 october 2000
[l r]=size(d)
%nvar,nind

if(r~=nvar) d=reshape(d,nvar,nind)';end;
   
 