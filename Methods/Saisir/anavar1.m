function res = anavar1(saisir,g)
%anavar1				 - One way analysis of variance on spectral data
%function res = anavar1(X,g)
%Perform a one-way analysis of variance for each of the column of X.
%g is the Saisir file indicating the groups. 
% The function returns
% res.F : vector of Fisher values for each variable in X
% res.p : vector of associated probabilities.
% Note: res.F and res.p can be examined as curves (using COURBE function)
% or by the command show_vector (for discrete variables)
%SAISIR FUNCTION

[n,p]=size(saisir.d);
group=g.d;
group = group(:);
maxi = max(group);
lx = n;
for i=1:p
   if(mod(i,50)==0)
      disp(i);
   end
   
   x=saisir.d(:,i);
	x = x(:);
%   size(x)
   xm = zeros(1,maxi);
   countx = xm;
   for j = 1:maxi
      k = find(group == j);
      if j == 1
         M = x(k);
      else
         [r, c] = size(M);
         lk = length(k);
         if lk > r
       tmp = NaN;
            M(r+1:lk,:) = tmp(ones(lk - r,c));
            tmp = x(k);
            M = [M tmp];
         else
            tmp = x(k);
            tmp1 = NaN;
            tmp((lk + 1):r,1) = tmp1(ones(r - lk,1));
            M = [M tmp];
         end
      end
      countx(j) = length(k);
      xm(j) = mean(x(k));               % column means
   end
   gm = mean(x);                       % grand mean
   df1 = maxi - 1;                     % Column degrees of freedom
   df2 = lx - maxi;                    % Error degrees of freedom
   RSS = countx .* (xm - gm)*(xm-gm)'; % Regression Sum of Squares
	TSS = (x(:) - gm)'*(x(:) - gm);    % Total Sum of Squares
	SSE = TSS - RSS;                   % Error Sum of Squares
	if (SSE~=0)
   	F = (RSS/df1) / (SSE/df2);
   	p = 1 - fcdf(F,df1,df2);     % Probability of F given equal means.
	elseif (RSS==0)                 % Constant Matrix case.
   	F = 0;
   	p = 1;
	else                            % Perfect fit case.
   	F = Inf;
   	p = 0;
	end
   f(i)=F;
   P(i)=p;
end
res.F.d=f;
res.F.v=saisir.v;
res.F.i='F value';
res.P.d=P;
res.P.v=saisir.v;
res.P.i='Probability value';
res.F.df=[num2str(df1) '/' num2str(df2)];

