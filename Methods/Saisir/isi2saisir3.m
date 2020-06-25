function [saisir] = isi2saisir3(filename)
%isi2saisir3			- Loads NIR data obtained with ISI software from disk
%function [saisir] = isi2saisir1(filename)
% The NIR data obtained from isi software (on a NIRsystems instrument) must be first
% converted into ASCII files by using the management program 
%In this way, it is possible to obtain ASCII files with the extension
% ".txt". 
% the program reads the files and give them the SAISIR format.
% A few extra work may be needed to adapt this functione program for other situation
display('This function normally works on files from ISI software, transposed file');
filename=upper(filename);
%if(isempty(findstr('.TXT',filename)))
%   filename=[filename '.TXT'];
%end
fid=fopen(filename);
nline=0;
for i=1:10
line = fgetl(fid);
%nline=nline+1
disp(line);
end
%fclose(fid);
nind=0;
while 1
   nind=nind+1;
   line = fgetl(fid);%% decoding first line (with identifier)
   if ~isstr(line); break;end;
   place=findstr(line,' ');
   nspace=size(place,2);
   nom=[line(1:place(nspace-8)-1) '                       '];
   saisir.i(nind,:)=nom(1:10);
   disp(nind);
   disp(nom);
   %disp(line);
   aux=line(place(nspace-8)+1:size(line,2));
   vector=str2num(aux);
   for i=2:132
   line = fgetl(fid);   
   vector=[vector str2num(line)];
	end   
   %size(vector)
   %vector(1)
   %vector(size(vector,2))
   saisir.d(nind,:)=vector;
   %pause;   
end
saisir.v=num2str((400:2:2498)');

