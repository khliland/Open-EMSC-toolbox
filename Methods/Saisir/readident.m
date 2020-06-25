function [ident, nident] = readident(filename,namesize)
%readident 			- loads a file of strings
%usage: [res,nindent]=readident(filename, (namesize))
%loads an array of string in a matrix format
%namesize gives the maximum number of characters in each string

aux='';
size=10;
if(nargin>1); size=namesize;end;
nident=0;compte=0;
vide=blanks(size);
%file=[currentpath filename];
file =filename;
[ '**' file '**']
fid=fopen(file,'rt');
tmp=fgetl(fid);
while tmp~=-1
	compte=compte+1;
	nident=nident+1;
	chaine=[tmp vide];
	ident(nident,:)=chaine(1:size);
	tmp=fgetl(fid);
	if compte==100
		disp([tmp,num2str(nident)]);
		compte=0;
	end
end
fclose(fid)

 