function [saisir] = isi2saisir2(filename)
%isi2saisir2			- Loads NIR data obtained with ISI software from disk
%function [saisir] = isi2saisir2(filename)
% The NIR data obtained from isi software (on a NIRsystems instrument) must be first
% converted into ASCII files by using the management program 
%In this way, it is possible to obtain ASCII files with the extension
% ".txt". 
% the program reads the files and give them the SAISIR format.
% A few extra work may be needed to adapt this functione program for other situation
%% example of data file:
%"Sample Number"	"00089"	        "00685"	        "00694" ...
%"400.0000"	     0.4567	         0.4052	         0.3942 ...
%"402.0000"	     0.4779	         0.4268	         0.4148 ...
% ....				
display('This function normally works on files from ISI software, transposed file');
filename=upper(filename);
%if(isempty(findstr('.TXT',filename)))
%   filename=[filename '.TXT'];
%end
a=textread(filename,'%s','delimiter','\n','whitespace','','bufsize',2^14-1);
[n,p]=size(a);
disp(['Number of rows =' num2str(n)]);
str_ind=a{1};% first row: name of spectra
nwave=0;
for i=2:n
nwave=nwave+1;
vector=[];
aux=a{i};
aux1=findstr(aux,'"');
wave_name=[aux(aux1(1)+1:aux1(2)-1) blanks(20)];% find the string gibing the wavelength
saisir.i(nwave,:)=wave_name(1:10);%% transposed format !!!
aux=aux((aux1(2)+1):size(aux,2));	
vector=str2num(aux);
saisir.d(nwave,:)=vector;%fills the matrix with absorbance data
%pause
end

aux=findstr(str_ind,'"');
[n1,p1]=size(aux);
disp(str_ind(aux(1)+1:aux(2)-1));
nvar=p1/2-1;%% transposed format !!!
%nvar
for var=1:nvar%% build the identifier of COLUMNS (spectra)
%   aux(var*2+1)
%  aux(var*2+2)
   var_name=[str_ind(aux(var*2+1)+1:aux(var*2+2)-1) blanks(20)];
   saisir.v(var,:)=var_name(1:20);
end
saisir=saisir_transpose(saisir);%% transposition in order to have usual presentation

   