function saisir=change_identifier(saisir1,startpos,endpos)
%change_identifier		- reduces the characters string of identifiers as startpos:endpos  
%saisir=change_identifier(saisir1,startpos,endpos)
% extract the caracters in position startpos to endpos of the identifiers of rows
% and creates the corresponding saisir structure
[nrow1 ncol1]=size(saisir1.d);
[nrow2 ncol2]=size(saisir1.i);
if(ncol2>10); ncol2=10; end;
for i=1:nrow1
   aux=[saisir1.i(i,startpos:endpos) '                                       '];
   saisir.i(i,1:ncol2)=aux(1:ncol2);
end
saisir.v=saisir1.v;
saisir.d=saisir1.d;

