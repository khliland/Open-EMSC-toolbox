function str=num2str1(number,ndigit);
%num2str1      -  Justified num2string
%function str=num2str1(number,ndigit);
aux=char('0'*ones(1,ndigit));
aux1=num2str(number);
[n,p]=size(aux1);
str=[aux(1:ndigit-p) aux1];
