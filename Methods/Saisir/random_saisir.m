function[saisir]=random_saisir(nrow,ncol)
%random_saisir				- Creation of a random matrix

aux=rand(nrow,ncol);
saisir=matrix2saisir(aux,'r','c');