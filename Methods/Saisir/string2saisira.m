function [saisir] = string2saisira(data,iname)
%string2saisira - creation of a saisir file from a string table (with name coding)
%function [saisir] = string2saisir(data,inname)
%creation of a saisir file from a string table obtained by procedure readexcel1
%A DOS file which have been read from readexcel1 is a 3 way matrix of character under
%the form data(row,pos,col). For example, data(5,:,12) contains the string in row 5 and 
% column 12.
%In the particular case of acceptable data for saisir transformation, the data format must be
%be able to find numerical data, row and column identifiers.
%The column identifiers (.v) are formed from the first row of "data"
%The row identifier are formed by merging the character chains which corresponds to 
%the columns indicated by inname (which are supposed to be alphanumeric
% example: data= 'protein' 'lipid  ' 'specie ' 'starch  ' 'replic '
%					  '10.3   ' '4.0    ' 'Wheat  ' '70.O    ' 'a      ' 	
%					  '10.2   ' '4.1    ' 'Wheat  ' '72.O    ' 'b      ' 	
%					  '12.3   ' '6.0    ' 'Maize  ' '70.O    ' 'a      ' 	
%					  '12.1   ' '5.1    ' 'Maize  ' '72.O    ' 'b      ' 	
%res=string2saisira(data,[3 5])
%will create: res.i= 'Wheat  a      '			(concatenation of col 3 and 5)
%							'Wheat  b      '
%							'Maize  a      '
%							'Maize  b      '
%
%					res.v='protein'
%							'lipid  '
%							'starch '
%
%					res.d= 10.3   4.0   70.O  	
%					  		 10.2   4.1   72.O  	
%					  		 12.3   6.0   70.O  	
%					  		 12.1   5.1   72.O  	
% J'EN SUIS LA *************************************************************************
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
disp([num2str(n) ' observations and 'num2str(p) ' variables'])
data(1,:,:)=[];
data(:,:,1)=[];
nnan=0;
for row=1:n;
   for col=1:p;
      a=str2num(data(row,:,col));
      if(size(a,1)~=1)
         a=NaN;
      	nnan=nnan+1;   
      end
      saisir.d(row,col)=a;
      %str2num(data(row,:,col))
   end
end
disp(['Warning ! ' num2str(nnan) ' Not determined values']);