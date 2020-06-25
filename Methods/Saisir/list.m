function list(saisir)
%list			- lists rows (only with a small number of columns)
%function list(X)
[n,p]=size(saisir.d);
for i=1:n
   disp([num2str(i) ' ' saisir.i(i,:) '     ' num2str(saisir.d(i,:))]);
	pause
end
