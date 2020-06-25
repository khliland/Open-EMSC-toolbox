function res=smart_coord(x)
%smart_coord        - Smart coordinates
%function res=smart_coord(x);
%Multiply the columns of x by 1 or -1 in order to have the maximum
%absolute value positive 
%useful for an easy comparison of several factorial maps (PCA or others)
%% two maps rotationnaly equivalent will be identical after this
%% modification
[n,p]=size(x.d);

bid=abs(x.d);

for i=1:p
    [aux index]=max(bid(:,i));
    aux1=x.d(index,i);
    if(aux1<0)
        x.d(:,i)=-x.d(:,i);
    end
end
res=x;

