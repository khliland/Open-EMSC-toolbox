function res=group_centering(X,group);
%group_centering           - Centers data according to groups
%function res=group_centering(X,group);

ngroup=max(group.d);
for g=1:ngroup
    xmean(g,:)=mean(X.d(group.d==g,:));
end
res=X;
[n,p]=size(X.d);
for i=1:n
    res.d(i,:)=res.d(i,:)-xmean(group.d(i),:);
end

