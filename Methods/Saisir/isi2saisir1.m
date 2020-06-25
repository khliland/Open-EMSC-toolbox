function [saisir] = isi2saisir1(filename)
%isi2saisir1			- Loads NIR data form isi software from disk
%function [saisir] = isi2saisir1(filename)
% The NIR data obtained from isi software (on a NISsystems instruments) must be first
% converted into ASCII files by using the management program (option print data files)
% with printer off. In this way, it is possible to obtain ASCII files with the extension
% ".DAT". 
% the program reads the files and give them the SAISIR format.
% A few extra work is needed to adapt the program for other situation

display('Wavelengths ranging from 400 to 2498 nm at interval of 2 nm (DSC model)');
filename=upper(filename);
if(isempty(findstr('.DAT',filename)))
   filename=[filename '.DAT'];
end

a=textread(filename,'%s','delimiter','\n','whitespace','','bufsize',2^13-1);
[n,p]=size(a);
disp(['Number of rows =' num2str(n)]);
%saisir=a;% for test
current=11
nind=0;
%range from 400 to 2498 nm = 1050 points
% 8 results for each row, therefore int(1050/8)+1 rows = 132 
for i=current:132:n
%   disp(num2str(i));
%   disp([num2str(i-1) 'xxx' a{i-1} 'xxx']);
	nind=nind+1;
%	disp([num2str(i) 'xxx' a{i} 'xxx']);
%  disp([num2str(i+1) 'xxx' a{i+1} 'xxx']);
	vector=[];
   aux=a{i}
   aux1=findstr(aux,' ');
   name=[ aux(1:aux1) blanks(20) ];
   saisir.i(nind,:)=name(1:20);
   disp(saisir.i(nind,:));
   aux=aux(aux1:size(aux,2));	
   vector=str2num1(aux);
   for j=i+1:i+131
       %a{j}
       vector=[vector str2num1(a{j})];
   end
   %size(vector)
   saisir.d(nind,:)=vector;
end
saisir.v=num2str((400:2:2498)');

function vector=str2num1(str);
vector=str2num(str);
index=findstr(str,'-');
if(~isempty(index))
    disp('Warning ! negative values ');
end