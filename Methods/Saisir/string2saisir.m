function [saisir] = string2saisir(data)
%string2saisir - creation of a saisir file from a string table (first column=name)
%function [saisir] = string2saisir(data)
%creation of a saisir file from a string table obtained by procedure readexcel1
%A DOS file which have been read from readexcel1 is a 3 way matrix of character under
%the form data(row,pos,col). For example, data(5,:,12) contains the string in row 5 and 
% column 12.
%In the particular case of acceptable data for saisir transformation, the data format must be
% the following:
%1) the first row data(1,:,:) must contain the identifier of variables (column)
% warning: for matrix presentation of the data, the string data(1,:,1) is of no use
% and is skipped by the program.  
%2) the first column(:,:,1) must contain the identifier of observations (rows)
%3) the other lines and columns contains string which can be converted in number
% (or whitespace)
% such format is normally obtained by using readexcel1 (excel data saved as .csv)
% If the original excel file was not appropriate, it is possible that several columns
% contain string which could not be transformed in number (or white space).
% in this situation, it is possible to remove the undesired column using
% data(:,:,col)=[]; where col is the index of the column to be removed
% Note that the whitespace are replaced by NAN values 
[n,c,p]=size(data);
for i=2:p
   saisir.v(i-1,:)=data(1,:,i);
end
%saisir.v
for i=2:n
   saisir.i(i-1,:)=data(i,:,1);
end
%saisir.i
n=n-1;
p=p-1;
disp([num2str(n) ' observations and ' num2str(p) ' variables'])
data(1,:,:)=[];
data(:,:,1)=[];
nnan=0;
for row=1:n;
   if(mod(row,100)==0)
      disp(row);
   end;   
   for col=1:p;
      aux=data(row,:,col);
      check=findstr(aux,',');
      if (~isempty(check))
         aux
         aux(check)='.';
         aux
         disp(['Warning "," used in place of "." in ' num2str(row) ' and ' num2str(col)]);
         disp('data corrected');
      end
      a=str2num(aux);
      if((size(a,1)~=1)|(size(a,2)~=1))
         a=NaN;
      	nnan=nnan+1;   
      end
      %row
      %col
      %a
      saisir.d(row,col)=a;
      %str2num(data(row,:,col))
   end
end
if(nnan~=0)
   %disp(['Warning ! ' num2str(nnan) ' Not determined values']);
end
