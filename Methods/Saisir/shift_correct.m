function [saisir] = shift_correct(saisir1,index, index1, index2)
%shift_correct  			- correction of chromatograms from their shifts
% function [saisir] = shift_correct(saisir1,index)
% takes the maximum of each chromatogram and shift the data, in order to set the maximum at 
% a given index
% the search of max is between index and index 2
[nrow ncol]=size(saisir1.d);
saisir.i=saisir1.i;
saisir.d=zeros(nrow,ncol);
saisir.v=saisir1.v;
for i=1:nrow
   %[aux index_max]=max(saisir1.d(i,:));
	 [aux index_max]=max(saisir1.d(i,index1:index2));
   index_max=index_max+index1-1;
   delta=index_max-index;
   %index_max
   if(delta>=0) 
      start=1;
      xend=ncol-delta;
   else
      start=-delta +1;
      xend=ncol;
   end   
   for j=start:xend
      saisir.d(i,j)=saisir1.d(i,j+delta);
	end   
end
