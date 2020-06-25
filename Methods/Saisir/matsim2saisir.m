function [saisir] = matsim2saisir(filename)
%matsim2saisir 	- reads a Matsim file
%function [saisir] = Matsim2saisir(filename)
%read a matsim file 
%Matsim is a "matrice de similitude" file as created by the program Matsim
%The format is basically identical with the ".CSV" format of Excel, except that it allows
%more than 256 columns

filename=upper(filename);
if(isempty(findstr('.MTR',filename)))
   filename=[filename '.MTR'];
end
if(nargin<2) nchar=20;end;
if(nargin>2)
   data = readexcel1(filename,nchar,deb,xend);
else
   data = readexcel1(filename,nchar);
end;   
   saisir = string2saisir(data);
	
