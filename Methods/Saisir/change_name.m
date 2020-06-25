function res=change_name(x,old_name,new_name);
%change_name       - change the name of the observations of file x
% function res=change_name(x,old_name,new_name);
% old_name must contain at least all the identifiers in x.i;
% new_name must have the same number of row than old_name; 
[n,p]=size(x.d);
[n1,p1]=size(new_name);
for i=1:n
    old=x.i(i,:);
    indice=seekstring(old_name,old);
    if(isempty(indice))
    disp(['No correspondence with ' old  ' old name kept' ]);
    aux1=[old '                              '];
    aux(i,:)=aux1(1:p1);
    else
    aux(i,:)=new_name(indice,:);
    end
end
res=x;
res.i=aux;