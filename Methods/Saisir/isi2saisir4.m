function [saisir] = isi2saisir4(filename)
%isi2saisir4			- Load NIR data form isi software from disk
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
   aux=a{i};
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
   size(vector)
   saisir.d(nind,:)=vector;
end
saisir.v=num2str((400:2:2498)');

function vector=str2num1(str);
str=[' ' str ' '];
vector=str2num(str);
index=findstr(str,'-');
if(~isempty(index))
    vector=[];
    nel=0;
    disp('Warning ! negative values ');
    disp(str);
    index1=findstr(str,' ');
    index2=findstr(str,'-');
    index=[index1 index2];
    index=sort(index);
    for i=1:size(index,2)-1;
        aux=str(index(i):index(i+1)-1);
        aux1=str2num(aux);
        if(~isempty(aux1));
          nel=nel+1;
          s=size(aux1,2);
          vector(nel:(nel+s-1))=aux1;
          nel=nel+s-1;
          %aux    
        else
            %aux
            index1=findstr(aux,'-');  
            %disp(['*' aux '*']); 
            if(~isempty(index1))
                %situation such as*-0.00030570.0014878*
                disp(['*' aux '*']); 
                num1=str2num(aux(1:10));
                if(~isempty(num1));
                    nel=nel+1;
                    vector(nel)=num1;
                end
                num2=str2num(aux(11:size(aux,2)));
                if(~isempty(num2));
                    nel=nel+1;
                    vector(nel)=num2;
                end
                disp([num1 num2]);    
            end
        end    
    end    
end