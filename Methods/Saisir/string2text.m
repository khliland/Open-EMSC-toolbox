function string2text(str,filename)
%string2text  	- save a vector of string in a .txt format 
%function string2text(str,filename)
[n,p]=size(str);
filename=upper(filename);
if(isempty(findstr('.TXT',filename)))
   filename=[filename '.TXT'];
end
fid=fopen(filename,'w');
for row=1:n
   fprintf(fid,'%s\n',str(row,:));
end
fclose(fid);


