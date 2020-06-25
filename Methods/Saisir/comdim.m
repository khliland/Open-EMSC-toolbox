function[res]=comdim(col,ndim,threshold)
%comdim			- Finding common dimensions in multitable data (saisir format)
% function[res]=comdim(col,(ndim),(threshold))
% Finding common dimensions in multitable according to method 'level3' 
% proposed by E.M. Qannari, I. Wakeling, P. Courcoux and H. J. H. MacFie
% in Food quality and Preference 11 (2000) 151-154
% threshold (optional): if the difference of fit<threshold then break the iterative loop 
% ndim : number of common dimensions
% default: threshold=1E-10; ndim=number of tables
% returns Q : nrow x ndim the observations loadings
% explained : 1 x ndim, percentage explanation given by each dimension  
% saliences : ntable x ndim weight of the original tables in each
% dimensions. 
% col is an ARRAY OF CELLS of saisir files (the numbers of rows in each table must be equal) .
% return data in the saisir format

ntable=size(col,2);
if(nargin<3)
   threshold=1E-10;
end;   
if(nargin<2)
   ndim=ntable;
end;
for(i=1:ntable)
   s{i}=col{i}.d;
end
[Q.d, saliences.d,explained.d]=xcomdim(s,threshold,ndim);
for i=1:ndim
   chaine=['D' num2str(i) '        '];
   bid(i,:)=chaine(1:6);
end
for i=1:ntable
   chaine1=['t' num2str(i) '        '];
   bid1(i,:)=chaine1(1:6);
end

Q.v=bid;
Q.i=col{1}.i;
saliences.v=Q.v;% dimension
saliences.i=bid1;% table
explained.v=Q.v;
explained.i='% explained';
res.Q=Q; res.saliences=saliences; res.explained=explained;