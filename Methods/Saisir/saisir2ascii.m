function saisir2ascii(saisir,filename,separator)
%saisir2ascii 	    - Saves a saisir file into a simple ASCII format 
%function saisir2ascii(X,filename,separator)
%Transform a saisir file into a simple .txt file and save it on disk
%separator is a single character like ' ' or ';' or its ASCII code;

separator=char(separator);
[n,p]=size(saisir.d);
filename=upper(filename);
if(isempty(findstr('.txt',filename)))
   filename=[filename '.txt'];
end
fid=fopen(filename,'w');
xformat1=['%s' separator];
fprintf(fid,xformat1,'  ');
for col=1:p-1
	fprintf(fid,xformat1,deblank(saisir.v(col,:)));
end
fprintf(fid,xformat1,deblank(saisir.v(p,:)));
fprintf(fid,'\n');
xformat2=['%s ' separator];
xformat3=['%0.5g ' separator];
for row=1:n
   fprintf(fid,xformat2,saisir.i(row,:));
   %fprintf(fid,'%s ;',saisir.i(row,:));
   fprintf(fid,xformat3,saisir.d(row,1:p-1));
   fprintf(fid,'%0.5g \n',saisir.d(row,p));
end
fclose(fid);

