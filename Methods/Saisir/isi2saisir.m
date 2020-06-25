function [saisir] = isi2saisir(filename)
%isi2saisir		- Loads NIR data form isi software from disk
%function [saisir] = isi2saisir(filename)
% The NIR data obtained from isi software (on a NISsystems instruments) must be first
% converted into ASCII files by using the management program (option print data files)
% with printer off. In this way, it is possible to obtain ASCII files with the extension
% ".DAT". 
% the program reads the files and give them the SAISIR format.
% Currently (9/01/2002) only data obtained from fiber probe between 400 to 2198 nm at
% intervals of 2 nm (900 data points) are considered.
% A few extra work is needed to adapt the program for other situation
% the next to last line "saisir.v=num2str((400:2:2198)')" must be modified;

display('Wavelengths ranging from 400 to 2198 nm at interval of 2 nm (fiber probe mode)');
filename=upper(filename);
if(isempty(findstr('.DAT',filename)))
   filename=[filename '.DAT'];
end

a=textread(filename,'%s','delimiter','\n','whitespace','','bufsize',2^13-1);
[n,p]=size(a);
disp(['Number of rows =' num2str(n)]);
%saisir=a;% for test
current_line=6;
nind=0;
for i=current_line:n
	str=a{i};
   aux=findstr(str,'Samp number');% new sample detected
   if(~isempty(aux))
      nind=nind+1;
      aux=[str '                 ']
		saisir.i(nind,:)=aux(1,14:14+12);
		disp([num2str(nind) ' ' saisir.i(nind,:)])
      if(nind>1)
	      saisir.d(nind-1,:)=vector;
      	%size(vector)   
      end;
   vector=[];   
   else
      vector=[vector str2num(str)];
   end;
end;
saisir.d(nind,:)=vector;
saisir.v=num2str((400:2:2198)');
disp([num2str(nind) ' spectra loaded']);
