function [saisir] = matrix2saisir(data,coderow,codecol)
%matrix2saisir 	- transforms a Matlab matrix in a saisir structure
%[saisir] = matrix2saisir(data,coderow,codecol)
% Saisir means "statistique appliquée à l'interpretation des spectres infrarouge"
%or "statistics applied to the interpretation of IR spectra' 
% coderow or codecol indicates the caracters before the rank number of the identifier
%(optional)
if(~isnumeric(data));
    error('data is not numeric');
end 

if(nargin<2);coderow='';end;
if(nargin<3);codecol='';end;
[n,p]=size(data);
saisir.d=data;
saisir.i=addcode(num2str((1:n)'),coderow);
saisir.v=addcode(num2str((1:p)'),codecol);

