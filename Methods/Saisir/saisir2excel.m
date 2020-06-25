function saisir2excel(saisir,filename)
%saisir2excel 	  - Saves a saisir file in a format compatible with Excel
%function saisir2excel(X,filename)
%Transform a saisir file into a .CSV file and save it on disk
%This file can then be read as an excel file (separator : ";")

[n,p]=size(saisir.d);
filename=upper(filename);
if(isempty(findstr('.CSV',filename)))
   filename=[filename '.CSV'];
end
fid=fopen(filename,'w');
fprintf(fid,'%s;','  ');
for col=1:p-1
	fprintf(fid,'%s;',deblank(saisir.v(col,:)));
end
fprintf(fid,'%s',deblank(saisir.v(p,:)));
fprintf(fid,'\n');
for row=1:n
   %fprintf(fid,'$%s ;',saisir.i(row,:));
   fprintf(fid,'%s ;',saisir.i(row,:));
   fprintf(fid,'%0.5g ;',saisir.d(row,1:p-1));
   fprintf(fid,'%0.5g',saisir.d(row,p));
   fprintf(fid,'\n');   
end
fclose(fid);

