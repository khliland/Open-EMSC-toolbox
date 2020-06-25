function saisir = readexcel(filename,nchar)
%readexcel    - reads an excel file saved in the .CSV format
%[saisir] = readexcel(filename,nchar)
%see excel2saisir
saisir = excel2saisir(filename,nchar);

