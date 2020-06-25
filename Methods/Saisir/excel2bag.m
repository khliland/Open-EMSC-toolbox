function [saisir,bag] = excel2bag(filename,ref_text_col,nchar,deb,xend)
%excel2bag         	- reads an excel file and creates the corresponding text bag
%(array of caracter)
%function [saisir,bag] = excel2bag(filename,ref_text_col,(nchar),(deb),(xend))
%reads an excel file which has been saved under the format .csv (the delimiters are ';')
%the excel file includes the identifers of rows and columns 
%filename       :excelfile in the '.csv' format 
%nchar          :number of characters read in each cell of the excel files
%                (the other are ignored)
%ref_text_col   :an array of string giving the reference of columns designed as forming the columns of bag.d.
%               THESE COLUMNS ARE DESIGNATED USING THE EXCEL STYLE ('AA','AB' ....)    
%deb            : number of the first row decoded
%xend           : final row decoded 
%output      : saisir follows the usual logic.
%bag is a structure (bag.d,bag.i,bag.v), with bag.d being here a matrix of char  
%saisir contains the numerical values from the excel file, with the exception of the columns referenced by ref_text_col
%bag contains the charactesl values from the excel file, referenced by ref_text_col
%Example:
%[value,bag]=excel2bag('olive',['A'; 'B'],20)
%the columns 'A' and 'B' from excel are read as text (in output bag)
%the other columns are read as number (in value) respecting the saisir
% structure. 
filename=upper(filename);
if(isempty(findstr('.CSV',filename)))
   filename=[filename '.CSV'];
end
if(nargin<3) nchar=20;end;
if(nargin>3)
   data = readexcel1(filename,nchar,deb,xend);
else
   data = readexcel1(filename,nchar);
end;   
%% part devoted to extraction of text !!
% decoding the column number from excel format 
ref_text_col=upper(ref_text_col);
[n1,p1]=size(ref_text_col);

for i=1:n1
    aux=strtok(ref_text_col(i,:));
    L=size(aux,2);
    p=0;
    car=0;
    for j=L:-1:1
       car=(aux(j)+0-'A'+1)*(26^(L-j))+car;    
    end
    place(i)=car;
end
%place
aux=data(1,:,place);
[n1,p1,q1]=size(aux);
for i=1:q1
    bag.v(i,:)=aux(:,:,i);
end
bag.d=data(:,:,place);
bag.d(1,:,:)=[];
bag.i=data(:,:,1);
bag.i(1,:)=[];
%bag.d(:,:,1)=[];

%return
%%elimination of columns considered as text 
saisir = string2saisir(data);
[n,p]=size(saisir.d);
testrow=sum(isnan(saisir.d),2);
%saisir=deleterow(saisir,testrow==p);% elimination of row formed of isnan
%[n,p]=size(saisir.d);
testcol=sum(isnan(saisir.d));
saisir=deletecol(saisir,testcol==n);% elimination of row formed of isnan

