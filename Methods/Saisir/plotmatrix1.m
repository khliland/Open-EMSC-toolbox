function plotmatrix1(s,startpos,endpos,charsize)
%plotmatrix1          - biplots of columns of matrices with colors 
%function plotmatrix1(s,startpos,endpos,charsize)

cla;
clf;
if(nargin<4)
    charsize=8;
end
[n,p]=size(s.d);
k=0;
xl='';
yl='';
for grow=1:p
    for gcol=1:p
        k=k+1;
        subplot(p,p,k);
        if(p<5)
        xl=s.v(grow,:);yl=s.v(gcol,:);
         end;
        %         if(grow==p)
%             xl=s.v(grow,:);
%         end
%         if(gcol==1)
%             yl=s.v(gcol,:);
%         end
%         
        if(grow==gcol)
             labelled_hist(s,grow,startpos,endpos,30,charsize);
             title('');
             if(p<5)
                 h=xlabel(['class of ' s.v(grow,:)]);
                %get(h)
                set(h,'FontSize',8);
                h=ylabel('Abs. Freq.');
                set(h,'FontSize',8);
            end;    
         else
             aux=min([grow gcol]);
             [aux index]=sort(s.d(:,aux));%% in order to have histogram and map with same colors
             s=selectrow(s,index);   
             carte_couleur1(s,grow,gcol,startpos,endpos,xl,yl,'',charsize);    
        end    
    end
end
hold off;