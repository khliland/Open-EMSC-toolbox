function [saisir1] = eliminate_nan1(saisir,row_or_col)
%eliminate_nan1		- suppresses "not a number" data in a saisir structure
%From a given saisir file possibly containing NaN values (not determined values)
% create a file of known values
%function [saisir1] = eliminate_nan(saisir,(row_or_col))
% With only one argument: tries to optimise the elimination of rows or col
% in ordrer to have the greatest number of non eliminated data
% if row_or_col==0 tries to have the maximum number of rows
% if row_or_col==1 tries to have the maximum number of columns
[n,p]=size(saisir.d);
%select_row=zeros(1,n);
if(nargin>1)
select_col=zeros(1,p);
if(row_or_col==0)
   select_col=zeros(1,p);
    for col=1:p
      if(sum(isnan(saisir.d(:,col)))~=0); select_col(col)=1; end
   end
   saisir1=deletecol(saisir,select_col==1);
   disp([num2str(sum(select_col)) ' columns eliminated']); 
   return;
else
   select_row=zeros(1,n);
   for row=1:n
      if(sum(isnan(saisir.d(row,:)))~=0); select_row(row)=1; end
   end
   saisir1=deleterow(saisir,select_row==1);
   disp([num2str(sum(select_row)) ' rows eliminated']); 
   return;
end
else % case optimisation
    while(1)
        [n,p]=size(saisir.d);
        row_choice=ones(1,n)*p-sum(isnan(saisir.d'));% maximum data kept
        %size(ones(p,1))
        %size(sum(isnan(saisir.d)))
        col_choice=ones(1,p)*n-sum(isnan(saisir.d));% 
        [minrow,indexrow]=min(row_choice);
        [mincol,indexcol]=min(col_choice);
        [minabs,indexabs]=min([minrow mincol]);
        if(sum(sum(isnan(saisir.d)))==0)% nom more Nan data
            saisir1=saisir;
            break;% break from while loop
        end
        switch indexabs
            case 1
              %indexrow
               %disp(['elimination of row ' saisir.i(indexrow,:)]);       
               saisir=deleterow(saisir,indexrow);     
           case 2    
               %indexcol
               %disp(['elimination of column ', saisir.v(indexcol,:)]);           
               saisir=deletecol(saisir,indexcol); 
       %pause        
       end             
    end
end
    
        
    

