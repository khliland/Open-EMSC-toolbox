function [saisir] = saisir_transpose(saisir1)
%saisir_transpose 		- transposes a data matrix following the saisir format
% function [saisir] = saisir_transpose(saisir1)
% transposition of a struct at the saisir format
saisir.v=saisir1.i;
saisir.i=saisir1.v;
saisir.d=saisir1.d';