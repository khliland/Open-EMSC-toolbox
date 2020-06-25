function check=saisir_check(x)
%saisir_check        - Checks if the data respect the saisir stucture
%function check=saisir_check(x)
% check = 1 if x is in the SAISIR format (no warning)
% check = 2 if x is in the SAISIR format (with warning)
% check = 0 if x is not in the SAISIR format (fatal error)
check=0;
disp('Checking');
disp(' ');disp(' ');
if(~isfield(x,'d'))
    disp('================?');
    disp('FATAL ERROR: the field ''.d''does not exist. See the manual for more information, or/and function MATRIX2SAISIR');
    disp('The manual is in the Word file ''SAISIR.DOC');
return;
end
if(~isfield(x,'v'))
    disp('================?');
    disp('FATAL ERROR: the field ''.v'' does not exist. See the manual for more information, or/and function MATRIX2SAISIR');
    disp('The manual is in the Word file ''SAISIR.DOC');
return;
end;

if(~isfield(x,'i'))
    disp('================?');
    disp('FATAL ERROR: the field ''.i'' does not exist. See the manual for more information, or/and function MATRIX2SAISIR');
    disp('The manual is in the Word file ''SAISIR.DOC');
return;
end;
test=eval('x.d(1,1)+pi','1234');
%test
if(test==1234)
    disp('================?');
    disp('FATAL ERROR: the data cannot be converted in valuable numerical values ');
    disp('Operation such as ''addition with ordinary floating number'' is not defined on the data'); 
return;
end;
if(~isfield(x,'i'))
    disp('================?');
    disp('FATAL ERROR: the field ''.i'' does not exist. See the manual for more information, or/and function MATRIX2SAISIR');
    disp('The manual is in the Word file ''SAISIR.DOC');
return;
end;

[n,p]=size(x.d);
%disp(['data matrix including ' num2str(n) ' rows and ' num2str(p) ' columns']);
[p1,n1]=size(x.v);
[n2,p2]=size(x.i);

if(p1~=p)
disp('================?');
disp('FATAL ERROR: the number of identifiers of variable (''.v'') is not consistent with the number of columns in the data matrix');
disp('See the manual in the Word file ''SAISIR.DOC');
return;
end

if(n2~=n)
disp('================?');
disp('FATAL ERROR: the number of identifiers of individual(''.i'') is not consistent with the number of rows in the data matrix');
disp('See the manual in the Word file ''SAISIR.DOC');
return;
end
check=1;
test=sum(sum(isnan(x.d)));
if(test~=0)
    check=2;
    disp('================?');
    disp('SEVERE WARNING: the data file contains Not a Number data. SAISIR functions do not work properly with NaN data');
    disp('Possible use ELIMINATE_NAN1 before continuing');
    disp('Indices of Nan values (row columns] :');
    [row,col]=find(isnan(x.d));
    disp([row col]);
end
if(sum(nanstd(x.d)==0)>0)
    check=2;
    disp(' ');
    disp('LIGHT WARNING: the standard deviation of some columns is null. One column or more contains exactly the same number ');
    disp('Are you satisfied with that ?');
    disp('Such columns have indices :');
    disp(find(nanstd(x.d)==0))
end

if(sum(nanstd((x.d'))==0)>0)
    disp(' ');
    disp('LIGHT WARNING: the standard deviation of some rows is null. One row or more contains exactly the same number ');
    disp('Are you satisfied with that ?');
    disp('Such rows have indices :');
    disp(find(nanstd(x.d')==0));
end
disp('======================================');
disp('THIS FILE HAS BEEN SUCCESSIFULLY TESTED');
disp(['Data matrix including ' num2str(n) ' rows and ' num2str(p) ' columns']);
disp(' ');
disp(['Identifier of the first row : ' x.i(1,:)]);
disp(['Identifier of the last row : ' x.i(n,:)]);
disp(' ');
disp(['Identifier of the first column : ' x.v(1,:)]);
disp(['Identifier of the last column  : ' x.v(p,:)]);
    

