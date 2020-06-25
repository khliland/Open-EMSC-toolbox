function [names] = mir_style(names1)
%mir_style		- changes the sign of the variables of MIR spectra
%in order to have the usual sense on the graph of mid infrared spectra
%function [names] = mir_style(names1)

[n,p]=size(names1);
aux=-1*(str2num(names1));
for i=1:n
   aux1=[num2str(aux(i)) '                                         '];
   names(i,:)=aux1(1:20);
end
