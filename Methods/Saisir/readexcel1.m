function [data] = readexcel1(filename,nchar,deb,xend)
%readexcel1			- reads an excel file in the .CSV format (create a 3way character matrix).
%function [data] = readexcel1(filename,nchar,deb,xend)
%read an exccel file which has been saved under the format .csv (the delimiters are ';')
%the result data is a 3 way file data(row,pos,col)
%row is the excel rows, col the excel columns, and pos is the character in the string
%nchar is the length of the element data(i,:,j), ie the number of characters which are kept
%default: 20
%if the string is less than nchar, the string is filled with white space.
%if the string is more than nchar, the end of the chain is lost
% this is a first step for decoding data coming from excel
% example: mywork=readexcel1('work1.csv',15);
if(nargin<2) nchar=20;end;
a=textread(filename,'%s','delimiter','\n','whitespace','','bufsize',2^14-1);
%a=textread(filename,'%s','whitespace','','bufsize',2^14-1);

[n,p]=size(a);
disp(['Number of rows =' num2str(n)]);

%if(nargin<2) deb=1; xend=n;end;
% The main purpose of readexcel1 is to convert excel into saisir file
% if nargin>2 the value xdeb,xend are the row number of the data
% it is necessary to keep also the first row, which is the name of the identifier
% the index are in fact +1 
if(nargin<3) range=1:n;
else
   aux=xend+1;
   if(aux>n)
      aux=n;
   	disp(['Warning! Number of rows reduced to actual value in readexcel1']);     
   end;
   range=[1 (deb+1):(aux)];
end;
k=0;
for row=range;
   if(mod(row,100)==0)
      disp(row);
   end;   
   chain=a{row};
   chain(chain==',')=';';%% correction for Sébastien Preys data
   field=findstr(chain,';');
   if (row==1)
      %chain
      disp(['Number of columns =' num2str(size(field,2)+1)]);
   end
   field=[0 field size(chain,2)+1];
   k=k+1;
   for i=1:size(field,2)-1
      st=[chain(field(i)+1:field(i+1)-1) blanks(nchar) ];
      % warning: in order to have the string normally presented, the 
      % string MUST correspond to the SECOND index (not the third, nor the first)
      data(k,:,i)=st(1:nchar);
   end   
end
