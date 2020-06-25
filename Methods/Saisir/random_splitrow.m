function[saisir1,saisir2]=random_splitrow(saisir, nselect)
%random_splitrow     - random selection of samples
% function[X1,X2]=random_split(X, nselect)
% randomly divide a collection in two collections
% nselect samples in X1 and n-nselect samples in X2
% where n is the number of rows in X
[n,p]=size(saisir.d);
if(nselect<n/2)
	index=random_select(n,nselect);
	[saisir1,saisir2]=splitrow(saisir,index==1);
else
	index=random_select(n,(n-nselect));
	[saisir1,saisir2]=splitrow(saisir,index~=1);
end
