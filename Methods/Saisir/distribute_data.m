function [saisir] = distribute_data(row_identifier, model,startpos, endpos)
%distribute_data       - distributes the values of model according to row_identifier 
%function [saisir] = distribute_data(row_identifier, model,(startpos),(endpos))
%row_identifiers is a matrix of char giving the identifiers (.i in the SAISIR format
%model is a saisir structure given the numerical values to be attributed to
%the row_identifier. 
%Works only if each row_identifier is a string present in model.i
% if startpos and endpos are defined, the comparison leads only on the character string in the 
% row_identifiers going from startpos to endpos
saisir.i=row_identifier;
[n1,p1]=size(model.i);
[n2,p2]=size(row_identifier);
[n3,p3]=size(model.d);

if(nargin>2)
    row_identifier=row_identifier(:,startpos:endpos);
end
if(p1~=p2)
   code='                                     ';
   aux=char(ones(n1,1)*code);
   model.i=[model.i aux];
   model.i=model.i(:,1:20);
   aux=char(ones(n2,1)*code);
   row_identifier=[row_identifier aux];
   row_identifier=row_identifier(:,1:20);
end
saisir.d=zeros(n2,p3);
saisir.d=saisir.d+nan;% matrix of Nan data
for i=1:n1;
    aux=model.i(i,:);
    index = seekstring(row_identifier,aux);
    if(~isempty(index));%% identifier found
        n4=size(index,1);
        saisir.d(index,:)=ones(n4,1)*model.d(i,:);
    end
end
saisir.v=model.v;
test=sum(sum(isnan(saisir.d)));
if(test~=0)
    disp('Warning ! Some row identifiers did not find any correspondence in the model');
    disp('Values are set to NaN in this case ');
end



