function [saisir] = excel2saisir(filename,nchar,deb,xend)
%excel2saisir 	- reads an excel file
%function [saisir] = excel2saisir(filename,(nchar),(deb),(xend))
%read an excel file which has been saved under the format .csv (the delimiters are ';')
%the excel file includes the identifers of rows and columns 
%deb : number of the first row decoded, xend: final row decoded 
filename=upper(filename);
if(isempty(findstr('.CSV',filename)))
   filename=[filename '.CSV'];
end
if(nargin<2) nchar=20;end;
if(nargin>2)
   data = readexcel1(filename,nchar,deb,xend);
else
   data = readexcel1(filename,nchar);
end;   
saisir = string2saisir(data);
[n,p]=size(saisir.d);
testrow=sum(isnan(saisir.d),2);
saisir=deleterow(saisir,testrow==p);% elimination of row formed of isnan
[n,p]=size(saisir.d);
testcol=sum(isnan(saisir.d));
saisir=deletecol(saisir,testcol==n);% elimination of row formed of isnan

